import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/repository/pickup_repository.dart';
import 'package:crying_time/domain/repository/push_schedule_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/save_pickup_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPickupRepository extends Mock implements PickupRepository {}

class _MockPushScheduleRepository extends Mock
    implements PushScheduleRepository {}

/// 수령 기록이 바뀌면 다음 수령 가능일도 바뀐다.
///
/// 서버 예약을 새 기준일로 다시 밀어 넣지 않으면 사용자는 옛 날짜에 알림을
/// 받는다 — 알림이 오긴 오는데 틀린 날 오는, 가장 알아채기 어려운 고장이다.
void main() {
  late _MockPickupRepository pickupRepository;
  late _MockPushScheduleRepository pushScheduleRepository;
  late SavePickupInfo useCase;

  // 5박스(50일)가 아니라 3박스(30일)로 잡아, 주기를 새로 계산하지 않고
  // 굳어 있는 구현이면 날짜가 어긋나도록 만든다.
  final params = SavePickupInfoParams(
    pickupDate: DateTime(2026, 7, 20),
    boxes: 3,
  );
  final savedInfo = PickupInfo(pickupDate: DateTime(2026, 7, 20), boxes: 3);
  final storedSchedule = PushSchedule.initial.copyWith(
    notifyD3: false,
    customEnabled: true,
    customDays: 21,
  );

  setUpAll(() {
    registerFallbackValue(
      PickupInfo(pickupDate: DateTime(2026, 1, 1), boxes: 1),
    );
    registerFallbackValue(PushSchedule.initial);
    registerFallbackValue(DateTime(2026, 1, 1));
  });

  setUp(() {
    pickupRepository = _MockPickupRepository();
    pushScheduleRepository = _MockPushScheduleRepository();
    useCase = SavePickupInfo(pickupRepository, pushScheduleRepository);

    when(() => pushScheduleRepository.load())
        .thenAnswer((_) async => Ok(storedSchedule));
    when(
      () => pushScheduleRepository.save(
        schedule: any(named: 'schedule'),
        nextPickupDate: any(named: 'nextPickupDate'),
      ),
    ).thenAnswer((_) async => Ok(storedSchedule));
  });

  test('저장에 성공하면 새 수령 가능일로 서버 예약을 다시 맞춘다', () async {
    when(() => pickupRepository.save(any()))
        .thenAnswer((_) async => Ok(savedInfo));

    final result = await useCase(params);

    expect(result, Ok<PickupInfo>(savedInfo));

    final captured = verify(
      () => pushScheduleRepository.save(
        schedule: captureAny(named: 'schedule'),
        nextPickupDate: captureAny(named: 'nextPickupDate'),
      ),
    ).captured;

    // 저장돼 있던 알림 설정을 그대로, 새로 계산한 기준일과 함께 올린다.
    expect(captured[0], storedSchedule);
    expect(captured[1], DateTime(2026, 8, 19));
  });

  test('수령 기록 저장이 실패하면 서버 예약은 건드리지 않고 실패를 그대로 돌려준다', () async {
    when(() => pickupRepository.save(any()))
        .thenAnswer((_) async => const Err<PickupInfo>(NetworkFailure()));

    final result = await useCase(params);

    expect(result, const Err<PickupInfo>(NetworkFailure()));
    verifyNever(() => pushScheduleRepository.load());
    verifyNever(
      () => pushScheduleRepository.save(
        schedule: any(named: 'schedule'),
        nextPickupDate: any(named: 'nextPickupDate'),
      ),
    );
  });

  test('서버 예약 갱신이 실패하면 실패를 올린다 — 로컬 저장은 이미 반영된 채로', () async {
    when(() => pickupRepository.save(any()))
        .thenAnswer((_) async => Ok(savedInfo));
    when(
      () => pushScheduleRepository.save(
        schedule: any(named: 'schedule'),
        nextPickupDate: any(named: 'nextPickupDate'),
      ),
    ).thenAnswer((_) async => const Err<PushSchedule>(NetworkFailure()));

    final result = await useCase(params);

    // 서버 예약이 옛 기준일에 멈춰 있으면 알림이 틀린 날 온다. 성공으로 삼키면
    // 화면은 아무 일 없다는 얼굴을 하고, 사용자는 알림을 놓친 뒤에야 알아챈다.
    expect(result, const Err<PickupInfo>(NetworkFailure()));

    // 다만 기기에는 이미 새 수령 기록이 들어갔다. 호출부가 이 Err 을 보고
    // 로컬까지 안 됐다고 넘겨짚으면 사용자에게 입력을 또 시키게 된다.
    verify(() => pickupRepository.save(savedInfo)).called(1);
  });

  test('수령량을 줄여 주기가 짧아지면 직접 지정 오프셋을 새 주기 안으로 당겨 올린다', () async {
    // 5박스(50일)에서 상한인 D-49 를 쓰던 사용자가 1박스(10일)로 줄인 상황.
    // 49 를 그대로 올리면 서버는 "수령 가능일 49일 전" = 지난 수령일보다도
    // 앞선 날짜로 예약해, 알림이 영영 오지 않는다.
    when(() => pushScheduleRepository.load()).thenAnswer(
      (_) async => Ok(
        PushSchedule.initial.copyWith(
          customEnabled: true,
          customDays: PushSchedule.maxCustomDays,
        ),
      ),
    );
    final oneBox = PickupInfo(pickupDate: DateTime(2026, 7, 20), boxes: 1);
    when(() => pickupRepository.save(any()))
        .thenAnswer((_) async => Ok(oneBox));

    final result = await useCase(
      SavePickupInfoParams(pickupDate: DateTime(2026, 7, 20), boxes: 1),
    );

    expect(result, Ok<PickupInfo>(oneBox));

    final captured = verify(
      () => pushScheduleRepository.save(
        schedule: captureAny(named: 'schedule'),
        nextPickupDate: captureAny(named: 'nextPickupDate'),
      ),
    ).captured;

    expect((captured[0] as PushSchedule).customDays, 9);
    expect((captured[0] as PushSchedule).customEnabled, isTrue);
    expect(captured[1], DateTime(2026, 7, 30));
  });
}
