import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();

  factory AdService() {
    return _instance;
  }

  AdService._internal();

  /// Initialize Google Mobile Ads SDK.
  Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  /// Returns the appropriate Banner Ad Unit ID based on platform and environment.
  String get bannerAdUnitId {
    if (kDebugMode) {
      // Official Google test banner ad unit ID
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }
    // Production Ad Unit ID provided by the user
    return 'ca-app-pub-6728448774064000/7277580166';
  }

  /// Helper to create and load a standard Banner Ad.
  BannerAd createBannerAd({
    required VoidCallback onAdLoaded,
    required Function(Ad ad, LoadAdError error) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onAdLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onAdFailedToLoad(ad, error);
        },
      ),
    );
  }
}
