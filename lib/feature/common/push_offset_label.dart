import 'package:crying_time/domain/entity/push_schedule.dart';

/// 알림 오프셋 → 화면 라벨. `PushSchedule.offsetDays` 하나만 보고 만들기 때문에,
/// 알림 시점을 추가해도 라벨을 손볼 곳이 여기 한 군데다.
String pushOffsetLabel(int offset) => offset == 0 ? '당일' : 'D-$offset';

/// 홈 카드에 쓰는 한 줄 요약. 예: 'D-7 · D-3 · 당일'.
String pushScheduleSummary(PushSchedule schedule) {
  if (!schedule.enabled) {
    return '꺼짐';
  }
  if (schedule.hasNoOffset) {
    return '시점 미설정';
  }
  return schedule.offsetDays.map(pushOffsetLabel).join(' · ');
}
