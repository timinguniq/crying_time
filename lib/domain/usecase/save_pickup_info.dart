import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/repository/pickup_repository.dart';
import 'package:crying_time/domain/repository/push_schedule_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/usecase.dart';

/// 수령 기록을 저장한다.
///
/// 수령일·수령량이 바뀌면 다음 수령 가능일이 바뀌고, 서버가 잡아둔 발송 시각도
/// 같이 어긋난다. 그래서 저장 직후 현재 알림 설정을 그대로 다시 밀어 넣어
/// 서버의 예약을 새 기준일로 맞춘다.
class SavePickupInfo implements UseCase<PickupInfo, SavePickupInfoParams> {
  const SavePickupInfo(this._pickupRepository, this._pushScheduleRepository);

  final PickupRepository _pickupRepository;
  final PushScheduleRepository _pushScheduleRepository;

  @override
  Future<Result<PickupInfo>> call(SavePickupInfoParams params) async {
    final info = PickupInfo(
      pickupDate: params.pickupDate,
      boxes: params.boxes,
    );

    final saved = await _pickupRepository.save(info);
    if (saved case Err(:final failure)) {
      return Err(failure);
    }

    final schedule = await _pushScheduleRepository.load();
    if (schedule case Ok(value: final PushSchedule value)) {
      final synced = await _pushScheduleRepository.save(
        // 수령량이 줄면 주기도 줄어, 직접 지정 오프셋이 주기를 넘길 수 있다.
        schedule: value.clampedTo(info.cycleDays),
        nextPickupDate: info.nextPickupDate,
      );
      // 기기에는 이미 저장됐지만 서버 예약은 옛 기준일에 머물러 있다. 알림이
      // 엉뚱한 날 오는 상태라, 성공으로 삼키지 않고 위로 올려 사용자에게 알린다.
      if (synced case Err(:final failure)) {
        return Err(failure);
      }
    }

    return saved;
  }
}

final class SavePickupInfoParams {
  const SavePickupInfoParams({required this.pickupDate, required this.boxes});

  final DateTime pickupDate;
  final int boxes;
}
