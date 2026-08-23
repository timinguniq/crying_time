import 'package:crying_time/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// 화면 하단에 놓이는 가로 꽉 찬 주요 버튼('시작하기', '저장').
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;

  /// null 이면 비활성 상태로 흐리게 그린다.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(14);

    return Opacity(
      opacity: onPressed == null ? 0.4 : 1,
      child: Material(
        color: AppColors.primary,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
