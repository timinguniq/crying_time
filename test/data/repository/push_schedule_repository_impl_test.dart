import 'package:crying_time/data/datasource/device_environment.dart';
import 'package:crying_time/data/datasource/device_id_source.dart';
import 'package:crying_time/data/datasource/device_remote_data_source.dart';
import 'package:crying_time/data/datasource/push_schedule_local_data_source.dart';
import 'package:crying_time/data/dto/push_enabled_request_dto.dart';
import 'package:crying_time/data/dto/push_schedule_request_dto.dart';
import 'package:crying_time/data/repository/push_schedule_repository_impl.dart';
import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalDataSource extends Mock
    implements PushScheduleLocalDataSource {}

class _MockRemoteDataSource extends Mock implements DeviceRemoteDataSource {}

class _MockDeviceIdSource extends Mock implements DeviceIdSource {}

class _MockDeviceEnvironment extends Mock implements DeviceEnvironment {}

/// 이 저장소가 "화면에 보이는 값"과 "서버가 아는 값"을 잇는 유일한 지점이다.
void main() {
  late _MockLocalDataSource localDataSource;
  late _MockRemoteDataSource remoteDataSource;
  late _MockDeviceIdSource deviceIdSource;
  late _MockDeviceEnvironment environment;
  late PushScheduleRepositoryImpl repository;

  final schedule = PushSchedule.initial.copyWith(
    customEnabled: true,
    customDays: 21,
  );
  final nextPickupDate = DateTime(2026, 9, 8);

  DioException dioError(DioExceptionType type, {Response<void>? response}) =>
      DioException(
        requestOptions: RequestOptions(path: '/v1/devices'),
        type: type,
        response: response,
      );

  setUpAll(() {
    const PushScheduleRecord fallbackRecord = (
      enabled: false,
      notifyD7: false,
      notifyD3: false,
      notifyDDay: false,
      customEnabled: false,
      customDays: 1,
    );
    registerFallbackValue(fallbackRecord);
    registerFallbackValue(
      const PushScheduleRequestDto(
        enabled: false,
        offsetDays: <int>[],
        nextPickupDate: '',
        utcOffsetMinutes: 0,
      ),
    );
    registerFallbackValue(const PushEnabledRequestDto(enabled: false));
  });

  setUp(() {
    localDataSource = _MockLocalDataSource();
    remoteDataSource = _MockRemoteDataSource();
    deviceIdSource = _MockDeviceIdSource();
    environment = _MockDeviceEnvironment();
    repository = PushScheduleRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
      deviceIdSource: deviceIdSource,
      environment: environment,
    );

    when(() => localDataSource.write(any())).thenAnswer((_) async {});
    when(() => deviceIdSource.deviceId()).thenAnswer((_) async => 'device-1');
    when(() => environment.utcOffsetMinutes).thenReturn(540);
    when(
      () => remoteDataSource.updatePushSchedule(
        deviceId: any(named: 'deviceId'),
        request: any(named: 'request'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => remoteDataSource.updatePushEnabled(
        deviceId: any(named: 'deviceId'),
        request: any(named: 'request'),
      ),
    ).thenAnswer((_) async {});
  });

  test('setEnabled 는 on/off 전용 엔드포인트만 부르고 시점은 서버에 그대로 둔다', () async {
    final off = schedule.copyWith(enabled: false);

    final result = await repository.setEnabled(off);

    expect(result, Ok<PushSchedule>(off));

    final verifications = verifyInOrder([
      () => localDataSource.write(captureAny()),
      () => remoteDataSource.updatePushEnabled(
            deviceId: captureAny(named: 'deviceId'),
            request: captureAny(named: 'request'),
          ),
    ]);

    // 껐어도 시점 선택은 기기에 남겨야 다시 켤 때 그대로 살아난다.
    final record = verifications[0].captured.single as PushScheduleRecord;
    expect(record.enabled, isFalse);
    expect(record.notifyD7, isTrue);
    expect(record.customDays, 21);

    final remoteArgs = verifications[1].captured;
    expect(remoteArgs[0], 'device-1');
    expect((remoteArgs[1] as PushEnabledRequestDto).enabled, isFalse);

    verifyNever(
      () => remoteDataSource.updatePushSchedule(
        deviceId: any(named: 'deviceId'),
        request: any(named: 'request'),
      ),
    );
  });

  test('setEnabled 통신이 끊겨도 로컬 저장은 이미 반영돼 있다', () async {
    when(
      () => remoteDataSource.updatePushEnabled(
        deviceId: any(named: 'deviceId'),
        request: any(named: 'request'),
      ),
    ).thenThrow(dioError(DioExceptionType.connectionError));

    final result = await repository.setEnabled(
      schedule.copyWith(enabled: false),
    );

    expect(result, const Err<PushSchedule>(NetworkFailure()));
    verify(() => localDataSource.write(any())).called(1);
  });

  test('로컬에 먼저 쓰고 그다음 서버로 PUT 한다', () async {
    final result = await repository.save(
      schedule: schedule,
      nextPickupDate: nextPickupDate,
    );

    expect(result, Ok<PushSchedule>(schedule));

    final verifications = verifyInOrder([
      () => localDataSource.write(captureAny()),
      () => remoteDataSource.updatePushSchedule(
            deviceId: captureAny(named: 'deviceId'),
            request: captureAny(named: 'request'),
          ),
    ]);

    final record = verifications[0].captured.single as PushScheduleRecord;
    expect(record.enabled, isTrue);
    expect(record.customEnabled, isTrue);
    expect(record.customDays, 21);

    final remoteArgs = verifications[1].captured;
    expect(remoteArgs[0], 'device-1');

    final request = remoteArgs[1] as PushScheduleRequestDto;
    expect(request.enabled, isTrue);
    expect(request.offsetDays, <int>[21, 7, 3, 0]);
    expect(request.nextPickupDate, '2026-09-08');
    expect(request.utcOffsetMinutes, 540);
  });

  test('통신이 끊기면 NetworkFailure 가 되고 로컬 저장은 이미 반영돼 있다', () async {
    when(
      () => remoteDataSource.updatePushSchedule(
        deviceId: any(named: 'deviceId'),
        request: any(named: 'request'),
      ),
    ).thenThrow(dioError(DioExceptionType.connectionError));

    final result = await repository.save(
      schedule: schedule,
      nextPickupDate: nextPickupDate,
    );

    // 화면은 낙관적으로 이미 새 값이라, 로컬까지 안 써두면 다음 실행 때 값이 되돌아간다.
    expect(result, const Err<PushSchedule>(NetworkFailure()));
    verify(() => localDataSource.write(any())).called(1);
  });

  test('서버가 5xx 로 답하면 상태 코드를 담은 ServerFailure 가 된다', () async {
    when(
      () => remoteDataSource.updatePushSchedule(
        deviceId: any(named: 'deviceId'),
        request: any(named: 'request'),
      ),
    ).thenThrow(
      dioError(
        DioExceptionType.badResponse,
        response: Response<void>(
          requestOptions: RequestOptions(path: '/v1/devices'),
          statusCode: 500,
        ),
      ),
    );

    final result = await repository.save(
      schedule: schedule,
      nextPickupDate: nextPickupDate,
    );

    expect(result, const Err<PushSchedule>(ServerFailure(statusCode: 500)));
    verify(() => localDataSource.write(any())).called(1);
  });
}
