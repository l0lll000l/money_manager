import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/services/notification_service.dart';

class SettingsController extends GetxController {
  final RxBool notificationsEnabled = true.obs;
  final RxBool darkThemeEnabled = true.obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    notificationsEnabled.value = _storage.read('notificationsEnabled') ?? true;
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
