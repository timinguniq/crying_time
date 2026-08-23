import 'package:crying_time/app/di/service_locator.dart';
import 'package:crying_time/data/datasource/post_remote_data_source.dart';
import 'package:crying_time/data/network/dio_client.dart';
import 'package:crying_time/data/repository/post_repository_impl.dart';
import 'package:crying_time/domain/repository/post_repository.dart';
import 'package:crying_time/domain/usecase/get_post.dart';
import 'package:dio/dio.dart';

/// domain / data 계층의 객체 그래프를 조립한다. 앱 시작 시 `main` 에서 한 번 호출한다.
///
/// 여기서만 구현체(Impl)를 알고, 나머지 코드는 인터페이스만 본다.
void configureDependencies() {
  getIt
    // network
    ..registerLazySingleton<Dio>(createDio)
    // data source
    ..registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(getIt<Dio>()),
    )
    // repository
    ..registerLazySingleton<PostRepository>(
      () => PostRepositoryImpl(getIt<PostRemoteDataSource>()),
    )
    // use case
    ..registerLazySingleton<GetPost>(() => GetPost(getIt<PostRepository>()));
}
