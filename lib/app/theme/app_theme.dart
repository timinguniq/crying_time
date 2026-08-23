import 'package:crying_time/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// 디자인이 라이트 팔레트 하나만 정의하므로 다크 테마는 두지 않는다.
abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.success,
      onSecondary: AppColors.onPrimary,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: InkSparkle.splashFactory,
      textTheme: const TextTheme(
        // 화면 헤더('눈물타임', '설정', '수령일 변경').
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
          color: AppColors.textPrimary,
        ),
        // 카드 제목.
        titleSmall: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(fontSize: 13.5, color: AppColors.textBody),
        bodySmall: TextStyle(fontSize: 12, color: AppColors.textMuted),
      ),
    );
  }
}
