import 'dart:io';

/// 서버 등록에 필요한 실행 환경 값. 테스트에서 갈아끼울 수 있게 인터페이스로 둔다.
abstract interface class DeviceEnvironment {
  String get platform;

  int get utcOffsetMinutes;
}

class DeviceEnvironmentImpl implements DeviceEnvironment {
  const DeviceEnvironmentImpl();

  @override
  // 이 앱이 올라가는 두 플랫폼에서 값이 'android' | 'ios' 라, 서버가 기대하는
  // 문자열과 그대로 같다.
  String get platform => Platform.operatingSystem;

  @override
  int get utcOffsetMinutes => DateTime.now().timeZoneOffset.inMinutes;
}
