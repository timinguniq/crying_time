import 'dart:async';

import 'package:crying_time/app/di/service_locator.dart';
import 'package:crying_time/app/theme/app_theme.dart';
import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/get_pickup_info.dart';
import 'package:crying_time/domain/usecase/get_push_schedule.dart';
import 'package:crying_time/domain/usecase/save_pickup_info.dart';
import 'package:crying_time/domain/usecase/set_push_enabled.dart';
import 'package:crying_time/domain/usecase/update_push_schedule.dart';
import 'package:crying_time/domain/usecase/usecase.dart';
import 'package:crying_time/feature/common/widget/app_stepper_button.dart';
import 'package:crying_time/feature/common/widget/app_toggle.dart';
import 'package:crying_time/feature/settings/ui/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetPickupInfo extends Mock implements GetPickupInfo {}

class _MockGetPushSchedule extends Mock implements GetPushSchedule {}

class _MockUpdatePushSchedule extends Mock implements UpdatePushSchedule {}

class _MockSavePickupInfo extends Mock implements SavePickupInfo {}

class _MockSetPushEnabled extends Mock implements SetPushEnabled {}

/// "푸시 타임을 바꿀 때마다 서버와 통신한다"는 요구사항의 회귀 방어.
///
/// 화면만 바뀌고 요청이 안 나가면 사용자는 설정이 반영된 줄 알고 알림을 놓친다.
void main() {
  late _MockGetPickupInfo getPickupInfo;
  late _MockGetPushSchedule getPushSchedule;
  late _MockUpdatePushSchedule updatePushSchedule;
  late _MockSavePickupInfo savePickupInfo;
  late _MockSetPushEnabled setPushEnabled;

  final pickupInfo = PickupInfo(pickupDate: DateTime(2026, 7, 20), boxes: 5);

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      UpdatePushScheduleParams(
        schedule: PushSchedule.initial,
        nextPickupDate: DateTime(2026, 1, 1),
      ),
    );
    registerFallbackValue(
      SavePickupInfoParams(pickupDate: DateTime(2026, 1, 1), boxes: 1),
    );
    registerFallbackValue(
      const SetPushEnabledParams(schedule: PushSchedule.initial),
    );
  });

  setUp(() {
    getPickupInfo = _MockGetPickupInfo();
    getPushSchedule = _MockGetPushSchedule();
    updatePushSchedule = _MockUpdatePushSchedule();
    savePickupInfo = _MockSavePickupInfo();
    setPushEnabled = _MockSetPushEnabled();

    when(() => setPushEnabled(any())).thenAnswer((invocation) async {
      final params =
          invocation.positionalArguments.first as SetPushEnabledParams;
      return Ok(params.schedule);
    });
    when(() => getPickupInfo(any()))
        .thenAnswer((_) async => Ok<PickupInfo?>(pickupInfo));
    when(() => getPushSchedule(any()))
        .thenAnswer((_) async => const Ok(PushSchedule.initial));
    when(() => updatePushSchedule(any()))
        .thenAnswer((_) async => const Ok(PushSchedule.initial));
    when(() => savePickupInfo(any())).thenAnswer((invocation) async {
      final params =
          invocation.positionalArguments.first as SavePickupInfoParams;
      return Ok(
        PickupInfo(pickupDate: params.pickupDate, boxes: params.boxes),
      );
    });

    getIt
      ..registerSingleton<GetPickupInfo>(getPickupInfo)
      ..registerSingleton<GetPushSchedule>(getPushSchedule)
      ..registerSingleton<UpdatePushSchedule>(updatePushSchedule)
      ..registerSingleton<SavePickupInfo>(savePickupInfo)
      ..registerSingleton<SetPushEnabled>(setPushEnabled);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Future<void> pumpSettings(WidgetTester tester) async {
    // 세로가 짧으면 칩이 화면 밖으로 밀려 탭이 안 된다.
    await tester.binding.setSurfaceSize(const Size(400, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: AppTheme.light, home: const SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('푸시 스위치를 끄면 on/off 전용 요청만 나가고 스케줄은 건드리지 않는다', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.byType(AppToggle));
    await tester.pumpAndSettle();

    final captured = verify(() => setPushEnabled(captureAny())).captured;
    expect(captured, hasLength(1));
    expect((captured.single as SetPushEnabledParams).schedule.enabled, isFalse);

    // 시점은 서버에 그대로 남아 있어야 다시 켰을 때 새로 고르지 않아도 된다.
    verifyNever(() => updatePushSchedule(any()));
  });

  testWidgets('푸시 스위치를 다시 켜면 시점 선택이 그대로 살아난다', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.byType(AppToggle));
    await tester.pumpAndSettle();
    expect(find.text('D-7'), findsNothing);

    await tester.tap(find.byType(AppToggle));
    await tester.pumpAndSettle();

    final captured = verify(() => setPushEnabled(captureAny())).captured;
    expect(captured, hasLength(2));

    final schedule = (captured.last as SetPushEnabledParams).schedule;
    expect(schedule.enabled, isTrue);
    expect(schedule.notifyD7, isTrue);
    expect(schedule.notifyD3, isTrue);
    expect(schedule.notifyDDay, isTrue);
    expect(find.text('D-7'), findsOneWidget);
  });

  testWidgets('D-7 칩을 끄면 새 스케줄로 서버 동기화를 정확히 한 번 요청한다', (tester) async {
    await pumpSettings(tester);
    expect(find.text('D-7'), findsOneWidget);

    await tester.tap(find.text('D-7'));
    await tester.pumpAndSettle();

    final captured = verify(() => updatePushSchedule(captureAny())).captured;
    expect(captured, hasLength(1));

    final params = captured.single as UpdatePushScheduleParams;
    expect(params.schedule.notifyD7, isFalse);
    expect(params.schedule.notifyD3, isTrue);
    expect(params.schedule.notifyDDay, isTrue);
    // 부분 변경분이 아니라 그 시점의 스케줄 전체가 올라간다.
    expect(params.schedule.offsetDays, <int>[3, 0]);
    expect(params.nextPickupDate, pickupInfo.nextPickupDate);
  });

  testWidgets('칩을 빠르게 두 번 탭해도 요청이 겹치지 않고 누른 순서대로 나간다', (tester) async {
    // HTTP 는 도착 순서를 보장하지 않는다. 두 요청이 동시에 날면 먼저 보낸
    // 옛 값이 나중에 닿아 최신 설정을 덮어쓸 수 있고, 사용자는 화면과 다른
    // 시점에 알림을 받는다.
    final pending = <Completer<Result<PushSchedule>>>[];
    final sentOffsets = <List<int>>[];

    when(() => updatePushSchedule(any())).thenAnswer((invocation) {
      final params =
          invocation.positionalArguments.first as UpdatePushScheduleParams;
      sentOffsets.add(params.schedule.offsetDays);

      final completer = Completer<Result<PushSchedule>>();
      pending.add(completer);
      return completer.future;
    });

    await pumpSettings(tester);

    // 앞 요청의 응답을 기다리지 않고 곧바로 두 번째 칩을 누른다.
    await tester.tap(find.text('D-7'));
    await tester.pump();
    await tester.tap(find.text('D-3'));
    await tester.pump();

    // 두 번째 요청은 첫 요청이 끝날 때까지 나가면 안 된다.
    expect(pending, hasLength(1), reason: '앞 요청이 끝나기 전에 다음 요청이 나갔다');
    expect(sentOffsets.single, <int>[3, 0]);

    pending.first.complete(const Ok(PushSchedule.initial));
    await tester.pump();

    expect(pending, hasLength(2), reason: '앞 요청이 끝났는데 다음 요청이 나가지 않았다');
    // 두 번째 요청은 첫 번째 변경까지 반영된 그 시점의 스케줄 전체를 담는다.
    expect(sentOffsets, <List<int>>[
      <int>[3, 0],
      <int>[0],
    ]);

    pending.last.complete(const Ok(PushSchedule.initial));
    await tester.pumpAndSettle();

    verify(() => updatePushSchedule(any())).called(2);
  });

  testWidgets('수령량을 줄여 주기가 짧아지면 화면의 직접 지정 값도 새 상한으로 함께 당겨진다', (tester) async {
    // 저장 유즈케이스는 서버·기기에 당겨진 값(9)을 남긴다. 화면만 옛 값(19)을
    // 붙들고 있으면 안내 문구가 지난 수령일보다 앞선 날짜를 알림일로 보여준다.
    when(() => getPickupInfo(any())).thenAnswer(
      (_) async =>
          Ok<PickupInfo?>(PickupInfo(pickupDate: DateTime(2026, 7, 20), boxes: 2)),
    );
    when(() => getPushSchedule(any())).thenAnswer(
      (_) async => Ok(
        PushSchedule.initial.copyWith(customEnabled: true, customDays: 19),
      ),
    );

    await pumpSettings(tester);

    // 2박스 = 20일 주기. 그 주기의 상한인 D-19 를 쓰고 있다.
    expect(find.text('20일'), findsOneWidget);
    expect(find.text('D-19'), findsOneWidget);

    // 수령량 − 버튼. 알림 카드의 − 다음에 오는 두 번째다.
    final decrements = find.byWidgetPredicate(
      (widget) => widget is AppStepperButton && !widget.isIncrement,
    );
    expect(decrements, findsNWidgets(2));
    await tester.tap(decrements.at(1));
    await tester.pumpAndSettle();

    // 1박스 = 10일 주기. 상한이 9 로 내려갔으므로 19 는 더 이상 유효하지 않다.
    expect(find.text('10일'), findsOneWidget);
    expect(find.text('D-19'), findsNothing);
    expect(find.text('D-9'), findsOneWidget);
  });

  testWidgets('동기화가 실패하면 실패 문구를 스낵바로 알린다', (tester) async {
    when(() => updatePushSchedule(any()))
        .thenAnswer((_) async => const Err<PushSchedule>(NetworkFailure()));

    await pumpSettings(tester);

    await tester.tap(find.text('D-7'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('네트워크 연결을 확인해주세요.'), findsOneWidget);

    // 스낵바가 스스로 닫히며 남기는 타이머를 소진한다.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
