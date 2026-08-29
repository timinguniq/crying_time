import 'package:crying_time/domain/repository/home_visit_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/usecase.dart';

/// 홈 방문을 하나 기록하고, 이번 방문에 전면광고를 띄울 차례인지 돌려준다.
///
/// [interstitialEvery]번째 방문부터 true 다. 그때 광고가 안 떠서
/// [MarkInterstitialShown] 이 불리지 않으면 다음 방문에도 계속 true 라,
/// 실제로 뜬 뒤에야 처음부터 다시 센다.
class RecordHomeVisit implements UseCase<bool, NoParams> {
  const RecordHomeVisit(this._repository);

  static const int interstitialEvery = 5;

  final HomeVisitRepository _repository;

  @override
  Future<Result<bool>> call(NoParams params) async {
    final result = await _repository.increment();
    return switch (result) {
      Ok(:final value) => Ok(value >= interstitialEvery),
      Err(:final failure) => Err(failure),
    };
  }
}
