import 'package:crying_time/app/theme/app_colors.dart';
import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/feature/common/failure_message.dart';
import 'package:crying_time/feature/common/korean_date.dart';
import 'package:crying_time/feature/common/widget/app_primary_button.dart';
import 'package:crying_time/feature/common/widget/app_screen_header.dart';
import 'package:crying_time/feature/common/widget/app_stepper_button.dart';
import 'package:crying_time/feature/pickup_edit/viewmodel/pickup_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PickupEditScreen extends ConsumerWidget {
  const PickupEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(pickupEditViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 헤더는 로딩·에러일 때도 남겨 둔다. 뒤로 가기를 막지 않기 위해서다.
              AppScreenHeader(title: '수령일 변경', onBack: () => context.pop()),
              Expanded(
                child: switch (asyncState) {
                  AsyncData(:final value) => _PickupEditBody(state: value),
                  AsyncError(:final error) => _ErrorView(
                    failure: error is Failure ? error : const UnknownFailure(),
                    onRetry: () => ref.invalidate(pickupEditViewModelProvider),
                  ),
                  _ => const Center(child: CircularProgressIndicator()),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickupEditBody extends ConsumerWidget {
  const _PickupEditBody({required this.state});

  final PickupEditState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const Text(
          '마지막으로 인공눈물을 받은 날과 수령량을 입력하면\n다음 수령 가능일을 다시 계산해요',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 28),
        _DateField(
          date: state.pickupDate,
          onTap: () => _pickDate(context, ref),
        ),
        const SizedBox(height: 20),
        _BoxesField(
          boxes: state.boxes,
          onChanged: (delta) =>
              ref.read(pickupEditViewModelProvider.notifier).changeBoxes(delta),
        ),
        const SizedBox(height: 20),
        const Text(
          '하루 사용량은 보험 급여 최대치인 6개로 계산해요',
          style: TextStyle(
            fontSize: 12.5,
            height: 1.5,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 20),
        _PreviewBox(nextPickupDate: state.preview.nextPickupDate),
        const Spacer(),
        AppPrimaryButton(
          label: '저장',
          onPressed: state.isSaving ? null : () => _save(context, ref),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // 아직 오지 않은 날을 수령일로 두면 주기 계산이 성립하지 않으므로 오늘까지만
    // 고를 수 있게 한다. 1년보다 오래된 기록은 다시 처방받았을 값이라 뺀다.
    final firstDate = DateTime(today.year - 1, today.month, today.day);

    final DateTime initialDate;
    if (state.pickupDate.isBefore(firstDate)) {
      initialDate = firstDate;
    } else if (state.pickupDate.isAfter(today)) {
      initialDate = today;
    } else {
      initialDate = state.pickupDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: today,
    );
    if (picked == null) {
      return;
    }
    ref.read(pickupEditViewModelProvider.notifier).changeDate(picked);
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final message = await ref.read(pickupEditViewModelProvider.notifier).save();
    if (!context.mounted) {
      return;
    }
    if (message == null) {
      context.pop();
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

/// 탭하면 날짜 선택기를 여는 필드.
class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '수령일',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.inputBorder),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              date.dotted,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BoxesField extends StatelessWidget {
  const _BoxesField({required this.boxes, required this.onChanged});

  final int boxes;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '수령량',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$boxes박스 · ${boxes * PickupInfo.dosesPerBox}개',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          AppStepperButton(
            isIncrement: false,
            size: 36,
            onPressed: boxes > PickupInfo.minBoxes ? () => onChanged(-1) : null,
          ),
          const SizedBox(width: 10),
          AppStepperButton(
            isIncrement: true,
            size: 36,
            onPressed: boxes < PickupInfo.maxBoxes ? () => onChanged(1) : null,
          ),
        ],
      ),
    );
  }
}

class _PreviewBox extends StatelessWidget {
  const _PreviewBox({required this.nextPickupDate});

  final DateTime nextPickupDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          const Text(
            '다음 수령 가능일',
            style: TextStyle(fontSize: 13, color: AppColors.textBody),
          ),
          Text(
            nextPickupDate.monthDayWeekday,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            failure.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
