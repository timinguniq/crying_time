import 'package:crying_time/domain/entity/post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_dto.freezed.dart';
part 'post_dto.g.dart';

/// API 응답 DTO. 서버 스키마 변화는 이 파일과 [toEntity] 안에서만 흡수한다.
@freezed
abstract class PostDto with _$PostDto {
  const PostDto._();

  const factory PostDto({
    required int id,
    required String title,
    required String body,
  }) = _PostDto;

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);

  Post toEntity() => Post(id: id, title: title, body: body);
}
