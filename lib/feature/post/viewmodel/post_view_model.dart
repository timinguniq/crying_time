import 'package:crying_time/app/di/service_locator.dart';
import 'package:crying_time/domain/entity/post.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/get_post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_view_model.g.dart';

/// 게시글 상세 화면의 상태. Failure 를 던져 AsyncError 로 표면화한다.
///
/// 유즈케이스는 GetIt 에서 직접 꺼낸다. 테스트에서는 GetIt 에 mock 을 등록해 격리한다.
@riverpod
class PostViewModel extends _$PostViewModel {
  @override
  Future<Post> build(int postId) async {
    final getPost = getIt<GetPost>();
    final result = await getPost(GetPostParams(id: postId));

    return switch (result) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }
}
