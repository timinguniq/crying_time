import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/repository/pickup_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/usecase.dart';

class GetPickupInfo implements UseCase<PickupInfo?, NoParams> {
  const GetPickupInfo(this._repository);

  final PickupRepository _repository;

  @override
  Future<Result<PickupInfo?>> call(NoParams params) => _repository.load();
}
