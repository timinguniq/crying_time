import 'package:crying_time/app/di/service_locator.dart';
import 'package:crying_time/app/provider_retry.dart';
import 'package:crying_time/domain/entity/post.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/get_post.dart';
import 'package:crying_time/feature/common/failure_message.dart';
import 'package:crying_time/feature/post/ui/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPost extends Mock implements GetPost {}

void main() {
  late MockGetPost useCase;

  setUpAll(() => registerFallbackValue(const GetPostParams(id: 0)));

  setUp(() {
    useCase = MockGetPost();
    getIt.registerSingleton<GetPost>(useCase);
  });

  tearDown(() => getIt.reset());

  Future<void> pumpScreen(WidgetTester tester) {
    return tester.pumpWidget(
      const ProviderScope(
        retry: noProviderRetry,
        child: MaterialApp(home: PostScreen(postId: 1)),
      ),
    );
  }

  testWidgets('성공하면 제목과 본문을 보여준다', (tester) async {
    when(() => useCase(any())).thenAnswer(
      (_) async => const Ok(Post(id: 1, title: '제목', body: '본문')),
    );

    await pumpScreen(tester);
    await tester.pump();

    expect(find.text('제목'), findsOneWidget);
    expect(find.text('본문'), findsOneWidget);
  });

  testWidgets('실패하면 Failure 메시지와 재시도 버튼을 보여준다', (tester) async {
    when(
      () => useCase(any()),
    ).thenAnswer((_) async => const Err<Post>(NetworkFailure()));

    await pumpScreen(tester);
    await tester.pump();

    expect(find.text(const NetworkFailure().message), findsOneWidget);
    expect(find.text('다시 시도'), findsOneWidget);
  });
}
