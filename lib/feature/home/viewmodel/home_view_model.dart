import 'package:crying_time/app/di/service_locator.dart';
import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/get_pickup_info.dart';
import 'package:crying_time/domain/usecase/get_push_schedule.dart';
import 'package:crying_time/domain/usecase/save_pickup_info.dart';
import 'package:crying_time/domain/usecase/usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

/// 홈이 한 번에 그리는 값 묶음.
class HomeState {
  const HomeState({
    required this.pickupInfo,
    required this.schedule,
    required this.today,
  });

  final PickupInfo pickupInfo;
  final PushSchedule schedule;

  /// 자정으로 잘라 둔 오늘. 화면이 rebuild 될 때마다 `DateTime.now()` 를 다시 읽으면
  /// D-day 계산과 진행률이 프레임마다 흔들릴 수 있어 build 시점 값을 고정해 내려보낸다.
  final DateTime today;
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeState> build() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final getPickupInfo = getIt<GetPickupInfo>();
    final pickupResult = await getPickupInfo(const NoParams());
    final info = switch (pickupResult) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };

    if (info == null) {
      // 수령 기록 없이 홈으로 오는 경로는 없다. 저장이 지워진 비정상 상태이므로
      // 에러 화면을 띄워 사용자가 직접 다시 시도하게 한다.
      throw const NotFoundFailure();
    }

    final getPushSchedule = getIt<GetPushSchedule>();
    final scheduleResult = await getPushSchedule(const NoParams());
    final schedule = switch (scheduleResult) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };

    return HomeState(pickupInfo: info, schedule: schedule, today: today);
  }

  /// '수령 완료' — 오늘을 새 수령일로 저장한다. 수령량은 그대로 둔다.
  ///
  /// 실패는 [Failure] 로 던진다. state 를 에러로 바꾸면 멀쩡한 홈 화면이 통째로
  /// 사라지므로, 호출부가 받아서 SnackBar 로만 알리게 한다.
  Future<void> markReceivedToday() async {
    // 로딩·에러 상태에서 배너가 눌리면 저장할 기준값 자체가 없다. requireValue 로
    // StateError 를 던지면 Failure 만 잡는 호출부를 지나쳐 zone 까지 올라가고
    // 사용자는 아무 피드백도 받지 못하므로 조용히 넘긴다.
    final current = state.value;
    if (current == null) {
      return;
    }

    final savePickupInfo = getIt<SavePickupInfo>();
    final result = await savePickupInfo(
      SavePickupInfoParams(
        pickupDate: current.today,
        boxes: current.pickupInfo.boxes,
      ),
    );

    switch (result) {
      case Ok(:final value):
        state = AsyncData(
          HomeState(
            pickupInfo: value,
            schedule: current.schedule,
            today: current.today,
          ),
        );
      case Err(:final failure):
        throw failure;
    }
  }
}
