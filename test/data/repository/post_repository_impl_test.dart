import 'package:crying_time/data/datasource/post_remote_data_source.dart';
import 'package:crying_time/data/dto/post_dto.dart';
import 'package:crying_time/data/repository/post_repository_impl.dart';
import 'package:crying_time/domain/entity/post.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

DioException _badResponse(int statusCode) {
  final options = RequestOptions(path: '/posts/1');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<void>(requestOptions: options, statusCode: statusCode),
  );
}

void main() {
  late MockPostRemoteDataSource remoteDataSource;
  late PostRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockPostRemoteDataSource();
    repository = PostRepositoryImpl(remoteDataSource);
  });

  test('원격 DTO 를 엔티티로 변환한다', () async {
    when(() => remoteDataSource.fetchPost(1)).thenAnswer(
      (_) async => const PostDto(id: 1, title: '제목', body: '본문'),
    );

    final result = await repository.getPost(1);

    expect(result, const Ok(Post(id: 1, title: '제목', body: '본문')));
  });

  test('404 응답은 NotFoundFailure 로 변환된다', () async {
    when(() => remoteDataSource.fetchPost(1)).thenThrow(_badResponse(404));

    final result = await repository.getPost(1);

    expect(result, const Err<Post>(NotFoundFailure()));
  });

  test('연결 타임아웃은 NetworkFailure 로 변환된다', () async {
    when(() => remoteDataSource.fetchPost(1)).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/posts/1'),
        type: DioExceptionType.connectionTimeout,
      ),
    );

    final result = await repository.getPost(1);

    expect(result, const Err<Post>(NetworkFailure()));
  });

  test('500 응답은 상태 코드를 담은 ServerFailure 로 변환된다', () async {
    when(() => remoteDataSource.fetchPost(1)).thenThrow(_badResponse(500));

    final result = await repository.getPost(1);

    expect(result, isA<Err<Post>>());
    expect((result as Err<Post>).failure, isA<ServerFailure>());
    expect((result.failure as ServerFailure).statusCode, 500);
  });
}
