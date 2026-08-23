import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/repository/push_schedule_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/usecase.dart';

/// 설정 화면의 푸시 알림 스위치. 켜고 끄는 것만 서버에 알린다.
class SetPushEnabled implements UseCase<PushSchedule, SetPushEnabledParams> {
  const SetPushEnabled(this._repository);

  final PushScheduleRepository _repository;

  @override
  Future<Result<PushSchedule>> call(SetPushEnabledParams params) =>
      _repository.setEnabled(params.schedule);
}

final class SetPushEnabledParams {
  const SetPushEnabledParams({required this.schedule});

  /// 스위치를 반영한 뒤의 설정 전체. 기기에는 이 값이 그대로 저장된다.
  final PushSchedule schedule;
}
