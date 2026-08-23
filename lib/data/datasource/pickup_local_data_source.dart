import 'package:shared_preferences/shared_preferences.dart';

typedef PickupRecord = ({DateTime pickupDate, int boxes});

/// 수령 기록은 기기 안에만 둔다.
abstract interface class PickupLocalDataSource {
  /// 저장된 적이 없으면 null.
  Future<PickupRecord?> read();

  Future<void> write(PickupRecord record);
}

class PickupLocalDataSourceImpl implements PickupLocalDataSource {
  const PickupLocalDataSourceImpl(this._preferences);

  static const String _pickupDateKey = 'pickup.date';
  static const String _boxesKey = 'pickup.boxes';

  final SharedPreferencesAsync _preferences;

  @override
  Future<PickupRecord?> read() async {
    final epochDay = await _preferences.getInt(_pickupDateKey);
    final boxes = await _preferences.getInt(_boxesKey);
    if (epochDay == null || boxes == null) {
      return null;
    }
    return (pickupDate: _fromEpochDay(epochDay), boxes: boxes);
  }

  @override
  Future<void> write(PickupRecord record) async {
    await _preferences.setInt(_pickupDateKey, _toEpochDay(record.pickupDate));
    await _preferences.setInt(_boxesKey, record.boxes);
  }

  /// 시각·시간대에 흔들리지 않게 날짜만 일수로 저장한다.
  static int _toEpochDay(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;

  static DateTime _fromEpochDay(int epochDay) {
    final utc = DateTime.fromMillisecondsSinceEpoch(
      epochDay * Duration.millisecondsPerDay,
      isUtc: true,
    );
    return DateTime(utc.year, utc.month, utc.day);
  }
}
