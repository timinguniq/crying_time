import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/repository/pickup_repository.dart';
import 'package:crying_time/domain/repository/push_schedule_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/usecase.dart';

/// 기기에 저장된 알림 설정을 서버 예약과 다시 맞춘다.
///
/// 설정을 바꾸던 순간 통신이 끊겼다면 서버에는 옛 값만 남는다. 그대로 두면
/// 사용자가 설정을 또 건드리기 전까지 영영 어긋난 채로 있으므로, 앱을 켤 때마다
/// 현재 설정 전체를 한 번 밀어 넣어 스스로 복구되게 한다.
class SyncPushSchedule implements UseCase<PushSchedule, NoParams> {
  const SyncPushSchedule(this._pickupRepository, this._pushScheduleRepository);

  final PickupRepository _pickupRepository;
  final PushScheduleRepository _pushScheduleRepository;

  @override
  Future<Result<PushSchedule>> call(NoParams params) async {
    final scheduleResult = await _pushScheduleRepository.load();
    return switch (scheduleResult) {
      Err(:final failure) => Err(failure),
      Ok(:final value) => await _push(value),
    };
  }

  Future<Result<PushSchedule>> _push(PushSchedule schedule) async {
    final pickupResult = await _pickupRepository.load();
    if (pickupResult case Err(:final failure)) {
      return Err(failure);
    }
    if (pickupResult case Ok(value: final PickupInfo info)) {
      return _pushScheduleRepository.save(
        schedule: schedule,
        nextPickupDate: info.nextPickupDate,
      );
    }

    // 아직 수령 기록이 없으면 기준일이 없어 예약할 것도 없다.
    return Ok(schedule);
  }
}
