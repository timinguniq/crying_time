import 'package:crying_time/app/ads/ad_config.dart';
import 'package:crying_time/app/ads/interstitial_ad_service.dart';
import 'package:crying_time/app/di/service_locator.dart';
import 'package:crying_time/data/datasource/device_environment.dart';
import 'package:crying_time/data/datasource/device_id_source.dart';
import 'package:crying_time/data/datasource/device_remote_data_source.dart';
import 'package:crying_time/data/datasource/home_visit_local_data_source.dart';
import 'package:crying_time/data/datasource/messaging_source.dart';
import 'package:crying_time/data/datasource/pickup_local_data_source.dart';
import 'package:crying_time/data/datasource/push_schedule_local_data_source.dart';
import 'package:crying_time/data/network/dio_client.dart';
import 'package:crying_time/data/repository/device_repository_impl.dart';
import 'package:crying_time/data/repository/home_visit_repository_impl.dart';
import 'package:crying_time/data/repository/pickup_repository_impl.dart';
import 'package:crying_time/data/repository/push_schedule_repository_impl.dart';
import 'package:crying_time/domain/repository/device_repository.dart';
import 'package:crying_time/domain/repository/home_visit_repository.dart';
import 'package:crying_time/domain/repository/pickup_repository.dart';
import 'package:crying_time/domain/repository/push_schedule_repository.dart';
import 'package:crying_time/domain/usecase/get_pickup_info.dart';
import 'package:crying_time/domain/usecase/get_push_schedule.dart';
import 'package:crying_time/domain/usecase/mark_interstitial_shown.dart';
import 'package:crying_time/domain/usecase/record_home_visit.dart';
import 'package:crying_time/domain/usecase/register_device.dart';
import 'package:crying_time/domain/usecase/save_pickup_info.dart';
import 'package:crying_time/domain/usecase/set_push_enabled.dart';
import 'package:crying_time/domain/usecase/sync_push_schedule.dart';
import 'package:crying_time/domain/usecase/update_push_schedule.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// domain / data 계층의 객체 그래프를 조립한다. 앱 시작 시 `main` 에서 한 번 호출한다.
///
/// 여기서만 구현체(Impl)를 알고, 나머지 코드는 인터페이스만 본다.
void configureDependencies() {
  getIt
    // network
    ..registerLazySingleton<Dio>(createDio)
    ..registerLazySingleton<SharedPreferencesAsync>(SharedPreferencesAsync.new)
    ..registerLazySingleton<DeviceEnvironment>(DeviceEnvironmentImpl.new)
    // ads
    ..registerLazySingleton<InterstitialAdService>(
      () => AdMobInterstitialAdService(AdConfig.homeInterstitialAdUnitId),
    )
    // data source
    ..registerLazySingleton<DeviceIdSource>(
      () => DeviceIdSourceImpl(getIt<SharedPreferencesAsync>()),
    )
    ..registerLazySingleton<MessagingSource>(
      () => const FirebaseMessagingSource(),
    )
    ..registerLazySingleton<DeviceRemoteDataSource>(
      () => DeviceRemoteDataSourceImpl(getIt<Dio>()),
    )
    ..registerLazySingleton<PickupLocalDataSource>(
      () => PickupLocalDataSourceImpl(getIt<SharedPreferencesAsync>()),
    )
    ..registerLazySingleton<PushScheduleLocalDataSource>(
      () => PushScheduleLocalDataSourceImpl(getIt<SharedPreferencesAsync>()),
    )
    ..registerLazySingleton<HomeVisitLocalDataSource>(
      () => HomeVisitLocalDataSourceImpl(getIt<SharedPreferencesAsync>()),
    )
    // repository
    ..registerLazySingleton<DeviceRepository>(
      () => DeviceRepositoryImpl(
        deviceIdSource: getIt<DeviceIdSource>(),
        messagingSource: getIt<MessagingSource>(),
        remoteDataSource: getIt<DeviceRemoteDataSource>(),
        environment: getIt<DeviceEnvironment>(),
      ),
    )
    ..registerLazySingleton<PickupRepository>(
      () => PickupRepositoryImpl(getIt<PickupLocalDataSource>()),
    )
    ..registerLazySingleton<PushScheduleRepository>(
      () => PushScheduleRepositoryImpl(
        localDataSource: getIt<PushScheduleLocalDataSource>(),
        remoteDataSource: getIt<DeviceRemoteDataSource>(),
        deviceIdSource: getIt<DeviceIdSource>(),
        environment: getIt<DeviceEnvironment>(),
      ),
    )
    ..registerLazySingleton<HomeVisitRepository>(
      () => HomeVisitRepositoryImpl(getIt<HomeVisitLocalDataSource>()),
    )
    // use case
    ..registerLazySingleton<RegisterDevice>(
      () => RegisterDevice(getIt<DeviceRepository>()),
    )
    ..registerLazySingleton<GetPickupInfo>(
      () => GetPickupInfo(getIt<PickupRepository>()),
    )
    ..registerLazySingleton<SavePickupInfo>(
      () => SavePickupInfo(
        getIt<PickupRepository>(),
        getIt<PushScheduleRepository>(),
      ),
    )
    ..registerLazySingleton<GetPushSchedule>(
      () => GetPushSchedule(getIt<PushScheduleRepository>()),
    )
    ..registerLazySingleton<UpdatePushSchedule>(
      () => UpdatePushSchedule(getIt<PushScheduleRepository>()),
    )
    ..registerLazySingleton<SetPushEnabled>(
      () => SetPushEnabled(getIt<PushScheduleRepository>()),
    )
    ..registerLazySingleton<SyncPushSchedule>(
      () => SyncPushSchedule(
        getIt<PickupRepository>(),
        getIt<PushScheduleRepository>(),
      ),
    )
    ..registerLazySingleton<RecordHomeVisit>(
      () => RecordHomeVisit(getIt<HomeVisitRepository>()),
    )
    ..registerLazySingleton<MarkInterstitialShown>(
      () => MarkInterstitialShown(getIt<HomeVisitRepository>()),
    );
}
