import 'package:crying_time/app/theme/app_colors.dart';
import 'package:crying_time/feature/common/widget/app_primary_button.dart';
import 'package:crying_time/feature/common/widget/tear_drop.dart';
import 'package:crying_time/feature/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:crying_time/feature/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubmitting = ref.watch(onboardingViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 소개 블록을 화면 가운데로 밀어내기 위한 빈 자리.
              const SizedBox(),
              const _Intro(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '국민건강보험 급여 기준(1일 6개)으로 계산해요',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 12),
                  AppPrimaryButton(
                    label: '시작하기',
                    // 저장 중에는 눌리지 않게 해 중복 저장을 막는다.
                    onPressed: isSubmitting ? null : () => _start(context, ref),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _start(BuildContext context, WidgetRef ref) async {
    final (:canProceed, :message) = await ref
        .read(onboardingViewModelProvider.notifier)
        .start();
    if (!context.mounted) {
      return;
    }

    // 서버 예약만 실패한 경우엔 알린 뒤에도 홈으로 넘긴다. SnackBar 는 앱
    // 전역 ScaffoldMessenger 가 들고 있어 화면이 바뀌어도 그대로 보인다.
    if (message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    if (canProceed) {
      context.go(Routes.home);
    }
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 96,
          height: 96,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primarySoft,
            shape: BoxShape.circle,
          ),
          child: const TearDrop(size: 40, color: AppColors.primary),
        ),
        const SizedBox(height: 24),
        const Text(
          '눈물타임',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '인공눈물 재처방 주기를\n놓치지 않게 알려드려요',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        // 문장은 왼쪽으로 맞추되, 목록 전체는 가운데에 놓는다.
        const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FeatureLine('수령일 기준 50일 주기 자동 계산'),
            SizedBox(height: 10),
            _FeatureLine('재처방 가능일 미리 알림'),
            SizedBox(height: 10),
            _FeatureLine('알림 시점 직접 설정'),
          ],
        ),
      ],
    );
  }
}

class _FeatureLine extends StatelessWidget {
  const _FeatureLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 13.5, color: AppColors.textBody),
        ),
      ],
    );
  }
}
