import 'package:crying_time/data/dto/post_dto.dart';
import 'package:dio/dio.dart';

/// 원격 데이터 소스는 HTTP 호출과 역직렬화만 책임진다. 예외는 그대로 던진다.
abstract interface class PostRemoteDataSource {
  Future<PostDto> fetchPost(int id);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  const PostRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<PostDto> fetchPost(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/posts/$id');
    return PostDto.fromJson(response.data!);
  }
}
