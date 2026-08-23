import 'package:crying_time/domain/entity/push_schedule.dart';
import 'package:crying_time/domain/result/result.dart';

abstract interface class PushScheduleRepository {
  /// 저장된 설정을 읽는다. 저장된 값이 없으면 [PushSchedule.initial] 을 준다.
  Future<Result<PushSchedule>> load();

  /// 설정을 저장하고 서버의 푸시 예약을 갱신한다.
  ///
  /// 서버는 다음 수령 가능일을 알아야 오프셋을 실제 발송 시각으로 바꿀 수 있으므로
  /// [nextPickupDate] 를 함께 보낸다.
  Future<Result<PushSchedule>> save({
    required PushSchedule schedule,
    required DateTime nextPickupDate,
  });

  /// 푸시 수신 여부만 켜고 끈다.
  ///
  /// 서버에 이미 걸려 있는 알림 시점은 건드리지 않으므로 기준일을 보낼 필요가
  /// 없고, 다시 켰을 때 사용자가 시점을 새로 고르지 않아도 된다.
  Future<Result<PushSchedule>> setEnabled(PushSchedule schedule);
}
