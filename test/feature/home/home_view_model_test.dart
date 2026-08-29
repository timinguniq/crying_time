import 'package:crying_time/app/ads/interstitial_ad_service.dart';
import 'package:crying_time/app/di/service_locator.dart';
import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/get_pickup_info.dart';
import 'package:crying_time/domain/usecase/get_push_schedule.dart';
import 'package:crying_time/domain/usecase/mark_interstitial_shown.dart';
import 'package:crying_time/domain/usecase/record_home_visit.dart';
import 'package:crying_time/domain/usecase/usecase.dart';
import 'package:crying_time/feature/home/viewmodel/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetPickupInfo extends Mock implements GetPickupInfo {}

class _MockGetPushSchedule extends Mock implements GetPushSchedule {}

class _MockRecordHomeVisit extends Mock implements RecordHomeVisit {}

class _MockMarkInterstitialShown extends Mock
    implements MarkInterstitialShown {}

class _MockInterstitialAdService extends Mock
    implements InterstitialAdService {}

/// 전면광고는 "실제로 떴을 때만" 횟수를 되돌린다.
///
/// 못 띄웠는데 되돌리면 사용자는 광고를 안 봤는데도 다음 5번을 다시 채워야
/// 하고, 안 떴는데 안 되돌리는 건 맞지만 뜬 뒤에도 안 되돌리면 매번 뜬다.
void main() {
  late _MockGetPickupInfo getPickupInfo;
  late _MockGetPushSchedule getPushSchedule;
  late _MockRecordHomeVisit recordHomeVisit;
  late _MockMarkInterstitialShown markInterstitialShown;
  late _MockInterstitialAdService interstitialAd;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    getPickupInfo = _MockGetPickupInfo();
    getPushSchedule = _MockGetPushSchedule();
    recordHomeVisit = _MockRecordHomeVisit();
    markInterstitialShown = _MockMarkInterstitialShown();
    interstitialAd = _MockInterstitialAdService();

    when(() => getPickupInfo(any())).thenAnswer(
      (_) async => Ok<PickupInfo?>(
        PickupInfo(pickupDate: DateTime(2026, 7, 20), boxes: 5),
      ),
    );
    when(() => getPushSchedule(any()))
        .thenAnswer((_) async => const Ok(PushSchedule.initial));
    when(() => markInterstitialShown(any()))
        .thenAnswer((_) async => const Ok(null));

    getIt
      ..registerSingleton<GetPickupInfo>(getPickupInfo)
      ..registerSingleton<GetPushSchedule>(getPushSchedule)
      ..registerSingleton<RecordHomeVisit>(recordHomeVisit)
      ..registerSingleton<MarkInterstitialShown>(markInterstitialShown)
      ..registerSingleton<InterstitialAdService>(interstitialAd);
  });

  tearDown(() async {
    await getIt.reset();
  });

  HomeViewModel viewModel() {
    final container = ProviderContainer.test();
    return container.read(homeViewModelProvider.notifier);
  }

  test('광고 차례가 아니면 광고를 건드리지 않는다', () async {
    when(() => recordHomeVisit(any())).thenAnswer((_) async => const Ok(false));

    await viewModel().showInterstitialIfDue();

    verify(() => recordHomeVisit(any())).called(1);
    verifyNever(() => interstitialAd.show());
    verifyNever(() => markInterstitialShown(any()));
  });

  test('광고 차례에 실제로 떴으면 횟수를 되돌린다', () async {
    when(() => recordHomeVisit(any())).thenAnswer((_) async => const Ok(true));
    when(() => interstitialAd.show()).thenAnswer((_) async => true);

    await viewModel().showInterstitialIfDue();

    verify(() => markInterstitialShown(any())).called(1);
  });

  test('광고 차례인데 못 띄웠으면 횟수를 그대로 둬서 다음 방문에 다시 시도한다', () async {
    when(() => recordHomeVisit(any())).thenAnswer((_) async => const Ok(true));
    when(() => interstitialAd.show()).thenAnswer((_) async => false);

    await viewModel().showInterstitialIfDue();

    verifyNever(() => markInterstitialShown(any()));
  });

  test('방문 기록 저장이 실패해도 광고를 띄우지 않고 조용히 넘어간다', () async {
    when(() => recordHomeVisit(any()))
        .thenAnswer((_) async => const Err(UnknownFailure()));

    await viewModel().showInterstitialIfDue();

    verifyNever(() => interstitialAd.show());
  });
}
