import 'package:crying_time/data/datasource/device_environment.dart';
import 'package:crying_time/data/datasource/device_id_source.dart';
import 'package:crying_time/data/datasource/device_remote_data_source.dart';
import 'package:crying_time/data/datasource/push_schedule_local_data_source.dart';
import 'package:crying_time/data/dto/push_enabled_request_dto.dart';
import 'package:crying_time/data/dto/push_schedule_request_dto.dart';
import 'package:crying_time/data/network/dio_error_mapper.dart';
import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/repository/push_schedule_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:dio/dio.dart';

class PushScheduleRepositoryImpl implements PushScheduleRepository {
  const PushScheduleRepositoryImpl({
    required this._localDataSource,
    required this._remoteDataSource,
    required this._deviceIdSource,
    required this._environment,
  });

  final PushScheduleLocalDataSource _localDataSource;
  final DeviceRemoteDataSource _remoteDataSource;
  final DeviceIdSource _deviceIdSource;
  final DeviceEnvironment _environment;

  @override
  Future<Result<PushSchedule>> load() async {
    try {
      final record = await _localDataSource.read();
      if (record == null) {
        return const Ok(PushSchedule.initial);
      }

      return Ok(
        PushSchedule(
          enabled: record.enabled,
          notifyD7: record.notifyD7,
          notifyD3: record.notifyD3,
          notifyDDay: record.notifyDDay,
          customEnabled: record.customEnabled,
          customDays: record.customDays,
        ),
      );
    } catch (e) {
      return Err(UnknownFailure(detail: '$e'));
    }
  }

  /// 로컬 저장을 먼저 끝내고 서버에 보낸다.
  ///
  /// 통신이 실패해도 화면에 찍힌 값과 기기에 남은 값은 어긋나지 않고, 사용자는
  /// 실패 문구만 보게 된다. 다음 변경 때 최신 설정 전체가 다시 올라간다.
  @override
  Future<Result<PushSchedule>> save({
    required PushSchedule schedule,
    required DateTime nextPickupDate,
  }) async {
    try {
      await _writeLocal(schedule);

      await _remoteDataSource.updatePushSchedule(
        deviceId: await _deviceIdSource.deviceId(),
        request: PushScheduleRequestDto.fromEntity(
          schedule: schedule,
          nextPickupDate: nextPickupDate,
          utcOffsetMinutes: _environment.utcOffsetMinutes,
        ),
      );

      return Ok(schedule);
    } on DioException catch (e) {
      return Err(e.toFailure());
    } catch (e) {
      return Err(UnknownFailure(detail: '$e'));
    }
  }

  @override
  Future<Result<PushSchedule>> setEnabled(PushSchedule schedule) async {
    try {
      await _writeLocal(schedule);

      await _remoteDataSource.updatePushEnabled(
        deviceId: await _deviceIdSource.deviceId(),
        request: PushEnabledRequestDto(enabled: schedule.enabled),
      );

      return Ok(schedule);
    } on DioException catch (e) {
      return Err(e.toFailure());
    } catch (e) {
      return Err(UnknownFailure(detail: '$e'));
    }
  }

  Future<void> _writeLocal(PushSchedule schedule) => _localDataSource.write((
    enabled: schedule.enabled,
    notifyD7: schedule.notifyD7,
    notifyD3: schedule.notifyD3,
    notifyDDay: schedule.notifyDDay,
    customEnabled: schedule.customEnabled,
    customDays: schedule.customDays,
  ));
}
