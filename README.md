# crying_time

Flutter 3.47.1 / Dart 3.13.1 기반 클린 아키텍처 프로젝트.

## 스택

| 역할 | 패키지 |
| --- | --- |
| 상태관리 (viewmodel) | flutter_riverpod + riverpod_generator |
| 의존성 조립 (domain/data) | get_it |
| 라우팅 | go_router |
| 네트워크 | dio |
| 모델/코드 생성 | freezed, json_serializable |
| 테스트 | flutter_test, mocktail |

## 구조

```
lib/
├─ main.dart
├─ app/                            앱 전역 설정
│  ├─ app.dart                     MaterialApp.router
│  ├─ di/service_locator.dart      getIt 인스턴스 (프로젝트 내부 import 없음)
│  ├─ di/injector.dart             GetIt 등록 (모든 계층 조립)
│  ├─ provider_retry.dart          provider 자동 재시도 정책
│  └─ theme/app_theme.dart
├─ data/
│  ├─ network/                     Dio 생성, DioException → Failure 변환
│  ├─ datasource/                  HTTP 호출 + 역직렬화
│  ├─ dto/                         API 응답 DTO (+ toEntity)
│  └─ repository/                  domain 인터페이스 구현
├─ domain/
│  ├─ entity/                      순수 도메인 모델
│  ├─ failure/failure.dart         sealed 실패 타입
│  ├─ result/result.dart           Result<T> = Ok<T> | Err<T>
│  ├─ repository/                  인터페이스만
│  └─ usecase/                     UseCase<Out, In> + 개별 유즈케이스
└─ feature/                        화면. ui 와 viewmodel 만 존재한다
   ├─ common/failure_message.dart  Failure 타입 → 사용자 문구
   ├─ router/                      routes.dart(경로 상수), app_router.dart
   ├─ home/
   │  ├─ ui/home_screen.dart
   │  └─ viewmodel/home_view_model.dart
   └─ post/
      ├─ ui/post_screen.dart, post_error_view.dart
      └─ viewmodel/post_view_model.dart
```

### 규칙

```
feature ──▶ domain ◀── data
   └──▶ app/di/service_locator.dart (getIt 인스턴스만)
```

- `domain` 은 어떤 패키지에도 의존하지 않는다 (freezed 어노테이션 제외).
- `data` 는 `domain` 의 인터페이스를 구현한다 (의존성 역전).
- `feature` 는 `domain` 과 `app/di/service_locator.dart` 만 안다. `data` 를 전이적으로도
  import 하지 않는다 — 그래서 등록 코드(`injector.dart`)와 인스턴스 선언을 파일로 나눴다.
- 예외는 `data` 경계에서 전부 `Failure` 로 변환된다. 그 위로 raw 예외가 올라가지 않는다.
- 사용자에게 보여줄 문구는 `domain` 에 두지 않는다. `Failure` 는 실패 "타입"만 담고,
  문구는 `feature/common/failure_message.dart` 가 만든다.
- `feature` 안에는 화면(ui)과 상태(viewmodel)만 둔다. 비즈니스 로직은 `domain/usecase` 로 내린다.
- lib 안에서는 `package:crying_time/...` 절대 import 를 쓴다.

### GetIt 과 Riverpod 의 역할 분담

- **GetIt**: DataSource → Repository → UseCase 객체 그래프를 조립한다. Flutter/Riverpod 에 의존하지 않는다.
- **Riverpod**: 화면 상태(viewmodel)를 관리한다. viewmodel 은 필요한 유즈케이스를 GetIt 에서 직접 꺼낸다.

```dart
// feature/post/viewmodel/post_view_model.dart
@riverpod
class PostViewModel extends _$PostViewModel {
  @override
  Future<Post> build(int postId) async {
    final getPost = getIt<GetPost>();
    ...
  }
}
```

테스트에서는 GetIt 에 mock 을 등록해 화면을 격리한다.

```dart
setUp(() => getIt.registerSingleton<GetPost>(MockGetPost()));
tearDown(() => getIt.reset());
```

## 새 기능 추가 순서

1. `domain/entity`, `domain/repository`(인터페이스), `domain/usecase` 작성
2. `data/dto`, `data/datasource`, `data/repository`(구현) 작성
3. `app/di/injector.dart` 에 등록
4. `feature/<name>/viewmodel` 작성 → `feature/<name>/ui` 작성
5. `feature/router/routes.dart` 와 `app_router.dart` 에 경로 추가

## 최초 설정

Firebase / FCM 설정 파일(`firebase_options.dart`, `google-services.json`,
`GoogleService-Info.plist`)은 저장소에 포함하지 않는다. 클론한 뒤 자신의 Firebase
프로젝트로 직접 생성한다.

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

## 명령어

```bash
flutter pub get
dart run build_runner build          # 코드 생성 (freezed / json / riverpod)
dart run build_runner watch          # 개발 중 자동 생성
flutter analyze
flutter test
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

`post` 기능은 계층 배선을 보여주는 예제다. 실제 기능을 만들 때 통째로 지우고 시작해도 된다.
