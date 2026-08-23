import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/repository/push_schedule_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/usecase.dart';

/// 설정 화면에서 알림 시점이 바뀔 때마다 호출한다. 저장과 서버 반영이 한 동작이다.
class UpdatePushSchedule
    implements UseCase<PushSchedule, UpdatePushScheduleParams> {
  const UpdatePushSchedule(this._repository);

  final PushScheduleRepository _repository;

  @override
  Future<Result<PushSchedule>> call(UpdatePushScheduleParams params) =>
      _repository.save(
        schedule: params.schedule,
        nextPickupDate: params.nextPickupDate,
      );
}

final class UpdatePushScheduleParams {
  const UpdatePushScheduleParams({
    required this.schedule,
    required this.nextPickupDate,
  });

  final PushSchedule schedule;
  final DateTime nextPickupDate;
}
