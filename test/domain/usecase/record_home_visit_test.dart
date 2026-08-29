import 'package:crying_time/domain/failure/failure.dart';
import 'package:crying_time/domain/repository/home_visit_repository.dart';
import 'package:crying_time/domain/result/result.dart';
import 'package:crying_time/domain/usecase/record_home_visit.dart';
import 'package:crying_time/domain/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockHomeVisitRepository extends Mock implements HomeVisitRepository {}

/// "5번째 방문마다 전면광고" 의 경계와, 못 띄웠을 때 다음 방문으로 넘어가는 규칙.
///
/// `==` 로 짜면 5번째에 광고가 안 떴을 때 6번째부터는 영영 안 뜬다.
void main() {
  late _MockHomeVisitRepository repository;
  late RecordHomeVisit useCase;

  setUp(() {
    repository = _MockHomeVisitRepository();
    useCase = RecordHomeVisit(repository);
  });

  test('5번째 미만 방문은 광고 차례가 아니다', () async {
    when(() => repository.increment()).thenAnswer((_) async => const Ok(4));

    expect(await useCase(const NoParams()), const Ok(false));
  });

  test('5번째 방문은 광고 차례다', () async {
    when(() => repository.increment()).thenAnswer((_) async => const Ok(5));

    expect(await useCase(const NoParams()), const Ok(true));
  });

  test('5번째에 광고가 안 떠서 횟수가 안 돌아갔으면 6번째도 광고 차례다', () async {
    when(() => repository.increment()).thenAnswer((_) async => const Ok(6));

    expect(await useCase(const NoParams()), const Ok(true));
  });

  test('저장이 실패하면 실패를 그대로 돌려준다', () async {
    when(() => repository.increment())
        .thenAnswer((_) async => const Err(UnknownFailure()));

    expect(await useCase(const NoParams()), const Err<bool>(UnknownFailure()));
  });
}
