import 'package:crying_time/data/dto/device_registration_request_dto.dart';
import 'package:crying_time/data/dto/push_enabled_request_dto.dart';
import 'package:crying_time/data/dto/push_schedule_request_dto.dart';
import 'package:dio/dio.dart';

/// 원격 데이터 소스는 HTTP 호출과 직렬화만 책임진다. 예외는 그대로 던진다.
abstract interface class DeviceRemoteDataSource {
  Future<void> registerDevice(DeviceRegistrationRequestDto request);

  Future<void> updatePushSchedule({
    required String deviceId,
    required PushScheduleRequestDto request,
  });

  Future<void> updatePushEnabled({
    required String deviceId,
    required PushEnabledRequestDto request,
  });
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  const DeviceRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> registerDevice(DeviceRegistrationRequestDto request) async {
    await _dio.post<void>('/v1/devices', data: request.toJson());
  }

  @override
  Future<void> updatePushSchedule({
    required String deviceId,
    required PushScheduleRequestDto request,
  }) async {
    await _dio.put<void>(
      '/v1/devices/$deviceId/push-schedule',
      data: request.toJson(),
    );
  }

  @override
  Future<void> updatePushEnabled({
    required String deviceId,
    required PushEnabledRequestDto request,
  }) async {
    await _dio.put<void>(
      '/v1/devices/$deviceId/push-enabled',
      data: request.toJson(),
    );
  }
}
