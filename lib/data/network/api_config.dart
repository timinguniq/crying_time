/// 빌드 시점에 주입되는 네트워크 설정.
///
/// `flutter run --dart-define=API_BASE_URL=https://...` 로 환경별 값을 바꾼다.
abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://crying-time-api.devjj.co.kr',
  );

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
