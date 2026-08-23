import 'package:crying_time/feature/home/ui/home_screen.dart';
import 'package:crying_time/feature/post/ui/post_screen.dart';
import 'package:crying_time/feature/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// 라우터는 앱 수명 내내 살아있어야 하므로 keepAlive.
/// 로그인 가드 같은 전역 분기는 여기 `redirect` 에 붙인다.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.post,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            return const _RouteErrorScreen(message: '잘못된 게시글 번호입니다.');
          }
          return PostScreen(postId: id);
        },
      ),
    ],
    errorBuilder: (context, state) =>
        _RouteErrorScreen(message: '경로를 찾을 수 없습니다.\n${state.uri}'),
  );
}

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(message, textAlign: TextAlign.center)),
    );
  }
}
