import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_schedule.freezed.dart';

/// 재처방 알림을 언제 받을지에 대한 설정 = 서버로 보내는 "푸시 타임".
///
/// 값은 다음 수령 가능일 기준 며칠 전인지(offset)로 표현한다. 당일은 0.
@freezed
abstract class PushSchedule with _$PushSchedule {
  const PushSchedule._();

  const factory PushSchedule({
    required bool enabled,
    required bool notifyD7,
    required bool notifyD3,
    required bool notifyDDay,
    required bool customEnabled,
    required int customDays,
  }) = _PushSchedule;

  /// 첫 실행 기본값. 디자인 프로토타입의 초기 상태와 같다.
  static const PushSchedule initial = PushSchedule(
    enabled: true,
    notifyD7: true,
    notifyD3: true,
    notifyDDay: true,
    customEnabled: false,
    customDays: 14,
  );

  static const int minCustomDays = 1;
  static const int maxCustomDays = 49;

  /// 주기가 짧으면 직접 지정 상한도 같이 내려간다.
  ///
  /// 오프셋이 주기 이상이면 발송일이 마지막 수령일보다 앞서 버린다. 5박스(50일)
  /// 기준으로 굳어 있는 49 를 그대로 두면 1박스(10일)에서 그 상태가 된다.
  static int maxCustomDaysFor(int cycleDays) =>
      (cycleDays - 1).clamp(minCustomDays, maxCustomDays);

  /// 주기가 줄어 상한을 넘긴 직접 지정 값을 주기 안으로 당긴다.
  PushSchedule clampedTo(int cycleDays) {
    final limit = maxCustomDaysFor(cycleDays);
    return customDays > limit ? copyWith(customDays: limit) : this;
  }

  /// 서버에 보낼 오프셋 목록. 먼 시점부터 정렬하고 중복은 제거한다.
  List<int> get offsetDays {
    final offsets = <int>{
      if (notifyD7) 7,
      if (notifyD3) 3,
      if (notifyDDay) 0,
      if (customEnabled) customDays,
    }.toList()..sort((a, b) => b.compareTo(a));
    return offsets;
  }

  /// 푸시는 켰는데 시점을 하나도 고르지 않은 상태.
  bool get hasNoOffset => offsetDays.isEmpty;

  /// 서버가 실제로 푸시를 보낼 날짜들. 발송일 규칙(`수령 가능일 - 오프셋`)의
  /// 유일한 정의라서, 화면은 이 값을 받아 그리기만 한다.
  List<DateTime> notificationDatesFor(DateTime nextPickupDate) => [
    for (final offset in offsetDays)
      DateTime(
        nextPickupDate.year,
        nextPickupDate.month,
        nextPickupDate.day - offset,
      ),
  ];
}
