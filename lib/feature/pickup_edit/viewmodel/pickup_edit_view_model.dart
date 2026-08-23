import 'package:crying_time/app/di/service_locator.dart';
import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/get_pickup_info.dart';
import 'package:crying_time/domain/usecase/save_pickup_info.dart';
import 'package:crying_time/domain/usecase/usecase.dart';
import 'package:crying_time/feature/common/failure_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pickup_edit_view_model.g.dart';

/// 수령일 변경 화면이 편집 중인 값.
///
/// 저장 버튼을 누르기 전까지는 어디에도 반영되지 않는 임시 값이라
/// [PickupInfo] 대신 별도 상태로 둔다.
class PickupEditState {
  const PickupEditState({
    required this.pickupDate,
    required this.boxes,
    required this.isSaving,
  });

  final DateTime pickupDate;
  final int boxes;
  final bool isSaving;

  /// 주기 계산 규칙을 화면이 다시 구현하지 않도록, 편집 중인 값으로 엔티티를
  /// 만들어 도메인에게 다음 수령 가능일을 물어본다.
  PickupInfo get preview => PickupInfo(pickupDate: pickupDate, boxes: boxes);

  PickupEditState copyWith({
    DateTime? pickupDate,
    int? boxes,
    bool? isSaving,
  }) => PickupEditState(
    pickupDate: pickupDate ?? this.pickupDate,
    boxes: boxes ?? this.boxes,
    isSaving: isSaving ?? this.isSaving,
  );
}

@riverpod
class PickupEditViewModel extends _$PickupEditViewModel {
  @override
  Future<PickupEditState> build() async {
    final result = await getIt<GetPickupInfo>()(const NoParams());

    // 조회에 실패했는데 기본값으로 화면을 열어 주면, 저장하는 순간 멀쩡한
    // 기존 기록을 기본값으로 덮어쓴다. 실패는 그대로 올려 재시도를 시킨다.
    final saved = switch (result) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };

    final now = DateTime.now();
    return PickupEditState(
      pickupDate: saved?.pickupDate ?? DateTime(now.year, now.month, now.day),
      boxes: saved?.boxes ?? PickupInfo.defaultBoxes,
      isSaving: false,
    );
  }

  void changeDate(DateTime date) {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncData(current.copyWith(pickupDate: date));
  }

  void changeBoxes(int delta) {
    final current = state.value;
    if (current == null) {
      return;
    }
    final next = (current.boxes + delta).clamp(
      PickupInfo.minBoxes,
      PickupInfo.maxBoxes,
    );
    if (next == current.boxes) {
      return;
    }
    state = AsyncData(current.copyWith(boxes: next));
  }

  /// 편집 중인 값을 저장한다. 성공이면 null, 실패면 보여줄 문구를 돌려준다.
  Future<String?> save() async {
    final current = state.value;
    if (current == null || current.isSaving) {
      return null;
    }
    state = AsyncData(current.copyWith(isSaving: true));

    final result = await getIt<SavePickupInfo>()(
      SavePickupInfoParams(
        pickupDate: current.pickupDate,
        boxes: current.boxes,
      ),
    );

    switch (result) {
      case Ok():
        // 성공하면 화면이 곧 닫히므로 isSaving 을 되돌리지 않는다. 되돌리면
        // pop 되기 전 짧은 순간에 저장 버튼을 다시 누를 수 있다.
        return null;
      case Err(:final failure):
        state = AsyncData(current.copyWith(isSaving: false));
        return failure.message;
    }
  }
}
