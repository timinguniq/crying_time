# 눈물타임

인공눈물 재처방 주기를 계산해, 다시 받을 수 있는 날을 푸시로 알려주는 앱.

Flutter 3.47.1 / Dart 3.13.1 기반 클린 아키텍처.

## 스택

| 역할 | 패키지 |
| --- | --- |
| 상태관리 (viewmodel) | flutter_riverpod + riverpod_generator |
| 의존성 조립 (domain/data) | get_it |
| 라우팅 | go_router |
| 네트워크 | dio |
| 푸시 | firebase_core + firebase_messaging |
| 로컬 저장 | shared_preferences |
| 모델/코드 생성 | freezed, json_serializable |
| 테스트 | flutter_test, mocktail |

## 도메인 규칙

건강보험 급여는 인공눈물을 하루 6개까지 인정한다. 그래서 받은 양이 곧 다음 수령까지의 일수가 된다.

```
1박스 = 60개
재처방 주기(일) = 박스 수 × 60 ÷ 6 = 박스 수 × 10
다음 수령 가능일 = 마지막 수령일 + 재처방 주기
```

기본값인 5박스(300개)면 50일이다. 이 계산은 `domain/entity/pickup_info.dart` 안에만 있다.

## 구조

```
lib/
├─ main.dart                       Firebase 초기화 → DI → runApp
├─ app/
│  ├─ app.dart                     MaterialApp.router
│  ├─ di/service_locator.dart      getIt 인스턴스 (프로젝트 내부 import 없음)
│  ├─ di/injector.dart             GetIt 등록 (모든 계층 조립 + 목/실서버 분기)
│  ├─ provider_retry.dart          provider 자동 재시도 정책
│  └─ theme/app_colors.dart        디자인 색 토큰
│     theme/app_theme.dart
├─ data/
│  ├─ network/                     Dio 생성, DioException → Failure 변환, ApiConfig
│  ├─ datasource/
│  │  ├─ device_remote_data_source.dart   기기 등록 · 푸시 시점 갱신 (+ 목 구현)
│  │  ├─ device_id_source.dart            기기 식별자 발급/보관
│  │  ├─ device_environment.dart          플랫폼 · UTC 오프셋
│  │  ├─ messaging_source.dart            FCM 토큰 발급/갱신 (+ 목 구현)
│  │  ├─ pickup_local_data_source.dart
│  │  └─ push_schedule_local_data_source.dart
│  ├─ dto/                         요청 본문 DTO
│  └─ repository/                  domain 인터페이스 구현
├─ domain/
│  ├─ entity/                      pickup_info, push_schedule, device_registration
│  ├─ failure/failure.dart         sealed 실패 타입
│  ├─ result/result.dart           Result<T> = Ok<T> | Err<T>
│  ├─ repository/                  인터페이스만
│  └─ usecase/                     UseCase<Out, In> + 개별 유즈케이스
└─ feature/                        화면. ui 와 viewmodel 만 존재한다
   ├─ common/                      failure_message, korean_date, push_offset_label, widget/
   ├─ router/                      routes.dart(경로 상수), app_router.dart
   ├─ splash/                      저장된 수령 기록을 보고 온보딩/홈으로 분기
   ├─ onboarding/
   ├─ home/                        링 프로그레스 · D-day · 수령 완료
   ├─ settings/                    푸시 알림 시점 · 수령 정보
   └─ pickup_edit/                 수령일 · 수령량 변경
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
- `feature` 안에는 화면(ui)과 상태(viewmodel)만 둔다. 비즈니스 로직은 `domain` 으로 내린다.
- 화면에 색 리터럴을 두지 않는다. `app/theme/app_colors.dart` 의 토큰만 쓴다.
- lib 안에서는 `package:crying_time/...` 절대 import 를 쓴다.

### GetIt 과 Riverpod 의 역할 분담

- **GetIt**: DataSource → Repository → UseCase 객체 그래프를 조립한다. Flutter/Riverpod 에 의존하지 않는다.
- **Riverpod**: 화면 상태(viewmodel)를 관리한다. viewmodel 은 필요한 유즈케이스를 GetIt 에서 직접 꺼낸다.

테스트에서는 GetIt 에 mock 을 등록해 화면을 격리한다.

```dart
setUp(() => getIt.registerSingleton<UpdatePushSchedule>(MockUpdatePushSchedule()));
tearDown(() => getIt.reset());
```

## 서버 연동

서버는 아직 없다. 아래 계약을 전제로 클라이언트만 먼저 만들었고, 기본 실행은 목 모드다.
전체 명세는 [`docs/api.md`](docs/api.md) 에 있다.

### 기기 등록

앱이 뜰 때(스플래시) 한 번 호출한다. FCM 이 토큰을 갱신하면 자동으로 다시 호출된다.

```
POST /v1/devices
{
  "deviceId": "9f1c...-...",     // 최초 실행 때 만들어 기기에 영구 저장하는 UUID v4
  "fcmToken": "...",
  "platform": "android",          // 또는 "ios"
  "utcOffsetMinutes": 540
}
```

`deviceId` 를 기기에서 생성하는 이유: Android 는 더 이상 안정적인 하드웨어 식별자를 주지 않고,
iOS 의 `identifierForVendor` 도 앱을 지우면 바뀐다. 서버 입장에서는 어차피 이 값이 유일한 키다.

### 푸시 켜기 / 끄기

설정 화면의 푸시 알림 스위치. 수신 여부만 바꾸고 서버에 걸린 알림 시점은 건드리지 않는다.
그래야 다시 켰을 때 사용자가 시점을 새로 고르지 않아도 된다.

```
PUT /v1/devices/{deviceId}/push-enabled
{ "enabled": false }
```

`false` 면 발송만 멈추고 예약은 남긴다. 예약 자체를 지우는 것은 아래 `push-schedule` 의
`enabled: false` 와 다르다.

### 푸시 시점 변경

설정 화면에서 알림 시점이 바뀔 때마다, 그리고 수령일/수령량이 바뀌어 다음 수령 가능일이
이동할 때마다 호출한다. 부분 갱신이 아니라 항상 현재 설정 전체를 보낸다.

```
PUT /v1/devices/{deviceId}/push-schedule
{
  "enabled": true,
  "offsetDays": [14, 7, 3, 0],    // 수령 가능일 며칠 전에 보낼지. 당일은 0. 내림차순 유니크
  "nextPickupDate": "2026-09-08",
  "utcOffsetMinutes": 540
}
```

서버는 `nextPickupDate - offsetDays[i]` 날짜에 푸시를 보낸다. 시각은 서버 정책으로 정하고,
기기 지역시간에 맞추는 데 `utcOffsetMinutes` 를 쓴다.

`enabled: false` 면 예약을 전부 취소한다. `offsetDays` 가 빈 배열이어도 마찬가지다.

### 실패 처리

로컬 저장을 먼저 끝내고 서버에 보낸다. 통신이 실패해도 화면에 찍힌 값과 기기에 남은 값은
어긋나지 않고, 사용자는 실패 문구를 본다.

한 번 실패한 요청이 그대로 굳어버리지 않도록, 앱을 켤 때마다 `SyncPushSchedule` 이 기기에 저장된
설정 전체를 다시 밀어 넣는다. 기기 등록(`POST /v1/devices`)이 끝난 뒤에 실행된다 — 서버에 기기가
없으면 예약을 걸 수 없기 때문이다.

### 지키는 불변식

- `offsetDays` 의 모든 값은 재처방 주기보다 작다. 수령량을 줄여 주기가 짧아지면 직접 지정 값이
  주기 안으로 당겨진다(`PushSchedule.clampedTo`). 그러지 않으면 서버가 마지막 수령일보다 앞선
  날짜로 예약하게 된다.
- 설정 화면에서 나가는 요청은 한 줄로 직렬화된다. 연타해도 늦게 도착한 옛 요청이 서버의 최신
  상태를 덮어쓰지 않는다.

## 최초 설정

Firebase / FCM 설정 파일(`firebase_options.dart`, `google-services.json`,
`GoogleService-Info.plist`)은 저장소에 포함하지 않는다. 클론한 뒤 자신의 Firebase
프로젝트로 직접 생성한다.

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

설정 파일이 없어도 목 모드(기본값)로는 앱이 뜬다. `main` 이 목 모드에서 `Firebase.initializeApp()`
을 건너뛰고, FCM 토큰과 API 호출을 목 구현으로 대체한다.

## 명령어

```bash
flutter pub get
dart run build_runner build          # 코드 생성 (freezed / json / riverpod)
dart run build_runner watch          # 개발 중 자동 생성
flutter analyze
flutter test

# 목 모드 (기본) — 서버·Firebase 설정 없이 실행. 요청 본문은 로그로 확인한다
flutter run

# 실서버 연동
flutter run \
  --dart-define=USE_MOCK_API=false \
  --dart-define=API_BASE_URL=https://api.example.com
```
