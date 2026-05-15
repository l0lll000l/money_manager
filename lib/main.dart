import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'presentation/routes/app_pages.dart';

import 'package:get_storage/get_storage.dart';
import 'core/services/database_service.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Get.putAsync(() => DatabaseService().init());

  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();

  final notificationsEnabled = GetStorage().read('notificationsEnabled') ?? true;
  if (notificationsEnabled) {
    await notificationService.scheduleDailyReminders();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Aura Money Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Only dark theme as requested
      themeMode: ThemeMode.dark,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
