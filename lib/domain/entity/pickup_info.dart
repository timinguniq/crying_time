import 'package:freezed_annotation/freezed_annotation.dart';

part 'pickup_info.freezed.dart';

/// 마지막 인공눈물 수령 기록.
///
/// 재처방 주기는 저장하지 않고 수령량에서 유도한다. 건강보험 급여 기준이
/// "1일 6개"이므로 5박스(300개)면 50일이 되고, 이 값이 디자인의 기준값과 같다.
@freezed
abstract class PickupInfo with _$PickupInfo {
  const PickupInfo._();

  const factory PickupInfo({
    required DateTime pickupDate,
    required int boxes,
  }) = _PickupInfo;

  /// 한 박스에 든 개수.
  static const int dosesPerBox = 60;

  /// 보험 급여가 인정하는 1일 사용량.
  static const int coveredDosesPerDay = 6;

  static const int minBoxes = 1;
  static const int maxBoxes = 10;
  static const int defaultBoxes = 5;

  int get totalDoses => boxes * dosesPerBox;

  /// 다음 수령까지 필요한 일수. 5박스 → 50일.
  int get cycleDays => totalDoses ~/ coveredDosesPerDay;

  DateTime get nextPickupDate =>
      DateTime(pickupDate.year, pickupDate.month, pickupDate.day + cycleDays);

  /// 수령일로부터 지난 일수. 화면에는 주기를 넘지 않는 값으로 보여준다.
  int elapsedDaysOn(DateTime today) =>
      _daysBetween(pickupDate, today).clamp(0, cycleDays);

  /// 다음 수령까지 남은 일수. 0 이면 오늘이 수령 가능일이다.
  int daysLeftOn(DateTime today) =>
      (cycleDays - _daysBetween(pickupDate, today)).clamp(0, cycleDays);

  bool canRefillOn(DateTime today) => _daysBetween(pickupDate, today) >= cycleDays;

  /// 링 프로그레스가 쓰는 0.0 ~ 1.0 진행률.
  double progressOn(DateTime today) =>
      cycleDays == 0 ? 1 : elapsedDaysOn(today) / cycleDays;

  /// 서머타임이 있는 지역에서도 날짜 차이가 어긋나지 않도록 UTC 로 맞춰 뺀다.
  static int _daysBetween(DateTime from, DateTime to) => DateTime.utc(
    to.year,
    to.month,
    to.day,
  ).difference(DateTime.utc(from.year, from.month, from.day)).inDays;
}
