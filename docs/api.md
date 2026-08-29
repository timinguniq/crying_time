# 눈물타임 API 명세

앱이 호출하는 엔드포인트 전부. 서버는 아직 없고, 클라이언트는 이 계약을 전제로 구현돼 있다.

| # | 메서드 | 경로 | 언제 |
| --- | --- | --- | --- |
| 1 | `POST` | `/v1/devices` | 앱 시작 · FCM 토큰 갱신 |
| 2 | `PUT` | `/v1/devices/{deviceId}/push-enabled` | 설정의 푸시 스위치 |
| 3 | `PUT` | `/v1/devices/{deviceId}/push-schedule` | 알림 시점 · 수령일 · 수령량 변경, 앱 시작 |

---

## 공통

| 항목 | 값 |
| --- | --- |
| Base URL | `--dart-define=API_BASE_URL` (기본 `https://crying-time-api.devjj.co.kr`) |
| Content-Type | `application/json` |
| 인증 | 없음. `deviceId` 가 유일한 식별자다 |
| connect timeout | 10초 |
| receive timeout | 10초 |
| 응답 본문 | 쓰지 않는다. 상태 코드만 본다 |

기본 서버 주소는 `ApiConfig.baseUrl` 이다. 다른 서버를 붙이려면:

```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

### 공통 필드

| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `deviceId` | string | 앱 최초 실행 때 기기에서 만든 UUID v4. 앱을 지우기 전까지 안 바뀐다 |
| `utcOffsetMinutes` | int | UTC 기준 오프셋(분). 한국은 `540`. 서버가 발송 시각을 지역시간으로 맞출 때 쓴다 |
| `offsetDays` | int[] | 수령 가능일 며칠 전에 보낼지. 당일은 `0`. 내림차순 · 중복 없음 |
| `nextPickupDate` | string | `yyyy-MM-dd`. 다음 수령 가능일 |

`deviceId` 를 기기에서 만드는 이유: Android 는 더 이상 안정적인 하드웨어 식별자를 주지 않고,
iOS 의 `identifierForVendor` 도 앱을 지우면 바뀐다.

---

## 1. 기기 등록

```http
POST /v1/devices
Content-Type: application/json

{
  "deviceId": "3d710650-a08d-4a13-915f-d9194a2f5b7f",
  "fcmToken": "fMEP0vJ...",
  "platform": "android",
  "utcOffsetMinutes": 540
}
```

| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `deviceId` | string | 위 공통 필드 참고 |
| `fcmToken` | string | 이 기기로 푸시를 보내는 주소 |
| `platform` | string | `"android"` \| `"ios"` |
| `utcOffsetMinutes` | int | 위 공통 필드 참고 |

**응답**: `200` 또는 `201`. 본문은 안 쓴다.

**서버 구현 노트**

- `deviceId` 기준 **upsert**. 매번 새 레코드를 만들면 안 된다.
- 앱을 켤 때마다 호출된다. 같은 요청이 반복해서 들어와도 안전해야 한다.
- FCM 토큰이 갱신되면 같은 `deviceId` 에 새 `fcmToken` 으로 다시 들어온다. 옛 토큰은 버린다.
- 알림 권한이 거부되면 토큰이 없어서 앱이 이 요청 자체를 보내지 않는다.

---

## 2. 푸시 켜기 / 끄기

설정 화면의 푸시 알림 스위치. 수신 여부만 바꾼다.

```http
PUT /v1/devices/{deviceId}/push-enabled
Content-Type: application/json

{ "enabled": false }
```

| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `enabled` | bool | 푸시를 받을지 |

**응답**: `200`. 본문은 안 쓴다.

**서버 구현 노트**

- **알림 시점(`offsetDays`)은 건드리지 않는다.** 발송만 멈추고 예약은 남긴다.
  그래야 사용자가 다시 켰을 때 시점을 새로 고르지 않아도 된다.
- `3. 푸시 시점 변경` 의 `enabled: false` 와 결과가 같아야 한다. 어느 쪽으로 껐든
  다시 켰을 때 같은 시점이 살아나야 한다.

---

## 3. 푸시 시점 변경

```http
PUT /v1/devices/{deviceId}/push-schedule
Content-Type: application/json

