import 'package:crying_time/data/network/api_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 앱 전역에서 공유하는 Dio 인스턴스를 만든다.
///
/// 인증 토큰 주입 같은 공통 관심사는 여기에 인터셉터로 추가한다.
Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: const {'Content-Type': 'application/json'},
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  return dio;
}
