import 'package:crying_time/app/theme/app_colors.dart';
import 'package:crying_time/feature/common/widget/tear_drop.dart';
import 'package:crying_time/feature/router/routes.dart';
import 'package:crying_time/feature/splash/viewmodel/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 심볼과 텍스트가 시간을 겹쳐 등장하므로, 컨트롤러 하나를 구간(Interval)으로 나눠 쓴다.
const int _symbolMs = 900;
const int _textDelayMs = 350;
const int _textMs = 700;
const int _totalMs = _textDelayMs + _textMs;

/// 텍스트가 제자리로 올라오는 거리.
const double _textRise = 8;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: _totalMs),
  );

  late final CurvedAnimation _symbolFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, _symbolMs / _totalMs, curve: Curves.easeOut),
  );

  late final Animation<double> _symbolScale = Tween<double>(
    begin: 0.82,
    end: 1,
  ).animate(_symbolFade);

  late final CurvedAnimation _textFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(_textDelayMs / _totalMs, 1, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _symbolFade.dispose();
    _textFade.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashViewModelProvider, (_, next) {
      final destination = switch (next) {
        AsyncData(:final value) => value,
        // 실패해도 화면을 붙잡아 두지 않는다. 온보딩에서 다시 시작하면 된다.
        AsyncError() => Routes.onboarding,
        _ => null,
      };
      if (destination == null || !mounted) {
        return;
      }
      context.go(destination);
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _symbolFade,
                child: ScaleTransition(
                  scale: _symbolScale,
                  child: const _SymbolCircle(),
                ),
              ),
              const SizedBox(height: 22),
              AnimatedBuilder(
                animation: _textFade,
                builder: (context, child) => Opacity(
                  opacity: _textFade.value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - _textFade.value) * _textRise),
                    child: child,
                  ),
                ),
                child: const _TitleGroup(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SymbolCircle extends StatelessWidget {
  const _SymbolCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: const TearDrop(size: 44, color: AppColors.onPrimary),
    );
  }
}

class _TitleGroup extends StatelessWidget {
  const _TitleGroup();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '눈물타임',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppColors.onPrimary,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          '인공눈물 재처방 주기 알림',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.onPrimary.withValues(alpha: 0.92),
          ),
        ),
      ],
    );
  }
}
