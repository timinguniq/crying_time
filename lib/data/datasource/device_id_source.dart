import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

/// 기기 식별자를 발급하고 보관한다.
///
/// Android 는 더 이상 안정적인 하드웨어 식별자를 주지 않고, iOS 의
/// identifierForVendor 도 앱을 지우면 바뀐다. 그래서 최초 실행 때 UUID v4 를
/// 만들어 로컬에 영구 저장하고, 그 값을 계속 쓴다.
abstract interface class DeviceIdSource {
  Future<String> deviceId();
}

class DeviceIdSourceImpl implements DeviceIdSource {
  const DeviceIdSourceImpl(this._preferences);

  static const String _key = 'device.id';

  final SharedPreferencesAsync _preferences;

  @override
  Future<String> deviceId() async {
    final stored = await _preferences.getString(_key);
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }

    final generated = _generateUuidV4();
    await _preferences.setString(_key, generated);
    return generated;
  }

  static String _generateUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 1

    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();

    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
