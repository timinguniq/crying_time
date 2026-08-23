import 'package:crying_time/domain/failure/failure.dart';
import 'package:dio/dio.dart';

/// DioException 을 도메인 Failure 로 번역하는 유일한 지점.
extension DioExceptionMapper on DioException {
  Failure toFailure() => switch (type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout ||
    DioExceptionType.badCertificate ||
    DioExceptionType.connectionError => const NetworkFailure(),
    DioExceptionType.badResponse => _fromStatusCode(response?.statusCode),
    DioExceptionType.cancel => const UnknownFailure(detail: 'request cancelled'),
    DioExceptionType.unknown => UnknownFailure(detail: message),
  };

  Failure _fromStatusCode(int? statusCode) => switch (statusCode) {
    401 || 403 => const UnauthorizedFailure(),
    404 => const NotFoundFailure(),
    _ => ServerFailure(statusCode: statusCode),
  };
}
