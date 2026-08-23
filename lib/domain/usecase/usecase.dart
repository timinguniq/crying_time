import 'package:crying_time/domain/result/result.dart';

/// 하나의 유즈케이스는 하나의 동작만 노출한다.
///
/// `call` 로 정의해 호출부에서 `await getPost(params)` 처럼 쓸 수 있다.
abstract interface class UseCase<Out, In> {
  Future<Result<Out>> call(In params);
}

/// 파라미터가 없는 유즈케이스용 빈 인자.
final class NoParams {
  const NoParams();
}
