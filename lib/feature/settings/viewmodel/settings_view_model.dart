import 'package:crying_time/app/di/service_locator.dart';
import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/get_pickup_info.dart';
import 'package:crying_time/domain/usecase/get_push_schedule.dart';
import 'package:crying_time/domain/usecase/save_pickup_info.dart';
import 'package:crying_time/domain/usecase/set_push_enabled.dart';
import 'package:crying_time/domain/usecase/update_push_schedule.dart';
import 'package:crying_time/domain/usecase/usecase.dart';
import 'package:crying_time/feature/common/failure_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_view_model.g.dart';

/// 설정 화면이 한 번에 그리는 값.
///
/// 알림 시점 안내 문구가 다음 수령 가능일을 쓰고, 수령량을 바꾸면 그 날짜가 다시
/// 계산되므로 수령 기록과 알림 설정을 한 상태로 묶는다.
class SettingsState {
  const SettingsState({required this.pickupInfo, required this.schedule});

  final PickupInfo pickupInfo;
  final PushSchedule schedule;
}

/// 설정 화면의 상태와 조작.
///
/// 변경 메서드는 실패 문구(성공이면 null)를 돌려준다. 스낵바를 띄우는 일은
/// 화면의 몫이라 viewmodel 이 BuildContext 를 알 필요가 없다.
@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  /// 서버로 나가는 변경을 한 줄로 세우는 체인.
  ///
  /// HTTP 는 도착 순서를 보장하지 않아, 연타로 겹친 요청 중 늦게 닿은 옛 값이
  /// 서버의 최신 상태를 덮어쓸 수 있다. 앞 요청이 끝난 뒤에 다음 요청을 보내면
  /// 서버가 보는 순서가 사용자가 누른 순서와 같아진다.
  Future<void> _pending = Future<void>.value();

  @override
  Future<SettingsState> build() => _load();

  Future<SettingsState> _load() async {
    final getPickupInfo = getIt<GetPickupInfo>();
    final getPushSchedule = getIt<GetPushSchedule>();

    final infoResult = await getPickupInfo(const NoParams());
    final info = switch (infoResult) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
    if (info == null) {
      // 설정은 온보딩을 마친 뒤에만 열린다. 기록이 없다면 그릴 값 자체가 없다.
      throw const NotFoundFailure();
    }

    final scheduleResult = await getPushSchedule(const NoParams());
    return switch (scheduleResult) {
      Ok(:final value) => SettingsState(pickupInfo: info, schedule: value),
      Err(:final failure) => throw failure,
    };
  }

  /// 푸시 스위치.
  ///
  /// 시점은 건드리지 않고 수신 여부만 보내는 별도 요청이다. 서버에 걸린 시점이
  /// 그대로 남아 있어야 다시 켰을 때 사용자가 새로 고르지 않아도 된다.
  Future<String?> togglePush() {
    final next = _applyOptimistically(
      (schedule) => schedule.copyWith(enabled: !schedule.enabled),
    );
    if (next == null) {
      return Future<String?>.value();
    }

    return _enqueue(
      () async => _report(
        await getIt<SetPushEnabled>()(SetPushEnabledParams(schedule: next)),
      ),
    );
  }

  Future<String?> toggleD7() => _updateSchedule(
    (schedule) => schedule.copyWith(notifyD7: !schedule.notifyD7),
  );

  Future<String?> toggleD3() => _updateSchedule(
    (schedule) => schedule.copyWith(notifyD3: !schedule.notifyD3),
  );

  Future<String?> toggleDDay() => _updateSchedule(
    (schedule) => schedule.copyWith(notifyDDay: !schedule.notifyDDay),
  );

  Future<String?> toggleCustom() => _updateSchedule(
    (schedule) => schedule.copyWith(customEnabled: !schedule.customEnabled),
  );

  /// − / + 로 직접 지정 일수를 바꾼다.
  ///
  /// 일수를 만졌다는 건 그 시점에 알림을 받겠다는 뜻이므로 체크도 같이 켠다.
  /// 상한은 주기에서 나온다. 오프셋이 주기 이상이면 발송일이 마지막 수령일보다
  /// 앞서 버리기 때문이다.
  Future<String?> changeCustomDays(int delta) {
    final cycleDays = state.value?.pickupInfo.cycleDays;
    if (cycleDays == null) {
      return Future<String?>.value();
    }

    return _updateSchedule(
      (schedule) => schedule.copyWith(
        customDays: (schedule.customDays + delta).clamp(
          PushSchedule.minCustomDays,
          PushSchedule.maxCustomDaysFor(cycleDays),
        ),
        customEnabled: true,
      ),
    );
  }

  /// 수령량을 바꾼다. 주기와 다음 수령 가능일이 함께 바뀌므로 저장 유즈케이스가
  /// 서버 예약까지 새 기준일로 다시 맞춘다.
  Future<String?> changeBoxes(int delta) {
    final current = state.value;
    if (current == null) {
      return Future<String?>.value();
    }

    final boxes = (current.pickupInfo.boxes + delta).clamp(
      PickupInfo.minBoxes,
      PickupInfo.maxBoxes,
    );
    if (boxes == current.pickupInfo.boxes) {
      return Future<String?>.value();
    }

    final info = current.pickupInfo.copyWith(boxes: boxes);
    // 주기와 안내 문구가 즉시 새 값으로 보이도록 화면부터 갈아끼운다.
    // 직접 지정 오프셋은 저장 유즈케이스가 새 주기 안으로 당겨서 내보내므로,
    // 화면에도 같은 규칙을 적용해야 기기·서버에 남는 값과 갈라지지 않는다.
    state = AsyncData(
      SettingsState(
        pickupInfo: info,
        schedule: current.schedule.clampedTo(info.cycleDays),
      ),
    );

    return _enqueue(() async {
      final savePickupInfo = getIt<SavePickupInfo>();
      final result = await savePickupInfo(
        SavePickupInfoParams(pickupDate: info.pickupDate, boxes: info.boxes),
      );

      return _report(result);
    });
  }

  /// 알림 설정 변경의 공통 흐름.
  ///
  /// 토글이 손끝을 따라오도록 화면은 줄 세우지 않고 곧바로 바꾸고, 서버로 나가는
  /// 요청만 체인에 붙인다. 요청은 부분 변경분이 아니라 그 시점의 스케줄 전체를
  /// 담고, 응답으로 state 를 덮어쓰지 않는다.
  Future<String?> _updateSchedule(
    PushSchedule Function(PushSchedule schedule) transform,
  ) {
    final nextPickupDate = state.value?.pickupInfo.nextPickupDate;
    final next = _applyOptimistically(transform);
    if (next == null || nextPickupDate == null) {
      return Future<String?>.value();
    }

    return _enqueue(
      () async => _report(
        await getIt<UpdatePushSchedule>()(
          UpdatePushScheduleParams(
            schedule: next,
            nextPickupDate: nextPickupDate,
          ),
        ),
      ),
    );
  }

  /// 화면을 새 설정으로 먼저 갈아끼우고 그 설정을 돌려준다. 아직 읽지 못했으면 null.
  PushSchedule? _applyOptimistically(
    PushSchedule Function(PushSchedule schedule) transform,
  ) {
    final current = state.value;
    if (current == null) {
      return null;
    }

    final next = transform(current.schedule);
    state = AsyncData(
      SettingsState(pickupInfo: current.pickupInfo, schedule: next),
    );
    return next;
  }

  Future<String?> _report(Result<Object?> result) async => switch (result) {
    Ok() => null,
    Err(:final failure) => await _recoverFrom(failure),
  };

  /// 요청 하나를 체인 끝에 붙인다.
  Future<String?> _enqueue(Future<String?> Function() request) {
    final queued = _pending.then((_) => request());
    // 한 번 터진 요청이 뒤따르는 조작까지 막지 않도록 오류를 여기서 흡수한다.
    _pending = queued.then<void>((_) {}, onError: (Object _) {});
    return queued;
  }

  /// 변경이 실패했을 때 화면을 기기에 저장된 값으로 되돌린다.
  ///
  /// 통신만 실패했다면 로컬은 이미 새 값이라 낙관적 화면 그대로 수렴하고, 로컬
  /// 쓰기가 실패했다면 옛 값이 다시 올라와 화면과 기기가 갈라지지 않는다.
  Future<String?> _recoverFrom(Failure failure) async {
    final recovered = await AsyncValue.guard(_load);
    // 요청이 도는 사이 사용자가 설정을 닫았을 수 있다. 그때 state 를 건드리면
    // 폐기된 provider 라 StateError 가 나고, 그 예외는 아무도 잡지 않는다.
    if (ref.mounted) {
      state = recovered;
    }
    return failure.message;
  }
}
