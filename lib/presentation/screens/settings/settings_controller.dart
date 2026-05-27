import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/ad_service.dart';

class SettingsController extends GetxController {
  final RxBool notificationsEnabled = true.obs;
  final RxBool darkThemeEnabled = true.obs;
  final _storage = GetStorage();

  BannerAd? bannerAd;
  final isAdLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    notificationsEnabled.value = _storage.read('notificationsEnabled') ?? true;
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

  void toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    _storage.write('notificationsEnabled', value);
    
    if (value) {
      await NotificationService().scheduleDailyReminders();
    } else {
      await NotificationService().cancelDailyReminders();
    }
  }
  void toggleDarkTheme(bool value) => darkThemeEnabled.value = value;

  void logout() {
    // Logout logic
    Get.offAllNamed('/onboarding');
  }
}
