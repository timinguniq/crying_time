import 'package:shared_preferences/shared_preferences.dart';

/// 홈 방문 횟수는 기기 안에만 둔다. 전면광고 주기를 세는 데 쓴다.
abstract interface class HomeVisitLocalDataSource {
  /// 기록이 없으면 0.
  Future<int> readCount();

  Future<void> writeCount(int count);
}

class HomeVisitLocalDataSourceImpl implements HomeVisitLocalDataSource {
  const HomeVisitLocalDataSourceImpl(this._preferences);

  static const String _countKey = 'home.visitCount';

  final SharedPreferencesAsync _preferences;

  @override
  Future<int> readCount() async => await _preferences.getInt(_countKey) ?? 0;

  @override
  Future<void> writeCount(int count) => _preferences.setInt(_countKey, count);
}
