import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_enabled_request_dto.freezed.dart';
part 'push_enabled_request_dto.g.dart';

/// `PUT /v1/devices/{deviceId}/push-enabled` 요청 본문.
///
/// 켜고 끄는 것만 다룬다. 알림 시점은 서버에 남아 있던 값을 그대로 두므로,
/// 다시 켰을 때 사용자가 시점을 새로 고를 필요가 없다.
@freezed
abstract class PushEnabledRequestDto with _$PushEnabledRequestDto {
  const factory PushEnabledRequestDto({required bool enabled}) =
      _PushEnabledRequestDto;

  factory PushEnabledRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PushEnabledRequestDtoFromJson(json);
}
