import 'package:crying_time/app/theme/app_colors.dart';
import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/feature/common/failure_message.dart';
import 'package:crying_time/feature/common/korean_date.dart';
import 'package:crying_time/feature/common/push_offset_label.dart';
import 'package:crying_time/feature/common/widget/app_outline_button.dart';
import 'package:crying_time/feature/common/widget/app_section_card.dart';
import 'package:crying_time/feature/common/widget/app_soft_button.dart';
import 'package:crying_time/feature/common/widget/progress_ring.dart';
import 'package:crying_time/feature/home/viewmodel/home_view_model.dart';
import 'package:crying_time/feature/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: switch (asyncState) {
          AsyncData(:final value) => _HomeContent(state: value),
          AsyncError(:final error) => _HomeError(
            error: error,
            onRetry: () => ref.invalidate(homeViewModelProvider),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = state.pickupInfo;
    final canRefill = info.canRefillOn(state.today);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('눈물타임', style: Theme.of(context).textTheme.titleMedium),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.today.monthDayWeekday,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 10),
                    AppOutlineButton(
                      label: '설정',
                      onPressed: () =>
                          _openAndRefresh(context, ref, Routes.settings),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _RingBlock(info: info, today: state.today, canRefill: canRefill),
          if (canRefill)
            _RefillBanner(onReceived: () => _markReceivedToday(context, ref)),
          _ActionCard(
            label: '마지막 수령일',
            value: info.pickupDate.monthDayWeekday,
            valueFontSize: 15,
            actionLabel: '변경',
            onPressed: () => _openAndRefresh(context, ref, Routes.pickupEdit),
          ),
          _ActionCard(
            label: '재처방 알림',
            value: pushScheduleSummary(state.schedule),
            valueFontSize: 14,
            actionLabel: '관리',
            onPressed: () => _openAndRefresh(context, ref, Routes.settings),
          ),
          _CoverageNotice(info: info),
        ],
      ),
    );
  }
}

/// 링 + 다음 수령 가능일 알약. 수령 가능한 날이면 초록으로 바뀐다.
class _RingBlock extends StatelessWidget {
  const _RingBlock({
    required this.info,
    required this.today,
    required this.canRefill,
  });

  final PickupInfo info;
  final DateTime today;
  final bool canRefill;

  @override
  Widget build(BuildContext context) {
    final accent = canRefill ? AppColors.success : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 8),
      child: Column(
        children: [
          ProgressRing(
            progress: info.progressOn(today),
            color: accent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                const Text(
                  '다음 수령까지',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  canRefill ? 'D-DAY' : 'D-${info.daysLeftOn(today)}',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    color: accent,
                  ),
                ),
                Text(
                  '${info.elapsedDaysOn(today)}일 / ${info.cycleDays}일',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          DecoratedBox(
            decoration: BoxDecoration(
              color: canRefill ? AppColors.successSoft : AppColors.primarySoft,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child: Text(
                '${info.nextPickupDate.monthDayWeekday} 수령 가능',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RefillBanner extends StatelessWidget {
  const _RefillBanner({required this.onReceived});

  final VoidCallback onReceived;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 15, 15, 15),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              '오늘 수령해야 되는 날입니다',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimary,
              ),
            ),
          ),
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(99),
            child: InkWell(
              onTap: onReceived,
              borderRadius: BorderRadius.circular(99),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  '수령 완료',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 값 하나와 이동 버튼 하나를 가진 카드('마지막 수령일', '재처방 알림').
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.label,
    required this.value,
    required this.valueFontSize,
    required this.actionLabel,
    required this.onPressed,
  });

  final String label;
  final String value;
  final double valueFontSize;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppSoftButton(label: actionLabel, onPressed: onPressed),
        ],
      ),
    );
  }
}

class _CoverageNotice extends StatelessWidget {
  const _CoverageNotice({required this.info});

  final PickupInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.infoBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          const Text(
            '건강보험 급여 기준',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          Text(
            '인공눈물은 1일 6개까지 급여가 적용되어, '
            '${info.boxes}박스(${info.totalDoses}개)는 ${info.cycleDays}일 후 '
            '재처방 시 보험 적용이 가능해요. 실제 기준은 처방에 따라 다를 수 있어요.',
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final thrown = error;
    // Failure 가 아닌 예외까지 그대로 노출하지 않고 공통 문구로 바꾼다.
    final failure = thrown is Failure ? thrown : const UnknownFailure();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Text(
              failure.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}

/// 설정·수령일 변경에서 값을 바꾸고 돌아오면 홈이 옛 값을 들고 있으므로 다시 읽는다.
Future<void> _openAndRefresh(
  BuildContext context,
  WidgetRef ref,
  String location,
) async {
  await context.push<void>(location);
  if (!context.mounted) {
    return;
  }
  ref.invalidate(homeViewModelProvider);
}

Future<void> _markReceivedToday(BuildContext context, WidgetRef ref) async {
  try {
    await ref.read(homeViewModelProvider.notifier).markReceivedToday();
  } on Failure catch (failure) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(failure.message)));
  }
}
