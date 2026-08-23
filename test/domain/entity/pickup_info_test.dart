import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:flutter_test/flutter_test.dart';

/// 재처방 주기 계산은 이 앱이 존재하는 이유다.
///
/// 여기가 어긋나면 사용자는 급여가 안 되는 날에 병원에 가거나, 받을 수 있는
/// 날을 그냥 넘긴다. 화면 문구·링·푸시 예약이 전부 이 값에서 나온다.
void main() {
  final pickupDate = DateTime(2026, 7, 20);

  PickupInfo infoOf(int boxes) =>
      PickupInfo(pickupDate: pickupDate, boxes: boxes);

  /// 수령일로부터 [days] 일 뒤. 달을 넘겨도 DateTime 이 알아서 넘긴다.
  DateTime dayOffset(int days) => DateTime(2026, 7, 20 + days);

  group('cycleDays', () {
    test('5박스(300개)는 1일 6개 기준으로 50일 주기다', () {
      final info = infoOf(5);

      expect(info.totalDoses, 300);
      expect(info.cycleDays, 50);
    });

    test('3박스(180개)는 30일 주기다', () {
      final info = infoOf(3);

      expect(info.totalDoses, 180);
      expect(info.cycleDays, 30);
    });
  });

  group('nextPickupDate', () {
    test('수령일에 주기를 더한 날이다', () {
      expect(infoOf(5).nextPickupDate, DateTime(2026, 9, 8));
      expect(infoOf(3).nextPickupDate, DateTime(2026, 8, 19));
    });

    test('수령일에 시각이 붙어 있어도 날짜 경계로 떨어진다', () {
      final info = PickupInfo(
        pickupDate: DateTime(2026, 7, 20, 23, 59, 59),
        boxes: 5,
      );

      // 서버 푸시 예약이 이 값을 'yyyy-MM-dd' 로 받으므로 시각이 남으면 안 된다.
      expect(info.nextPickupDate, DateTime(2026, 9, 8));
    });
  });

  group('elapsedDaysOn / daysLeftOn', () {
    final info = infoOf(5);

    test('주기 안에서는 지난 일수와 남은 일수를 합치면 주기가 된다', () {
      final today = dayOffset(12);

      expect(info.elapsedDaysOn(today), 12);
      expect(info.daysLeftOn(today), 38);
    });

    test('주기를 한참 넘겨도 주기 밖으로 나가지 않는다', () {
      final today = dayOffset(70);

      expect(info.elapsedDaysOn(today), 50);
      expect(info.daysLeftOn(today), 0);
    });

    test('수령일보다 이른 날짜에도 음수가 되지 않는다', () {
      final today = dayOffset(-5);

      expect(info.elapsedDaysOn(today), 0);
      expect(info.daysLeftOn(today), 50);
    });
  });

  group('canRefillOn', () {
    final info = infoOf(5);

    test('주기 하루 전은 아직 아니다', () {
      expect(info.canRefillOn(dayOffset(49)), isFalse);
      expect(info.daysLeftOn(dayOffset(49)), 1);
    });

    test('주기 당일부터 가능하다', () {
      expect(dayOffset(50), info.nextPickupDate);
      expect(info.canRefillOn(dayOffset(50)), isTrue);
      expect(info.daysLeftOn(dayOffset(50)), 0);
    });

    test('주기를 넘긴 뒤에도 계속 가능하다', () {
      expect(info.canRefillOn(dayOffset(51)), isTrue);
    });

    test('같은 날 안에서 시각이 달라도 판정이 흔들리지 않는다', () {
      expect(info.canRefillOn(DateTime(2026, 9, 7, 23, 59)), isFalse);
      expect(info.canRefillOn(DateTime(2026, 9, 8, 0, 1)), isTrue);
      expect(info.canRefillOn(DateTime(2026, 9, 8, 23, 59)), isTrue);
    });
  });

  group('progressOn', () {
    final info = infoOf(5);

    test('수령 당일 0, 절반이면 0.5, 주기 당일 1', () {
      expect(info.progressOn(dayOffset(0)), 0);
      expect(info.progressOn(dayOffset(25)), 0.5);
      expect(info.progressOn(dayOffset(50)), 1);
    });

    test('주기 밖의 날짜에서도 0..1 을 벗어나지 않는다', () {
      // 링이 한 바퀴 넘게 돌거나 음수로 그려지면 화면이 깨진다.
      for (final offset in <int>[-400, -1, 0, 1, 49, 50, 51, 400]) {
        expect(
          info.progressOn(dayOffset(offset)),
          inInclusiveRange(0, 1),
          reason: 'offset=$offset',
        );
      }
    });
  });
}
