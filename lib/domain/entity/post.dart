import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';

/// 도메인 엔티티. JSON 을 모르며, 외부 API 형식이 바뀌어도 이 파일은 그대로다.
@freezed
abstract class Post with _$Post {
  const factory Post({
    required int id,
    required String title,
    required String body,
  }) = _Post;
}
