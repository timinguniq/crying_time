import 'package:crying_time/domain/failure/failure.dart';

/// 도메인 실패 타입 → 사용자에게 보여줄 문구.
///
/// 문구는 ui 의 관심사라 domain 이 아니라 여기에 둔다. 다국어를 붙일 때도
/// 이 파일만 AppLocalizations 를 쓰도록 바꾸면 된다.
extension FailureMessage on Failure {
  String get message => switch (this) {
    NetworkFailure() => '네트워크 연결을 확인해주세요.',
    UnauthorizedFailure() => '인증이 만료되었습니다. 다시 로그인해주세요.',
    NotFoundFailure() => '요청한 데이터를 찾을 수 없습니다.',
    ServerFailure() => '서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요.',
    ParsingFailure() => '응답을 처리하지 못했습니다.',
    UnknownFailure() => '알 수 없는 오류가 발생했습니다.',
  };
}
