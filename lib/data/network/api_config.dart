/// 빌드 시점에 주입되는 네트워크 설정.
///
/// `flutter run --dart-define=API_BASE_URL=https://...` 로 환경별 값을 바꾼다.
abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://crying-time-api.devjj.co.kr',
  );

  /// 서버가 아직 없으므로 기본값은 목(mock)이다. 실제 서버가 뜨면
  /// `--dart-define=USE_MOCK_API=false` 로 끄면 되고, 코드는 그대로 둔다.
  ///
  /// 목 모드에서는 Firebase 초기화도 건너뛰므로 설정 파일 없이 앱이 뜬다.
  static const bool useMockApi = bool.fromEnvironment(
    'USE_MOCK_API',
    defaultValue: true,
  );

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
