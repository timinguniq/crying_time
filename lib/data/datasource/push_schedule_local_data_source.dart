import 'package:shared_preferences/shared_preferences.dart';

typedef PushScheduleRecord = ({
  bool enabled,
  bool notifyD7,
  bool notifyD3,
  bool notifyDDay,
  bool customEnabled,
  int customDays,
});

/// 서버에 보낸 알림 설정을 기기에도 남겨, 다음 실행 때 바로 화면에 그린다.
abstract interface class PushScheduleLocalDataSource {
  /// 저장된 적이 없으면 null.
  Future<PushScheduleRecord?> read();

  Future<void> write(PushScheduleRecord record);
}

class PushScheduleLocalDataSourceImpl implements PushScheduleLocalDataSource {
  const PushScheduleLocalDataSourceImpl(this._preferences);

  static const String _enabledKey = 'push.enabled';
  static const String _d7Key = 'push.d7';
  static const String _d3Key = 'push.d3';
  static const String _ddayKey = 'push.dday';
  static const String _customEnabledKey = 'push.custom.enabled';
  static const String _customDaysKey = 'push.custom.days';

  final SharedPreferencesAsync _preferences;

  @override
  Future<PushScheduleRecord?> read() async {
    final enabled = await _preferences.getBool(_enabledKey);
    if (enabled == null) {
      return null;
    }

    return (
      enabled: enabled,
      notifyD7: await _preferences.getBool(_d7Key) ?? false,
      notifyD3: await _preferences.getBool(_d3Key) ?? false,
      notifyDDay: await _preferences.getBool(_ddayKey) ?? false,
      customEnabled: await _preferences.getBool(_customEnabledKey) ?? false,
      customDays: await _preferences.getInt(_customDaysKey) ?? 14,
    );
  }

  @override
  Future<void> write(PushScheduleRecord record) async {
    await _preferences.setBool(_enabledKey, record.enabled);
    await _preferences.setBool(_d7Key, record.notifyD7);
    await _preferences.setBool(_d3Key, record.notifyD3);
    await _preferences.setBool(_ddayKey, record.notifyDDay);
    await _preferences.setBool(_customEnabledKey, record.customEnabled);
    await _preferences.setInt(_customDaysKey, record.customDays);
  }
}
