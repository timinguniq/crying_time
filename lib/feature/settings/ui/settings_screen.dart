import 'package:crying_time/app/theme/app_colors.dart';
import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/feature/common/failure_message.dart';
import 'package:crying_time/feature/common/korean_date.dart';
import 'package:crying_time/feature/common/widget/app_check_box.dart';
import 'package:crying_time/feature/common/widget/app_choice_chip.dart';
import 'package:crying_time/feature/common/widget/app_screen_header.dart';
import 'package:crying_time/feature/common/widget/app_section_card.dart';
import 'package:crying_time/feature/common/widget/app_section_label.dart';
import 'package:crying_time/feature/common/widget/app_soft_button.dart';
import 'package:crying_time/feature/common/widget/app_stepper_button.dart';
import 'package:crying_time/feature/common/widget/app_toggle.dart';
import 'package:crying_time/feature/router/routes.dart';
import 'package:crying_time/feature/settings/viewmodel/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 헤더는 로딩·에러일 때도 남겨 둔다. 뒤로 가기를 막지 않기 위해서다.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppScreenHeader(title: '설정', onBack: () => context.pop()),
            ),
            Expanded(
              child: switch (state) {
                AsyncData(:final value) => _SettingsBody(state: value),
                AsyncError(:final error) => _RetryView(
                  message: (error is Failure ? error : const UnknownFailure())
                      .message,
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({required this.state});

  final SettingsState state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          const AppSectionLabel('알림'),
          _NotificationCard(state: state),
          const AppSectionLabel('수령 정보'),
          _PickupCard(state: state),
          const SizedBox(height: 8),
          const Text(
            '실제 급여 기준은 처방과 보험 정책에 따라\n달라질 수 있어요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              color: AppColors.textFaint,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard({required this.state});

  final SettingsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(settingsViewModelProvider.notifier);

    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          _SettingRow(
            title: '푸시 알림',
            description: '재처방 가능일을 기기로 알려드려요',
            trailing: AppToggle(
              value: state.schedule.enabled,
              onChanged: (_) => _showFailure(context, viewModel.togglePush()),
            ),
          ),
          // 푸시가 꺼져 있으면 시점을 골라도 아무 일도 일어나지 않으므로 감춘다.
          if (state.schedule.enabled)
            _TimingBlock(state: state, viewModel: viewModel),
        ],
      ),
    );
  }
}

class _TimingBlock extends StatelessWidget {
  const _TimingBlock({required this.state, required this.viewModel});

