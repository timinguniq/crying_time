// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_registration_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceRegistrationRequestDto _$DeviceRegistrationRequestDtoFromJson(
  Map<String, dynamic> json,
) => _DeviceRegistrationRequestDto(
  deviceId: json['deviceId'] as String,
  fcmToken: json['fcmToken'] as String,
  platform: json['platform'] as String,
  utcOffsetMinutes: (json['utcOffsetMinutes'] as num).toInt(),
);

Map<String, dynamic> _$DeviceRegistrationRequestDtoToJson(
  _DeviceRegistrationRequestDto instance,
) => <String, dynamic>{
  'deviceId': instance.deviceId,
  'fcmToken': instance.fcmToken,
  'platform': instance.platform,
  'utcOffsetMinutes': instance.utcOffsetMinutes,
};
