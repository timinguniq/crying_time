import 'package:crying_time/domain/entity/device_registration.dart';
import 'package:crying_time/domain/result/result.dart';

/// 기기 자체의 등록을 책임진다. 알림 시점은 [PushScheduleRepository] 가 다룬다.
abstract interface class DeviceRepository {
  /// 기기 식별자와 FCM 토큰을 확보해 서버에 등록(upsert)한다.
  Future<Result<DeviceRegistration>> registerDevice();
}
