import 'package:get/get.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/splash/splash_binding.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/transaction/add_transaction_screen.dart';
import '../screens/transaction/add_transaction_binding.dart';
import '../screens/transaction/transaction_details_screen.dart';
import '../screens/transaction/transaction_details_binding.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/profile_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => MainScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.addTransaction,
      page: () => const AddTransactionScreen(),
      binding: AddTransactionBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.transactionDetails,
      page: () => const TransactionDetailsScreen(),
      binding: TransactionDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
