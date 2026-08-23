import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

/// offsetDays 는 서버가 실제 발송 시각으로 바꾸는 유일한 입력이다.
///
/// 중복이 섞이면 같은 날 알림이 두 번 가고, 순서가 뒤집히면 안내 문구의
/// 날짜 나열도 뒤집힌다.
void main() {
  group('offsetDays', () {
    test('기본값은 D-7 · D-3 · 당일을 먼 시점부터 준다', () {
      expect(PushSchedule.initial.offsetDays, <int>[7, 3, 0]);
    });

    test('직접 지정을 켜면 값 크기에 맞는 자리에 끼어든다', () {
      expect(
        PushSchedule.initial.copyWith(customEnabled: true).offsetDays,
        <int>[14, 7, 3, 0],
      );
      expect(
        PushSchedule.initial
            .copyWith(customEnabled: true, customDays: 5)
            .offsetDays,
        <int>[7, 5, 3, 0],
      );
    });

    test('직접 지정이 7이면 D-7 과 중복되지 않는다', () {
      final schedule = PushSchedule.initial.copyWith(
        customEnabled: true,
        customDays: 7,
      );

      expect(schedule.offsetDays, <int>[7, 3, 0]);
    });

    test('어떤 직접 지정 값에서도 중복 없이 내림차순이다', () {
      for (final customDays in <int>[
        PushSchedule.minCustomDays,
        3,
        7,
        20,
        PushSchedule.maxCustomDays,
      ]) {
        final offsets = PushSchedule.initial
            .copyWith(customEnabled: true, customDays: customDays)
            .offsetDays;

        expect(
          offsets.toSet().length,
          offsets.length,
          reason: 'customDays=$customDays 에서 중복이 생겼다',
        );
        expect(
          offsets,
          orderedEquals(offsets.toList()..sort((a, b) => b.compareTo(a))),
          reason: 'customDays=$customDays 에서 순서가 깨졌다',
        );
      }
    });

    test('직접 지정을 꺼두면 customDays 는 목록에 들어가지 않는다', () {
      final schedule = PushSchedule.initial.copyWith(customDays: 20);

      expect(schedule.offsetDays, <int>[7, 3, 0]);
    });
  });

  group('hasNoOffset', () {
    test('시점을 하나도 고르지 않으면 true', () {
      final schedule = PushSchedule.initial.copyWith(
        notifyD7: false,
        notifyD3: false,
        notifyDDay: false,
      );

      expect(schedule.offsetDays, isEmpty);
      expect(schedule.hasNoOffset, isTrue);
    });

    test('당일만 골라도 false — 오프셋 0 은 "고르지 않음"이 아니다', () {
      final schedule = PushSchedule.initial.copyWith(
        notifyD7: false,
        notifyD3: false,
      );

      expect(schedule.offsetDays, <int>[0]);
      expect(schedule.hasNoOffset, isFalse);
    });

    test('직접 지정만 켜도 false', () {
      final schedule = PushSchedule.initial.copyWith(
        notifyD7: false,
        notifyD3: false,
        notifyDDay: false,
        customEnabled: true,
      );

      expect(schedule.hasNoOffset, isFalse);
    });
  });

  /// 오프셋이 주기 이상이면 발송일이 지난 수령일보다 앞서 버려, 이미 지난 날짜에
  /// 예약이 걸린다 — 알림이 아예 오지 않는다.
  group('maxCustomDaysFor', () {
    test('5박스(50일)에서는 하루 전인 49까지', () {
      expect(PushSchedule.maxCustomDaysFor(50), 49);
      expect(PushSchedule.maxCustomDaysFor(50), PushSchedule.maxCustomDays);
    });

    test('1박스(10일)로 줄면 상한도 9로 함께 내려간다', () {
      expect(PushSchedule.maxCustomDaysFor(10), 9);
    });

    test('주기가 1일이어도 1 밑으로는 내려가지 않는다', () {
      expect(PushSchedule.maxCustomDaysFor(1), PushSchedule.minCustomDays);
      expect(PushSchedule.maxCustomDaysFor(1), 1);
    });

    test('주기가 아무리 길어도 49를 넘지 않는다', () {
      expect(PushSchedule.maxCustomDaysFor(365), PushSchedule.maxCustomDays);
    });
  });

  group('clampedTo', () {
    test('주기가 줄면 상한을 넘긴 직접 지정 값이 주기 안으로 당겨진다', () {
      final schedule = PushSchedule.initial.copyWith(
        customEnabled: true,
        customDays: PushSchedule.maxCustomDays,
      );

      // 5박스(50일) → 1박스(10일).
      expect(schedule.clampedTo(10).customDays, 9);
      // 당기기만 하고 다른 설정은 건드리지 않는다.
      expect(schedule.clampedTo(10).customEnabled, isTrue);
      expect(schedule.clampedTo(10).notifyD7, schedule.notifyD7);
    });

    test('상한을 넘지 않으면 값도 객체도 그대로다', () {
      final schedule = PushSchedule.initial.copyWith(
        customEnabled: true,
        customDays: 7,
      );

      expect(schedule.clampedTo(50), schedule);
      expect(schedule.clampedTo(10), schedule);
      // 정확히 상한인 값은 아직 유효하다.
      expect(schedule.clampedTo(8).customDays, 7);
    });

    test('직접 지정을 꺼둔 상태여도 값 자체는 주기 안으로 당겨 둔다', () {
      // 나중에 체크를 켜는 순간 주기를 넘긴 값이 그대로 올라가면 안 된다.
      final schedule = PushSchedule.initial.copyWith(customDays: 30);

      expect(schedule.clampedTo(10).customDays, 9);
    });
  });

  /// 발송일 규칙(`수령 가능일 - 오프셋`)의 유일한 정의. 화면 안내 문구와 서버
  /// 예약이 같은 날짜를 가리키는지가 여기 달려 있다.
  group('notificationDatesFor', () {
    test('오프셋만큼 앞선 날짜를 오프셋 순서대로 준다', () {
      expect(
        PushSchedule.initial.notificationDatesFor(DateTime(2026, 8, 19)),
        <DateTime>[
          DateTime(2026, 8, 12),
          DateTime(2026, 8, 16),
          DateTime(2026, 8, 19),
        ],
      );
    });

    test('월 경계를 넘으면 앞 달로 넘어간다', () {
      // 2026-03-05 기준. 2026년 2월은 28일까지다.
      expect(
        PushSchedule.initial.notificationDatesFor(DateTime(2026, 3, 5)),
        <DateTime>[
          DateTime(2026, 2, 26),
          DateTime(2026, 3, 2),
          DateTime(2026, 3, 5),
        ],
      );
    });

    test('연 경계를 넘으면 앞 해로 넘어간다', () {
      expect(
        PushSchedule.initial.notificationDatesFor(DateTime(2026, 1, 3)),
        <DateTime>[
          DateTime(2025, 12, 27),
          DateTime(2025, 12, 31),
          DateTime(2026, 1, 3),
        ],
      );
    });

    test('직접 지정 오프셋도 같은 규칙으로 자리를 잡는다', () {
      final schedule = PushSchedule.initial.copyWith(
        customEnabled: true,
        customDays: 14,
      );

      expect(schedule.notificationDatesFor(DateTime(2026, 3, 5)), <DateTime>[
        DateTime(2026, 2, 19),
        DateTime(2026, 2, 26),
        DateTime(2026, 3, 2),
        DateTime(2026, 3, 5),
      ]);
    });

    test('시점을 하나도 고르지 않으면 발송할 날짜도 없다', () {
      final schedule = PushSchedule.initial.copyWith(
        notifyD7: false,
        notifyD3: false,
        notifyDDay: false,
      );

      expect(schedule.notificationDatesFor(DateTime(2026, 8, 19)), isEmpty);
    });

    test('기준일에 시각이 묻어 있어도 자정으로 떨어진 날짜만 준다', () {
      final dates = PushSchedule.initial.notificationDatesFor(
        DateTime(2026, 8, 19, 13, 45),
      );

      expect(dates.last, DateTime(2026, 8, 19));
    });
  });
}
