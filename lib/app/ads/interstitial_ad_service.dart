import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 전면광고를 불러와 화면에 띄운다. 테스트에서 갈아끼울 수 있게 인터페이스로 둔다.
abstract interface class InterstitialAdService {
  /// 광고가 실제로 화면에 떴으면 true. 불러오기·표시 실패는 false 로 돌려주고
  /// 예외는 던지지 않는다.
  Future<bool> show();
}

class AdMobInterstitialAdService implements InterstitialAdService {
  const AdMobInterstitialAdService(this._adUnitId);

  final String _adUnitId;

  @override
  Future<bool> show() {
    final shown = Completer<bool>();
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // 닫힐 때가 아니라 뜨는 순간 완료한다. 광고를 보는 도중 앱이 죽어도
            // 호출부가 이미 횟수를 되돌린 뒤라 다음 실행에 또 뜨지 않는다.
            onAdShowedFullScreenContent: (_) => shown.complete(true),
            onAdFailedToShowFullScreenContent: (ad, _) {
              ad.dispose();
              shown.complete(false);
            },
            onAdDismissedFullScreenContent: (ad) => ad.dispose(),
          );
          ad.show();
        },
        onAdFailedToLoad: (_) => shown.complete(false),
      ),
    );
    return shown.future;
  }
}
