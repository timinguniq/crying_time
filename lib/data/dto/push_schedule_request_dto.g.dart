// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_schedule_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushScheduleRequestDto _$PushScheduleRequestDtoFromJson(
  Map<String, dynamic> json,
) => _PushScheduleRequestDto(
  enabled: json['enabled'] as bool,
  offsetDays: (json['offsetDays'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  nextPickupDate: json['nextPickupDate'] as String,
  utcOffsetMinutes: (json['utcOffsetMinutes'] as num).toInt(),
);

Map<String, dynamic> _$PushScheduleRequestDtoToJson(
  _PushScheduleRequestDto instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'offsetDays': instance.offsetDays,
  'nextPickupDate': instance.nextPickupDate,
  'utcOffsetMinutes': instance.utcOffsetMinutes,
};
