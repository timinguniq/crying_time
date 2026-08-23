/// 날짜를 화면에 그대로 쓸 수 있는 한국어 문자열로 바꾼다.
///
/// intl 의 DateFormat 은 로케일 초기화가 필요하고 요일 표기가 디자인과 달라
/// 형식이 두 개뿐인 지금은 직접 조립하는 편이 단순하다.
extension KoreanDate on DateTime {
  /// '8월 23일 (일)' — 월/일에 0 을 채우지 않는다.
  String get monthDayWeekday => '$month월 $day일 (${_weekdayLabels[weekday % 7]})';

  /// '2026. 07. 20.' — 월/일을 두 자리로 채운다.
  String get dotted => '$year. ${_pad(month)}. ${_pad(day)}.';
}

/// DateTime.weekday 는 월=1..일=7 이라 `weekday % 7` 이 일요일을 0 으로 보낸다.
const List<String> _weekdayLabels = <String>['일', '월', '화', '수', '목', '금', '토'];

String _pad(int value) => value.toString().padLeft(2, '0');