{
  "enabled": true,
  "offsetDays": [14, 7, 3, 0],
  "nextPickupDate": "2026-10-12",
  "utcOffsetMinutes": 540
}
```

| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `enabled` | bool | 푸시를 받을지 |
| `offsetDays` | int[] | 위 공통 필드 참고 |
| `nextPickupDate` | string | 위 공통 필드 참고 |
| `utcOffsetMinutes` | int | 위 공통 필드 참고 |

**응답**: `200`. 본문은 안 쓴다.

**발송 날짜 계산**

```
발송일[i] = nextPickupDate - offsetDays[i]
```

예: `nextPickupDate: "2026-10-12"`, `offsetDays: [14, 7, 3, 0]`

| 오프셋 | 발송일 | 화면 표기 |
| --- | --- | --- |
| 14 | 2026-09-28 | D-14 |
| 7 | 2026-10-05 | D-7 |
| 3 | 2026-10-09 | D-3 |
| 0 | 2026-10-12 | 당일 |

발송 시각(몇 시)은 서버 정책으로 정한다. 앱은 시각을 보내지 않는다.
기기 지역시간에 맞출 때 `utcOffsetMinutes` 를 쓴다.

**호출 시점**

| 사용자 조작 | 바뀌는 것 |
| --- | --- |
| D-7 / D-3 / 당일 칩 | `offsetDays` |
| 직접 지정 체크 · ± | `offsetDays` |
| 수령일 변경 | `nextPickupDate` |
| 수령량 ± | `nextPickupDate` (주기가 바뀌므로) |
| 홈 "수령 완료" | `nextPickupDate` |
| 앱 시작 | 없음 (기기에 저장된 값을 그대로 다시 밀어 넣는다) |

**서버 구현 노트**

- 부분 갱신이 아니다. **항상 현재 설정 전체**가 온다. 받은 값으로 통째로 덮어쓰면 된다.
- `enabled: false` 거나 `offsetDays: []` 면 예약을 전부 취소한다.
- 이미 지난 날짜가 계산되면 그 건은 건너뛴다.
- 앱 시작 때마다 한 번 들어온다. 같은 요청이 반복돼도 안전해야 한다.

---

## 클라이언트 동작

### 요청 순서

앱을 켜면 이 순서로 나간다. 화면 진행은 이 요청들을 기다리지 않는다.

```
1. POST /v1/devices                 기기가 서버에 없으면 예약을 걸 대상이 없으므로 먼저
2. PUT  .../push-schedule           저장된 설정을 서버 예약과 다시 맞춘다
```

2번이 있는 이유: 설정을 바꾸던 순간 통신이 끊기면 서버에 옛 값이 남는다. 이게 없으면
사용자가 설정을 다시 건드리기 전까지 영영 어긋난 채로 있는다.

### 저장 순서

기기에 먼저 쓰고 서버로 보낸다. 통신이 실패해도 화면에 보이는 값과 기기에 남은 값은
어긋나지 않고, 사용자는 실패 문구만 본다.

### 요청 직렬화

설정 화면에서 나가는 요청은 한 줄로 세운다. 앞 요청이 끝나야 다음 요청이 나간다.
연타해도 늦게 도착한 옛 요청이 서버의 최신 상태를 덮어쓰지 않는다.

### 상태 코드 해석

| 상태 | 앱이 보여주는 문구 |
| --- | --- |
| 타임아웃 · 연결 실패 · 인증서 오류 | 네트워크 연결을 확인해주세요. |
| `401`, `403` | 인증이 만료되었습니다. 다시 로그인해주세요. |
| `404` | 요청한 데이터를 찾을 수 없습니다. |
| 그 밖의 4xx / 5xx | 서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요. |

`401` / `403` 문구는 스캐폴딩에서 온 것이고 이 앱에는 로그인이 없다. 프록시나 WAF 가
`403` 을 주면 사용자가 없는 로그인 화면을 찾게 되므로, 인증을 붙이지 않을 거면
`lib/feature/common/failure_message.dart` 의 문구를 고치는 편이 낫다.

---

## 서버에 보내지 않는 것

| 값 | 어디에 있나 |
| --- | --- |
| 마지막 수령일 | 기기 (`shared_preferences`) |
| 수령량 (박스 수) | 기기 |
| 재처방 주기 | 저장하지 않는다. 수령량에서 유도한다 (`박스수 × 60 ÷ 6`) |

서버는 발송에 필요한 `nextPickupDate` 만 받는다. 계산은 전부 앱이 한다.

---

## 관련 파일

| 파일 | 역할 |
| --- | --- |
| `lib/data/datasource/device_remote_data_source.dart` | 세 엔드포인트의 실제 호출 |
| `lib/data/dto/device_registration_request_dto.dart` | 1번 요청 본문 |
| `lib/data/dto/push_enabled_request_dto.dart` | 2번 요청 본문 |
| `lib/data/dto/push_schedule_request_dto.dart` | 3번 요청 본문 |
| `lib/data/network/api_config.dart` | Base URL · 타임아웃 · 목 스위치 |
| `lib/data/network/dio_error_mapper.dart` | 상태 코드 → 실패 타입 |
| `lib/domain/entity/push_schedule.dart` | `offsetDays` 생성 규칙 |
| `lib/domain/entity/pickup_info.dart` | 주기 · 다음 수령 가능일 계산 |
