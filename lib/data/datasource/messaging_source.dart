import 'package:firebase_messaging/firebase_messaging.dart';

/// FCM 토큰 발급 창구. 토큰은 서버가 이 기기로 푸시를 보내는 주소다.
abstract interface class MessagingSource {
  /// 알림 권한을 요청하고 토큰을 받는다. 권한이 없으면 null.
  Future<String?> token();

  /// FCM 이 토큰을 갱신할 때 새 토큰이 흐른다. 다시 등록해야 푸시가 끊기지 않는다.
  Stream<String> get tokenRefreshes;
}

class FirebaseMessagingSource implements MessagingSource {
  const FirebaseMessagingSource();

  @override
  Future<String?> token() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return null;
    }
    return messaging.getToken();
  }

  @override
  Stream<String> get tokenRefreshes =>
      FirebaseMessaging.instance.onTokenRefresh;
}
