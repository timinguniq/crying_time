/// 경로 문자열을 한 곳에서만 관리한다.
abstract final class Routes {
  /// 스플래시. 저장된 수령 기록 유무를 보고 온보딩이나 홈으로 보낸다.
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String pickupEdit = '/pickup-edit';
}
