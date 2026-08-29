import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 화면 폭에 맞춘 고정형(anchored adaptive) 배너 광고.
///
/// 로드가 끝나기 전이나 실패했을 때는 자리를 차지하지 않아, 광고가 없어도
/// 레이아웃이 비어 보이지 않는다.
class AppBannerAd extends StatefulWidget {
  const AppBannerAd({super.key, required this.adUnitId});

  final String adUnitId;

  @override
  State<AppBannerAd> createState() => _AppBannerAdState();
}

class _AppBannerAdState extends State<AppBannerAd> {
  BannerAd? _ad;
  bool _loadStarted = false;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 크기 계산에 MediaQuery 가 필요해 initState 대신 여기서 시작한다.
    // 이 콜백은 여러 번 불릴 수 있으므로 한 번만 로드한다.
    if (!_loadStarted) {
      _loadStarted = true;
      _load();
    }
  }

  Future<void> _load() async {
    final width = MediaQuery.sizeOf(context).width.truncate();
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (!mounted || size == null) {
      return;
    }

    final ad = BannerAd(
      adUnitId: widget.adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() => _loaded = true);
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted) {
            setState(() => _ad = null);
          }
        },
      ),
    );
    _ad = ad;
    await ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (ad == null || !_loaded) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
