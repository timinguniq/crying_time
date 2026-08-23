import 'package:crying_time/domain/entity/post.dart';
import 'package:crying_time/domain/repository/post_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/usecase.dart';

class GetPost implements UseCase<Post, GetPostParams> {
  const GetPost(this._repository);

  final PostRepository _repository;

  @override
  Future<Result<Post>> call(GetPostParams params) =>
      _repository.getPost(params.id);
}

final class GetPostParams {
  const GetPostParams({required this.id});

  final int id;
}
