import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/repository/push_schedule_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/usecase.dart';

class GetPushSchedule implements UseCase<PushSchedule, NoParams> {
  const GetPushSchedule(this._repository);

  final PushScheduleRepository _repository;

  @override
  Future<Result<PushSchedule>> call(NoParams params) => _repository.load();
}
