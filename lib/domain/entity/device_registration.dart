import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_registration.freezed.dart';

/// 서버가 이 기기로 푸시를 보내기 위해 필요한 최소 정보.
@freezed
abstract class DeviceRegistration with _$DeviceRegistration {
  const factory DeviceRegistration({
    /// 앱 최초 실행 때 만들어 기기에 영구 저장하는 식별자.
    required String deviceId,
    required String fcmToken,

    /// 'android' | 'ios'.
    required String platform,
  }) = _DeviceRegistration;
}
