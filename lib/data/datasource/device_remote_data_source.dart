import 'package:crying_time/data/dto/device_registration_request_dto.dart';
import 'package:crying_time/data/dto/push_enabled_request_dto.dart';
import 'package:crying_time/data/dto/push_schedule_request_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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

/// 서버가 준비되기 전까지 쓰는 목. 요청 본문을 로그로 확인할 수 있다.
class MockDeviceRemoteDataSource implements DeviceRemoteDataSource {
  const MockDeviceRemoteDataSource();

  static const Duration _latency = Duration(milliseconds: 300);

  @override
  Future<void> registerDevice(DeviceRegistrationRequestDto request) async {
    await Future<void>.delayed(_latency);
    debugPrint('[mock] POST /v1/devices ${request.toJson()}');
  }

  @override
  Future<void> updatePushSchedule({
    required String deviceId,
    required PushScheduleRequestDto request,
  }) async {
    await Future<void>.delayed(_latency);
    debugPrint(
      '[mock] PUT /v1/devices/$deviceId/push-schedule ${request.toJson()}',
    );
  }

  @override
  Future<void> updatePushEnabled({
    required String deviceId,
    required PushEnabledRequestDto request,
  }) async {
    await Future<void>.delayed(_latency);
    debugPrint(
      '[mock] PUT /v1/devices/$deviceId/push-enabled ${request.toJson()}',
    );
  }
}
