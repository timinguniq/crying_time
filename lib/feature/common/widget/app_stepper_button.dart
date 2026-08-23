import 'package:crying_time/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// 수량을 1씩 올리고 내리는 원형 − / + 버튼.
class AppStepperButton extends StatelessWidget {
  const AppStepperButton({
    required this.isIncrement,
    required this.onPressed,
    this.size = 32,
    super.key,
  });

  final bool isIncrement;

  /// null 이면 범위 경계에 닿은 것이므로 흐리게 그린다.
  final VoidCallback? onPressed;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.4 : 1,
      child: Material(
        color: AppColors.surface,
        clipBehavior: Clip.antiAlias,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.inputBorder),
        ),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              // 빼기는 하이픈이 아니라 수학 기호(U+2212)를 써야 + 와 굵기가 맞는다.
              child: Text(
                isIncrement ? '+' : '−',
                style: TextStyle(
                  fontSize: size * 0.53,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBody,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
