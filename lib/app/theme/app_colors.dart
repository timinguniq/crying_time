import 'package:flutter/material.dart';

/// 디자인('눈물타임')이 정한 색 토큰. 화면에서는 리터럴 색을 쓰지 않고 여기만 참조한다.
abstract final class AppColors {
  /// 포인트 컬러. 링 프로그레스 · 주요 버튼 · 활성 칩.
  static const Color primary = Color(0xFF3B6FD4);
  static const Color primaryPressed = Color(0xFF2D5AB0);

  /// 포인트 컬러의 옅은 배경. 보조 버튼 · 알림 요약 박스.
  static const Color primarySoft = Color(0xFFEDF3FD);

  /// 수령 가능 상태(D-DAY).
  static const Color success = Color(0xFF1E8A5A);
  static const Color successSoft = Color(0xFFE6F4EC);

  static const Color background = Color(0xFFFDFDFC);
  static const Color surface = Color(0xFFFFFFFF);

  /// 카드 테두리.
  static const Color border = Color(0xFFE7ECF4);

  /// 입력 필드 · 스테퍼 버튼 테두리.
  static const Color inputBorder = Color(0xFFD8DFE9);

  /// 칩 버튼 테두리.
  static const Color chipBorder = Color(0xFFE0E6EF);

  /// 체크박스 비활성 테두리.
  static const Color checkBorder = Color(0xFFC9D2DE);

  /// 카드 안쪽 구분선.
  static const Color divider = Color(0xFFEDF0F5);

  /// 링 프로그레스의 남은 구간.
  static const Color track = Color(0xFFE7ECF4);

  /// 설정 화면 '직접 지정' 행의 배경.
  static const Color fieldBackground = Color(0xFFF7F9FC);

  /// 홈 하단 안내 박스 배경.
  static const Color infoBackground = Color(0xFFF4F7FC);

  /// 꺼진 토글의 트랙.
  static const Color toggleOff = Color(0xFFD5DBE4);

  /// 토글 손잡이 그림자.
  static const Color shadow = Color(0x33000000);

  static const Color textPrimary = Color(0xFF1A1D21);
  static const Color textBody = Color(0xFF3C4450);
  static const Color textSecondary = Color(0xFF5A6472);
  static const Color textMuted = Color(0xFF8A93A0);
  static const Color textFaint = Color(0xFFB0B8C4);
  static const Color onPrimary = Color(0xFFFFFFFF);
}
