# iOS 푸시(APNs) 설정

iOS에서 FCM 푸시가 아직 동작하지 않는다. 세 군데를 손봐야 한다. 시뮬레이터로는 검증이 안 되니 실기기가 있을 때 한다.

## 현재 상태 (2026-08-29 기준)

| 항목 | 상태 |
| --- | --- |
| iOS 번들 ID | `com.devjj.platform.cryingtime` (패키지명 변경으로 새로 등록) |
| Firebase iOS 앱 ID | `1:502194359749:ios:dc91e00457979dd9cf8fac` |
| Firebase APNs 키 | 없음 |
| `ios/Runner/Runner.entitlements` | 없음 — Push Notifications capability 미설정 |
| Background Modes · Remote notifications | 미설정 |

Firebase 콘솔의 APNs 키 업로드는 API가 없다. 콘솔에서만 된다.

## 1. Apple Developer — APNs 키(.p8) 발급

이미 갖고 있는 .p8 이 있으면 재사용한다. APNs 키는 팀 단위라 앱마다 만들 필요 없다.

없으면:

1. https://developer.apple.com/account → Certificates, Identifiers & Profiles → Keys → +
2. 이름 입력, **Apple Push Notifications service (APNs)** 체크 → Continue → Register
3. **Download**. .p8 은 한 번만 받을 수 있다. 안전한 곳에 보관한다
4. **Key ID** 메모. **Team ID** 는 Membership 페이지 우측 상단

팀당 APNs 키는 최대 2개다. 2개 다 썼는데 파일이 없으면 하나 revoke 해야 한다.

## 2. Firebase 콘솔 — 새 iOS 앱에 키 등록

1. https://console.firebase.google.com/project/crying-time/settings/cloudmessaging
2. Apple 앱 구성 섹션에서 `com.devjj.platform.cryingtime` 찾기
3. APNs 인증 키 → 업로드
4. .p8 파일, Key ID, Team ID 입력 → 업로드

## 3. Xcode — 앱에 capability 추가

키만 올리면 디바이스 토큰을 못 받는다. Xcode 있는 머신에서:

1. `ios/Runner.xcworkspace` 열기 → Runner 타겟 → Signing & Capabilities
2. + Capability → **Push Notifications** — `Runner.entitlements` 가 생성되고 `aps-environment` 가 들어간다
3. + Capability → **Background Modes** → Remote notifications 체크
4. Automatic signing 이 켜져 있으면 Xcode 가 개발자 포털에 `com.devjj.platform.cryingtime` App ID 를 Push 활성화 상태로 자동 등록한다

끝나면 `ios/Runner/Runner.entitlements` 와 `ios/Runner.xcodeproj/project.pbxproj` 변경분을 커밋한다.

## 검증

- 실기기에서 `flutter run` → `FirebaseMessaging.instance.getToken()` 이 null 이 아닌 값 반환
- Firebase 콘솔 → Messaging → 테스트 메시지를 그 토큰으로 보내서 수신 확인

## 정리할 것

- Firebase 프로젝트에 남아 있는 `com.example.cryingTime` / `com.example.crying_time` 앱은 콘솔에서 삭제한다
