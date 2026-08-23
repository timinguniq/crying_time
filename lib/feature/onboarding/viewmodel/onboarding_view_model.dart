import 'package:crying_time/app/di/service_locator.dart';
import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/get_pickup_info.dart';
import 'package:crying_time/domain/usecase/save_pickup_info.dart';
import 'package:crying_time/domain/usecase/usecase.dart';
import 'package:crying_time/feature/common/failure_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_view_model.g.dart';

/// 온보딩 저장이 진행 중인지(isSubmitting).
@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  @override
  bool build() => false;

  /// 오늘 날짜 · 기본 5박스로 수령 기록을 만든다.
  ///
  /// 저장은 서버 예약까지 성공해야 [Ok] 다. 그런데 예약만 실패한 경우에도
  /// 수령 기록은 이미 기기에 남아 있어, 그대로 막으면 첫 실행에 네트워크가
  /// 없는 사용자가 온보딩을 영영 벗어나지 못한다. 그래서 진행 가능 여부와
  /// 알릴 문구를 나눠서 돌려준다.
  Future<({bool canProceed, String? message})> start() async {
    state = true;

    final now = DateTime.now();
    final saved = await getIt<SavePickupInfo>()(
      SavePickupInfoParams(
        // 시각이 남으면 날짜 비교와 주기 계산이 흔들리므로 자정으로 맞춘다.
        pickupDate: DateTime(now.year, now.month, now.day),
        boxes: PickupInfo.defaultBoxes,
      ),
    );

    if (saved case Err(:final failure)) {
      // 기기에 기록이 남았는지로 두 실패를 가른다. 남았으면 서버 예약만 못 건
      // 것이라 알리고 진행시키고, 없으면 저장 자체가 실패한 것이라 붙잡는다.
      final stored = await getIt<GetPickupInfo>()(const NoParams());
      state = false;

      final hasRecord = switch (stored) {
        Ok(:final value) => value != null,
        // 확인조차 못 했다면 저장됐다고 단정할 수 없어 진행시키지 않는다.
        Err() => false,
      };
      return (canProceed: hasRecord, message: failure.message);
    }

    state = false;

    return (canProceed: true, message: null);
  }
}
