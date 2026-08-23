import 'package:crying_time/domain/entity/pickup_info.dart';
import 'package:crying_time/domain/result/result.dart';

abstract interface class PickupRepository {
  /// 저장된 수령 기록. 아직 온보딩을 마치지 않았으면 null.
  Future<Result<PickupInfo?>> load();

  Future<Result<PickupInfo>> save(PickupInfo info);
}
