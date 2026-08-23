import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// 도메인 계층이 다루는 실패 유형.
///
/// data 계층 경계에서 모든 예외(DioException 등)를 Failure 로 변환하기 때문에
/// domain / feature 계층으로는 raw 예외가 새어 나가지 않는다.
///
/// "무엇이 실패했는가"(타입)만 담는다. 사용자에게 보여줄 문구는 ui 의 몫이며
/// `feature/common/failure_message.dart` 가 담당한다.
/// `detail` 은 로그/디버깅용이라 화면에 그대로 띄우지 않는다.
@freezed
sealed class Failure with _$Failure implements Exception {
  const Failure._();

  /// 서버에 도달하지 못한 경우(연결 없음, 타임아웃, 인증서 오류 등).
  const factory Failure.network() = NetworkFailure;

  /// 서버가 응답했지만 오류 상태 코드를 반환한 경우.
  const factory Failure.server({int? statusCode}) = ServerFailure;

  const factory Failure.unauthorized() = UnauthorizedFailure;

  const factory Failure.notFound() = NotFoundFailure;

  /// 응답 형식이 기대와 다른 경우.
  const factory Failure.parsing({String? detail}) = ParsingFailure;

  const factory Failure.unknown({String? detail}) = UnknownFailure;
}
