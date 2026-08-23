import 'dart:async';

import 'package:crying_time/app/di/service_locator.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/get_pickup_info.dart';
import 'package:crying_time/domain/usecase/register_device.dart';
import 'package:crying_time/domain/usecase/sync_push_schedule.dart';
import 'package:crying_time/domain/usecase/usecase.dart';
import 'package:crying_time/feature/router/routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_view_model.g.dart';

/// 로고를 최소한 이 시간만큼은 보여준다. 조회가 즉시 끝나도 화면이 깜빡이지 않게 한다.
const Duration _minimumExposure = Duration(milliseconds: 1700);

/// 스플래시가 끝난 뒤 갈 경로(Routes.home 또는 Routes.onboarding).
@riverpod
class SplashViewModel extends _$SplashViewModel {
  @override
  Future<String> build() async {
    // 기기 등록과 알림 재동기화는 푸시 발송에만 필요할 뿐이라, 화면 진행을
    // 붙잡아 둘 이유가 없다. 결과도 기다리지 않는다.
    unawaited(_syncServer());

    final (_, loaded) = await (
      Future<void>.delayed(_minimumExposure),
      getIt<GetPickupInfo>()(const NoParams()),
    ).wait;

    return switch (loaded) {
      Ok(:final value) => value == null ? Routes.onboarding : Routes.home,
      // 조회가 실패해도 스플래시에 가둘 수는 없다. 온보딩에서 다시 입력받는다.
      Err() => Routes.onboarding,
    };
  }

  /// 기기 등록을 끝낸 뒤 저장된 알림 설정을 서버 예약과 다시 맞춘다.
  ///
  /// 서버에 기기가 없으면 예약을 걸 대상 자체가 없으므로 등록이 먼저다.
  /// 설정을 바꾸던 순간 통신이 끊겨 서버에 옛 스케줄이 남았더라도, 앱을 켤
  /// 때마다 이 체인이 돌아 사용자가 설정을 다시 건드리지 않아도 복구된다.
  Future<void> _syncServer() async {
    await getIt<RegisterDevice>()(const NoParams());
    await getIt<SyncPushSchedule>()(const NoParams());
  }
}
