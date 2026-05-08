import 'package:get/get.dart';

class SettingsController extends GetxController {
  final RxBool notificationsEnabled = true.obs;
  final RxBool darkThemeEnabled = true.obs;

  void toggleNotifications(bool value) => notificationsEnabled.value = value;
  void toggleDarkTheme(bool value) => darkThemeEnabled.value = value;

  void logout() {
    // Logout logic
    Get.offAllNamed('/onboarding');
  }
}
