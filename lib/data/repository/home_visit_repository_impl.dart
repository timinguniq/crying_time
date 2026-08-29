import 'package:crying_time/data/datasource/home_visit_local_data_source.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/repository/home_visit_repository.dart';
import 'package:crying_time/domain/result/result.dart';

class HomeVisitRepositoryImpl implements HomeVisitRepository {
  const HomeVisitRepositoryImpl(this._localDataSource);

  final HomeVisitLocalDataSource _localDataSource;

  @override
  Future<Result<int>> increment() async {
    try {
      final count = await _localDataSource.readCount() + 1;
      await _localDataSource.writeCount(count);
      return Ok(count);
    } catch (e) {
      return Err(UnknownFailure(detail: '$e'));
    }
  }

  @override
  Future<Result<void>> reset() async {
    try {
      await _localDataSource.writeCount(0);
      return const Ok(null);
    } catch (e) {
      return Err(UnknownFailure(detail: '$e'));
    }
  }
}
