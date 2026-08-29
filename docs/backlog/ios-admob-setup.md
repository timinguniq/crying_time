# iOS AdMob 광고 설정

홈 화면 하단 배너와 홈 5번째 진입마다 뜨는 전면광고가 Android 기준으로만 완성돼 있다. AdMob 은 Android 앱과 iOS 앱을 따로 등록하므로 iOS 용 ID 가 별도로 필요하다. 이 머신에는 Xcode 가 없어(CLI tools 만) iOS 빌드 검증도 못 했다.

## 현재 상태 (2026-08-29 기준)

| 항목 | 상태 |
| --- | --- |
| Android 앱 ID | `ca-app-pub-9818502417467314~3385327764` |
| Android 배너 단위 ID | `ca-app-pub-9818502417467314/3295649657` |
| Android 전면광고 단위 ID | `ca-app-pub-9818502417467314/5241944694` |
| iOS 앱 ID | 없음 — `ios/Runner/Info.plist` 의 `GADApplicationIdentifier` 에 **Android 값을 임시로** 넣어 둠 (키가 없으면 실행 즉시 죽어서) |
| iOS 배너 단위 ID | 없음 — `lib/app/ads/ad_config.dart` 의 `_bannerIos` 에 **Android 값을 임시로** 넣어 둠 |
| iOS 전면광고 단위 ID | 없음 — `lib/app/ads/ad_config.dart` 의 `_interstitialIos` 에 **Android 값을 임시로** 넣어 둠 |
| `SKAdNetworkItems` | 구글 자체 ID(`cstr6suwn9.skadnetwork`) 1개만 |
| iOS 빌드 검증 | 미완 — `ios/Podfile` 도 아직 없음(첫 빌드 때 자동 생성) |
| ATT(앱 추적 투명성) | 미설정 — 선택 사항 |

Android 값을 iOS 에 그대로 두면 앱은 뜨지만 광고는 안 나온다. 배너 위젯은 로드 실패 시 높이 0이라 레이아웃은 깨지지 않고, 전면광고는 못 띄우면 방문 횟수를 되돌리지 않아 다음 진입에 다시 시도한다.

## 1. AdMob 콘솔 — iOS 앱 등록, 광고 단위 생성

1. https://apps.admob.com → 앱 → 앱 추가 → 플랫폼 **iOS**
2. 스토어 등록 전이면 "아니요" 선택 후 앱 이름 `눈물타임` 입력. 등록 후엔 앱 설정에서 App Store 와 연결한다
3. 생성된 **앱 ID**(`ca-app-pub-…~…`) 메모
4. 그 앱 → 광고 단위 → 광고 단위 추가 → **배너** → 이름 `home_banner` → 만들기 → **광고 단위 ID**(`ca-app-pub-…/…`) 메모
5. 다시 광고 단위 추가 → **전면 광고** → 이름 `home_interstitial` → 만들기 → **광고 단위 ID** 메모

## 2. 코드에 iOS 값 반영

| 파일 | 바꿀 곳 |
| --- | --- |
| `ios/Runner/Info.plist` | `GADApplicationIdentifier` 값 → iOS 앱 ID |
| `lib/app/ads/ad_config.dart` | `_bannerIos` 값 → iOS 배너 단위 ID |
| `lib/app/ads/ad_config.dart` | `_interstitialIos` 값 → iOS 전면광고 단위 ID |

디버그 빌드는 구글 테스트 ID 를 쓰므로 `_testBannerIos`, `_testInterstitialIos` 는 건드리지 않는다.

## 3. `SKAdNetworkItems` 전체 목록으로 교체

iOS 14+ 에서 광고 전환 측정에 쓰인다. 빠지면 광고는 나오지만 수익이 떨어진다.

1. https://developers.google.com/admob/ios/ios14#skadnetwork 에서 plist 스니펫 복사
2. `ios/Runner/Info.plist` 의 기존 `SKAdNetworkItems` 배열을 통째로 교체

구글이 목록을 갱신하므로 SDK 를 올릴 때 같이 확인한다.

## 4. Xcode 있는 머신에서 빌드 확인

1. `flutter build ios --no-codesign` — `ios/Podfile` 이 생성되고 `Google-Mobile-Ads-SDK` pod 이 받아진다
2. `ios/Podfile` 과 `ios/Podfile.lock` 을 커밋한다

배포 타깃은 15.0(`project.pbxproj`)이라 플러그인 최소 요구(13.0)를 넘는다. Podfile 의 `platform :ios` 도 15.0 으로 맞춘다.

## 5. (선택) ATT 권한 요청

없어도 광고는 나오지만 iOS 14+ 에선 비맞춤 광고만 나와 단가가 낮다. 하려면:

1. `Info.plist` 에 `NSUserTrackingUsageDescription` 추가 (문구 예: `맞춤 광고를 제공하기 위해 사용됩니다`)
2. `app_tracking_transparency` 패키지로 첫 광고 로드 전에 `requestTrackingAuthorization()` 호출
3. App Store 심사 시 개인정보 항목에 "추적" 체크

## 검증

- 실기기 디버그 `flutter run` → 홈 하단에 "Test Ad" 라벨이 붙은 배너가 뜬다
- 앱을 껐다 켜서 홈에 5번째 들어가면 테스트 전면광고가 뜬다. 닫은 뒤 다시 5번을 채워야 또 뜬다 (설정·수령일 변경에서 홈으로 돌아오는 건 진입으로 세지 않는다)
- release 빌드 → 실광고. 새 광고 단위는 노출까지 몇 시간~며칠 걸리고, AdMob 앱 승인 전엔 노출이 제한된다. 비어 있어도 코드 문제가 아닐 수 있다

## 정리할 것

- App Store 등록 후 AdMob 앱 설정에서 스토어와 연결해 앱 승인을 받는다