  final SettingsState state;
  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final schedule = state.schedule;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(color: AppColors.divider, height: 1),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              const Text(
                '알림 받을 시점',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBody,
                ),
              ),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: AppChoiceChip(
                      label: 'D-7',
                      selected: schedule.notifyD7,
                      onPressed: () =>
                          _showFailure(context, viewModel.toggleD7()),
                    ),
                  ),
                  Expanded(
                    child: AppChoiceChip(
                      label: 'D-3',
                      selected: schedule.notifyD3,
                      onPressed: () =>
                          _showFailure(context, viewModel.toggleD3()),
                    ),
                  ),
                  Expanded(
                    child: AppChoiceChip(
                      label: '당일',
                      selected: schedule.notifyDDay,
                      onPressed: () =>
                          _showFailure(context, viewModel.toggleDDay()),
                    ),
                  ),
                ],
              ),
              _CustomDaysRow(
                schedule: schedule,
                cycleDays: state.pickupInfo.cycleDays,
                viewModel: viewModel,
              ),
              _GuideBox(
                message: _guideMessage(
                  schedule,
                  state.pickupInfo.nextPickupDate,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CustomDaysRow extends StatelessWidget {
  const _CustomDaysRow({
    required this.schedule,
    required this.cycleDays,
    required this.viewModel,
  });

  final PushSchedule schedule;
  final int cycleDays;
  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    // 주기를 넘는 오프셋은 마지막 수령일보다 앞선 날에 발송된다. + 를 여기서 막는다.
    final maxCustomDays = PushSchedule.maxCustomDaysFor(cycleDays);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.fieldBackground,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              // 체크박스와 글자 사이 여백까지 눌리도록 opaque.
              behavior: HitTestBehavior.opaque,
              onTap: () => _showFailure(context, viewModel.toggleCustom()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 9,
                children: [
                  AppCheckBox(value: schedule.customEnabled),
                  const Text(
                    '직접 지정',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBody,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 9,
              children: [
                AppStepperButton(
                  isIncrement: false,
                  onPressed: schedule.customDays > PushSchedule.minCustomDays
                      ? () => _showFailure(
                          context,
                          viewModel.changeCustomDays(-1),
                        )
                      : null,
                ),
                ConstrainedBox(
                  // 자릿수가 바뀌어도 ± 버튼이 흔들리지 않게 폭을 잡아둔다.
                  constraints: const BoxConstraints(minWidth: 44),
                  child: Text(
                    'D-${schedule.customDays}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                AppStepperButton(
                  isIncrement: true,
                  onPressed: schedule.customDays < maxCustomDays
                      ? () =>
                            _showFailure(context, viewModel.changeCustomDays(1))
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideBox extends StatelessWidget {
  const _GuideBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 12.5,
            color: AppColors.textBody,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}

class _PickupCard extends ConsumerWidget {
  const _PickupCard({required this.state});

  final SettingsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(settingsViewModelProvider.notifier);
    final info = state.pickupInfo;

    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          _SettingRow(
            title: '마지막 수령일',
            description: info.pickupDate.monthDayWeekday,
            trailing: AppSoftButton(
              label: '변경',
              onPressed: () => _openPickupEdit(context, ref),
            ),
          ),
          _DividedRow(
            child: _SettingRow(
              title: '수령량',
              description: '${info.boxes}박스 · ${info.totalDoses}개',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 9,
                children: [
                  AppStepperButton(
                    isIncrement: false,
                    onPressed: info.boxes > PickupInfo.minBoxes
                        ? () => _showFailure(context, viewModel.changeBoxes(-1))
                        : null,
                  ),
                  AppStepperButton(
                    isIncrement: true,
                    onPressed: info.boxes < PickupInfo.maxBoxes
                        ? () => _showFailure(context, viewModel.changeBoxes(1))
                        : null,
                  ),
                ],
              ),
            ),
          ),
          _DividedRow(
            child: _SettingRow(
              title: '재처방 주기',
              description: '보험 급여 1일 6개 기준',
              trailing: Text(
                '${info.cycleDays}일',
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 카드 안에서 앞 행과 구분선으로 나뉘는 행.
class _DividedRow extends StatelessWidget {
  const _DividedRow({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(color: AppColors.divider, height: 1),
        Padding(padding: const EdgeInsets.only(top: 16), child: child),
      ],
    );
  }
}

/// '제목 + 설명 / 오른쪽 조작부'. 설정 카드의 네 행이 모두 같은 골격이다.
class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.title,
    required this.description,
    required this.trailing,
  });

  final String title;
  final String description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              Text(title, style: textTheme.titleSmall),
              Text(description, style: textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(width: 12),
        trailing,
      ],
    );
  }
}

class _RetryView extends ConsumerWidget {
  const _RetryView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text(message, textAlign: TextAlign.center),
            FilledButton(
              onPressed: () => ref.invalidate(settingsViewModelProvider),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 알림 시점 안내 문구.
///
/// 발송일 규칙은 PushSchedule 이 정하고, 화면은 받은 날짜를 한국어로 옮기기만
/// 한다. 이 문구는 푸시가 켜졌을 때만 그려지므로 꺼진 경우는 다루지 않는다.
String _guideMessage(PushSchedule schedule, DateTime nextPickupDate) {
  if (schedule.hasNoOffset) {
    return '선택된 알림 시점이 없어요';
  }

  final dates = schedule
      .notificationDatesFor(nextPickupDate)
      .map((date) => date.monthDayWeekday)
      .join(' · ');

  return '$dates에 알림';
}

/// 조작 결과가 실패 문구면 알린다.
///
/// 화면은 이미 낙관적으로 바뀌어 있으므로 성공했을 때는 아무것도 하지 않는다.
Future<void> _showFailure(BuildContext context, Future<String?> pending) async {
  final message = await pending;
  if (message == null || !context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

/// 수령일 변경 화면에서 돌아오면 값이 바뀌었을 수 있으므로 다시 읽는다.
Future<void> _openPickupEdit(BuildContext context, WidgetRef ref) async {
  await context.push<void>(Routes.pickupEdit);
  if (!context.mounted) {
    return;
  }

  ref.invalidate(settingsViewModelProvider);
}
