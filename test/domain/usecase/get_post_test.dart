import 'package:crying_time/domain/entity/post.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/repository/post_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/get_post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late MockPostRepository repository;
  late GetPost useCase;

  setUp(() {
    repository = MockPostRepository();
    useCase = GetPost(repository);
  });

  const post = Post(id: 1, title: '제목', body: '본문');

  test('저장소가 성공하면 결과를 그대로 전달한다', () async {
    when(() => repository.getPost(1)).thenAnswer((_) async => const Ok(post));

    final result = await useCase(const GetPostParams(id: 1));

    expect(result, const Ok(post));
    verify(() => repository.getPost(1)).called(1);
  });

  test('저장소가 실패하면 실패를 그대로 전달한다', () async {
    when(
      () => repository.getPost(1),
    ).thenAnswer((_) async => const Err<Post>(NetworkFailure()));

    final result = await useCase(const GetPostParams(id: 1));

    expect(result, const Err<Post>(NetworkFailure()));
  });
}
