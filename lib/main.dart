import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'presentation/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
