import 'package:crying_time/data/datasource/post_remote_data_source.dart';
import 'package:crying_time/data/network/dio_error_mapper.dart';
import 'package:crying_time/domain/entity/post.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/repository/post_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:dio/dio.dart';

/// 예외를 Failure 로 바꾸고 DTO 를 엔티티로 바꾸는, data 와 domain 사이의 번역 계층.
class PostRepositoryImpl implements PostRepository {
  const PostRepositoryImpl(this._remoteDataSource);

  final PostRemoteDataSource _remoteDataSource;

  @override
  Future<Result<Post>> getPost(int id) async {
    try {
      final dto = await _remoteDataSource.fetchPost(id);
      return Ok(dto.toEntity());
    } on DioException catch (e) {
      return Err(e.toFailure());
    } on TypeError catch (e) {
      return Err(ParsingFailure(detail: '$e'));
    } catch (e) {
      return Err(UnknownFailure(detail: '$e'));
    }
  }
}
