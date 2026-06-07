import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../core/services/ad_service.dart';

class SettingsController extends GetxController {
  final RxBool darkThemeEnabled = true.obs;

  BannerAd? bannerAd;
  final isAdLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();

    _initAd();
  }

  void _initAd() {
    bannerAd = AdService().createBannerAd(
      onAdLoaded: () {
        isAdLoaded.value = true;
      },
      onAdFailedToLoad: (ad, error) {
        isAdLoaded.value = false;
      },
    )..load();
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }


  void toggleDarkTheme(bool value) => darkThemeEnabled.value = value;

  void logout() {
    // Logout logic
    Get.offAllNamed('/onboarding');
  }
}
