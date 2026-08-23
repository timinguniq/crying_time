import 'package:crying_time/data/datasource/pickup_local_data_source.dart';
import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/repository/pickup_repository.dart';
import 'package:crying_time/domain/result/result.dart';

class PickupRepositoryImpl implements PickupRepository {
  const PickupRepositoryImpl(this._localDataSource);

  final PickupLocalDataSource _localDataSource;

  @override
  Future<Result<PickupInfo?>> load() async {
    try {
      final record = await _localDataSource.read();
      if (record == null) {
        return const Ok(null);
      }
      return Ok(
        PickupInfo(pickupDate: record.pickupDate, boxes: record.boxes),
      );
    } catch (e) {
      return Err(UnknownFailure(detail: '$e'));
    }
  }

  @override
  Future<Result<PickupInfo>> save(PickupInfo info) async {
    try {
      await _localDataSource.write(
        (pickupDate: info.pickupDate, boxes: info.boxes),
      );
      return Ok(info);
    } catch (e) {
      return Err(UnknownFailure(detail: '$e'));
    }
  }
}
