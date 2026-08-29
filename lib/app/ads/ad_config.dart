import 'dart:io';

import 'package:flutter/foundation.dart';

/// AdMob 광고 단위 ID.
///
/// 디버그 빌드에서는 구글이 제공하는 테스트 ID를 쓴다. 개발 중 실제 광고를
/// 띄우고 누르면 무효 트래픽으로 잡혀 계정이 정지될 수 있어서다.
/// 앱 ID는 네이티브 설정(AndroidManifest.xml, Info.plist)에 있다.
abstract final class AdConfig {
  static String get homeBannerAdUnitId {
    if (kDebugMode) {
      return Platform.isIOS ? _testBannerIos : _testBannerAndroid;
    }
    return Platform.isIOS ? _bannerIos : _bannerAndroid;
  }

  static String get homeInterstitialAdUnitId {
    if (kDebugMode) {
      return Platform.isIOS ? _testInterstitialIos : _testInterstitialAndroid;
    }
    return Platform.isIOS ? _interstitialIos : _interstitialAndroid;
  }

  static const String _bannerAndroid = 'ca-app-pub-9818502417467314/3295649657';
  static const String _bannerIos = 'ca-app-pub-9818502417467314/3295649657';
  static const String _interstitialAndroid =
      'ca-app-pub-9818502417467314/5241944694';
  static const String _interstitialIos =
      'ca-app-pub-9818502417467314/5241944694';

  // https://developers.google.com/admob/flutter/test-ads
  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/9214589741';
  static const String _testBannerIos = 'ca-app-pub-3940256099942544/2435281174';
  static const String _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialIos =
      'ca-app-pub-3940256099942544/4411468910';
}
