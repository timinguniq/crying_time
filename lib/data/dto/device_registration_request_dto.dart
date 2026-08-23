import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_registration_request_dto.freezed.dart';
part 'device_registration_request_dto.g.dart';

/// `POST /v1/devices` 요청 본문.
@freezed
abstract class DeviceRegistrationRequestDto
    with _$DeviceRegistrationRequestDto {
  const factory DeviceRegistrationRequestDto({
    required String deviceId,
    required String fcmToken,

    /// 'android' | 'ios'.
    required String platform,

    /// UTC 기준 오프셋(분). 서버가 발송 시각을 기기 지역시간으로 맞출 때 쓴다.
    required int utcOffsetMinutes,
  }) = _DeviceRegistrationRequestDto;

  factory DeviceRegistrationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceRegistrationRequestDtoFromJson(json);
}
