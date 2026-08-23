/// 실패한 provider 의 자동 재시도 정책. `null` 을 반환하면 재시도하지 않는다.
///
/// Riverpod 3 의 기본값은 최대 10회 지수 백오프(총 40초 남짓)라서, 404 처럼
/// 재시도해도 결과가 같은 실패까지 오래 로딩 상태로 남는다. 이 앱은 실패를 바로
/// 화면에 보여주고 사용자가 직접 재시도하게 하므로 자동 재시도를 끈다.
///
/// 일시적 오류만 재시도하려면 error 타입(NetworkFailure 등)으로 분기해
/// Duration 을 반환하도록 바꾼다.
Duration? noProviderRetry(int retryCount, Object error) => null;
