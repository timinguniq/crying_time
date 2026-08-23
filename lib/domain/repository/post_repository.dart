import 'package:crying_time/domain/entity/post.dart';
import 'package:crying_time/domain/result/result.dart';

/// domain 이 소유하는 인터페이스. 구현은 data 계층이 제공한다(의존성 역전).
abstract interface class PostRepository {
  Future<Result<Post>> getPost(int id);
}
