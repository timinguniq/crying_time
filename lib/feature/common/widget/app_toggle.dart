import 'package:crying_time/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// 푸시 알림 on/off 스위치.
///
/// Material Switch 는 플랫폼별 크기·색을 강제해 디자인(50x29)과 맞지 않아 직접 그린다.
class AppToggle extends StatelessWidget {
  const AppToggle({required this.value, required this.onChanged, super.key});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    const Duration duration = Duration(milliseconds: 200);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: SizedBox(
        width: 50,
        height: 29,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: AnimatedContainer(
                duration: duration,
                decoration: BoxDecoration(
                  color: value ? AppColors.primary : AppColors.toggleOff,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: duration,
              curve: Curves.easeInOut,
              top: 3,
              left: value ? 24 : 3,
              child: Container(
                width: 23,
                height: 23,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.shadow,
                      offset: Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
