import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_schedule_request_dto.freezed.dart';
part 'push_schedule_request_dto.g.dart';

/// `PUT /v1/devices/{deviceId}/push-schedule` 요청 본문.
///
/// 서버는 `nextPickupDate - offsetDays[i]` 날짜에 푸시를 발송한다.
@freezed
abstract class PushScheduleRequestDto with _$PushScheduleRequestDto {
  const factory PushScheduleRequestDto({
    required bool enabled,

    /// 수령 가능일 며칠 전에 보낼지. 당일은 0. 먼 시점부터 정렬돼 있다.
    required List<int> offsetDays,

    /// 'yyyy-MM-dd'.
    required String nextPickupDate,
    required int utcOffsetMinutes,
  }) = _PushScheduleRequestDto;

  factory PushScheduleRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PushScheduleRequestDtoFromJson(json);

  static PushScheduleRequestDto fromEntity({
    required PushSchedule schedule,
    required DateTime nextPickupDate,
    required int utcOffsetMinutes,
  }) => PushScheduleRequestDto(
    enabled: schedule.enabled,
    offsetDays: schedule.offsetDays,
    nextPickupDate: _toIsoDate(nextPickupDate),
    utcOffsetMinutes: utcOffsetMinutes,
  );

  static String _toIsoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
