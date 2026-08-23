import 'package:crying_time/domain/failure/failure.dart';

/// Repository / UseCase 의 반환 타입.
///
/// 성공과 실패를 타입으로 강제해, 호출부가 `switch` 로 두 갈래를 모두
/// 처리하지 않으면 컴파일되지 않게 한다.
sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => switch (this) {
    Ok<T>(:final value) => onSuccess(value),
    Err<T>(:final failure) => onFailure(failure),
  };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Ok<T> && other.value == value);

  @override
  int get hashCode => Object.hash(Ok<T>, value);

  @override
  String toString() => 'Ok<$T>($value)';
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Err<T> && other.failure == failure);

  @override
  int get hashCode => Object.hash(Err<T>, failure);

  @override
  String toString() => 'Err<$T>($failure)';
}
