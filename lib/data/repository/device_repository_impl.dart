import 'dart:async';

import 'package:crying_time/data/datasource/device_environment.dart';
import 'package:crying_time/data/datasource/device_id_source.dart';
import 'package:crying_time/data/datasource/device_remote_data_source.dart';
import 'package:crying_time/data/datasource/messaging_source.dart';
import 'package:crying_time/data/dto/device_registration_request_dto.dart';
import 'package:crying_time/data/network/dio_error_mapper.dart';
import 'package:crying_time/domain/entity/device_registration.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/repository/device_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  DeviceRepositoryImpl({
    required this._deviceIdSource,
    required this._messagingSource,
    required this._remoteDataSource,
    required this._environment,
  });

  final DeviceIdSource _deviceIdSource;
  final MessagingSource _messagingSource;
  final DeviceRemoteDataSource _remoteDataSource;
  final DeviceEnvironment _environment;

  StreamSubscription<String>? _tokenRefreshSubscription;

  @override
  Future<Result<DeviceRegistration>> registerDevice() async {
    final token = await _messagingSource.token();
    if (token == null) {
      return const Err(
        UnknownFailure(
          detail: 'fcm token unavailable: notification permission denied',
        ),
      );
    }

    final result = await _register(token);
    // FCM 은 앱 재설치·복원 등으로 토큰을 갈아끼운다. 새 토큰을 서버에 알려주지
    // 않으면 그 시점부터 푸시가 조용히 끊기므로, 등록에 성공하면 갱신도 따라간다.
    if (result case Ok()) {
      _tokenRefreshSubscription ??= _messagingSource.tokenRefreshes.listen(
        (refreshed) => unawaited(_registerRefreshed(refreshed)),
      );
    }

    return result;
  }

  /// 갱신된 토큰을 다시 등록한다.
  ///
  /// 실패하면 서버가 죽은 토큰을 들고 있어 푸시가 조용히 끊기는데, 사용자가
  /// 조작하지 않은 백그라운드 이벤트라 화면에 띄울 자리가 없다. 원인을 찾을 수
  /// 있도록 로그만 남긴다.
  Future<void> _registerRefreshed(String token) async {
    final result = await _register(token);
    if (result case Err(:final failure)) {
      debugPrint('fcm token refresh registration failed: $failure');
    }
  }

  Future<Result<DeviceRegistration>> _register(String token) async {
    try {
      final deviceId = await _deviceIdSource.deviceId();
      final platform = _environment.platform;

      await _remoteDataSource.registerDevice(
        DeviceRegistrationRequestDto(
          deviceId: deviceId,
          fcmToken: token,
          platform: platform,
          utcOffsetMinutes: _environment.utcOffsetMinutes,
        ),
      );

      return Ok(
        DeviceRegistration(
          deviceId: deviceId,
          fcmToken: token,
          platform: platform,
        ),
      );
    } on DioException catch (e) {
      return Err(e.toFailure());
    } catch (e) {
      return Err(UnknownFailure(detail: '$e'));
    }
  }
}
