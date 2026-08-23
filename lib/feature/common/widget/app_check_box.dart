import 'package:crying_time/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// 보여주기 전용 체크박스. 탭 처리는 이 위젯을 감싸는 행이 맡는다.
class AppCheckBox extends StatelessWidget {
  const AppCheckBox({required this.value, super.key});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 19,
      height: 19,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: value ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: value ? AppColors.primary : AppColors.checkBorder,
        ),
      ),
      child: value
          ? const Text(
              '✓',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.onPrimary,
                height: 1,
              ),
            )
          : null,
    );
  }
}
