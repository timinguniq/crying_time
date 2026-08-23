import 'package:get_it/get_it.dart';

/// 앱 전역 서비스 로케이터 인스턴스.
///
/// 등록은 `injector.dart` 의 `configureDependencies()` 가 담당한다.
/// 이 파일은 프로젝트 내부를 하나도 import 하지 않으므로, viewmodel 이 여기를
/// 참조해도 feature 가 data 계층에 컴파일 의존하지 않는다.
final GetIt getIt = GetIt.instance;
