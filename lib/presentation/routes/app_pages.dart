import 'package:get/get.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/splash/splash_binding.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/transaction/add_transaction_screen.dart';
import '../screens/transaction/add_transaction_binding.dart';
import '../screens/transaction/transaction_details_screen.dart';
import '../screens/transaction/transaction_details_binding.dart';
import '../screens/transaction/all_transactions_screen.dart';
import '../screens/transaction/all_transactions_binding.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/notifications/notifications_binding.dart';
import '../screens/settings/help_support_screen.dart';

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
      name: AppRoutes.allTransactions,
      page: () => const AllTransactionsScreen(),
      binding: AllTransactionsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      binding: NotificationsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.helpSupport,
      page: () => const HelpSupportScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
