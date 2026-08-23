import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/repository/pickup_repository.dart';
import 'package:crying_time/domain/repository/push_schedule_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/sync_push_schedule.dart';
import 'package:crying_time/domain/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPickupRepository extends Mock implements PickupRepository {}

class _MockPushScheduleRepository extends Mock
    implements PushScheduleRepository {}

/// 설정을 바꾸던 순간 통신이 끊기면 서버에는 옛 값만 남는다.
///
/// 앱을 켤 때마다 현재 설정을 다시 밀어 넣지 않으면, 사용자가 설정을 또 건드리기
/// 전까지 기기 화면과 서버 예약이 영영 어긋난 채로 있는다.
void main() {
  late _MockPickupRepository pickupRepository;
  late _MockPushScheduleRepository pushScheduleRepository;
  late SyncPushSchedule useCase;

  // 3박스(30일)라서 기준일을 새로 계산하지 않으면 날짜가 눈에 띄게 어긋난다.
  final storedInfo = PickupInfo(pickupDate: DateTime(2026, 7, 20), boxes: 3);
  final storedSchedule = PushSchedule.initial.copyWith(
    notifyD7: false,
    customEnabled: true,
    customDays: 21,
  );

  setUpAll(() {
    registerFallbackValue(PushSchedule.initial);
    registerFallbackValue(DateTime(2026, 1, 1));
  });

  setUp(() {
    pickupRepository = _MockPickupRepository();
    pushScheduleRepository = _MockPushScheduleRepository();
    useCase = SyncPushSchedule(pickupRepository, pushScheduleRepository);

    when(() => pushScheduleRepository.load())
        .thenAnswer((_) async => Ok(storedSchedule));
    when(
      () => pushScheduleRepository.save(
        schedule: any(named: 'schedule'),
        nextPickupDate: any(named: 'nextPickupDate'),
      ),
    ).thenAnswer((_) async => Ok(storedSchedule));
  });

  test('수령 기록이 있으면 저장된 스케줄을 그 기록의 수령 가능일로 다시 올린다', () async {
    when(() => pickupRepository.load())
        .thenAnswer((_) async => Ok<PickupInfo?>(storedInfo));

    final result = await useCase(const NoParams());

    expect(result, Ok<PushSchedule>(storedSchedule));

    final captured = verify(
      () => pushScheduleRepository.save(
        schedule: captureAny(named: 'schedule'),
        nextPickupDate: captureAny(named: 'nextPickupDate'),
      ),
    ).captured;

    // 기본값이 아니라 기기에 저장돼 있던 설정 그대로 올라가야 한다.
    expect(captured[0], storedSchedule);
    expect(captured[1], storedInfo.nextPickupDate);
    expect(captured[1], DateTime(2026, 8, 19));
  });

  test('수령 기록이 없으면 올릴 기준일이 없으므로 서버를 건드리지 않고 Ok 를 준다', () async {
    when(() => pickupRepository.load())
        .thenAnswer((_) async => const Ok<PickupInfo?>(null));

    final result = await useCase(const NoParams());

    // 온보딩 전에 기준일 없이 예약을 걸면 서버가 엉뚱한 날짜를 잡는다.
    expect(result, Ok<PushSchedule>(storedSchedule));
    verifyNever(
      () => pushScheduleRepository.save(
        schedule: any(named: 'schedule'),
        nextPickupDate: any(named: 'nextPickupDate'),
      ),
    );
  });

  test('저장된 설정을 읽지 못하면 무엇을 올릴지 모르므로 실패를 그대로 돌려준다', () async {
    when(() => pushScheduleRepository.load())
        .thenAnswer((_) async => const Err<PushSchedule>(UnknownFailure()));

    final result = await useCase(const NoParams());

    expect(result, const Err<PushSchedule>(UnknownFailure()));
    verifyNever(() => pickupRepository.load());
    verifyNever(
      () => pushScheduleRepository.save(
        schedule: any(named: 'schedule'),
        nextPickupDate: any(named: 'nextPickupDate'),
      ),
    );
  });

  test('서버 반영이 실패하면 어긋난 채로 남았다는 뜻이므로 실패를 올린다', () async {
    when(() => pickupRepository.load())
        .thenAnswer((_) async => Ok<PickupInfo?>(storedInfo));
    when(
      () => pushScheduleRepository.save(
        schedule: any(named: 'schedule'),
        nextPickupDate: any(named: 'nextPickupDate'),
      ),
    ).thenAnswer((_) async => const Err<PushSchedule>(NetworkFailure()));

    final result = await useCase(const NoParams());

    expect(result, const Err<PushSchedule>(NetworkFailure()));
  });
}
