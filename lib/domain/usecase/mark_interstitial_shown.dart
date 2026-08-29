import 'package:crying_time/domain/repository/home_visit_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/usecase.dart';

/// 전면광고가 실제로 떴을 때 호출한다. 홈 방문 횟수를 0으로 되돌린다.
class MarkInterstitialShown implements UseCase<void, NoParams> {
  const MarkInterstitialShown(this._repository);

  final HomeVisitRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) => _repository.reset();
}
