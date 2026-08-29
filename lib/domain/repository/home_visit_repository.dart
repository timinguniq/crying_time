import 'package:crying_time/domain/result/result.dart';

abstract interface class HomeVisitRepository {
  /// 방문 횟수를 1 올리고, 올린 뒤의 값을 돌려준다.
  Future<Result<int>> increment();

  Future<Result<void>> reset();
}
