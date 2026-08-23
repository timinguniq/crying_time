import 'package:crying_time/feature/home/ui/home_screen.dart';
import 'package:crying_time/feature/onboarding/ui/onboarding_screen.dart';
import 'package:crying_time/feature/pickup_edit/ui/pickup_edit_screen.dart';
import 'package:crying_time/feature/router/routes.dart';
import 'package:crying_time/feature/settings/ui/settings_screen.dart';
import 'package:crying_time/feature/splash/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// 라우터는 앱 수명 내내 살아있어야 하므로 keepAlive.
/// 스플래시가 저장된 수령 기록을 보고 온보딩/홈으로 직접 보낸다.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.pickupEdit,
        builder: (context, state) => const PickupEditScreen(),
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
