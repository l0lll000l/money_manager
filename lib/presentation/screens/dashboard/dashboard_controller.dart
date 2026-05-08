import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  
  // Dummy Data
  final totalBalance = 12450.00.obs;
  final monthlyIncome = 4200.00.obs;
  final monthlyExpense = 1850.00.obs;
  
  final savingsGoal = 5000.00.obs;
  final savingsCurrent = 3200.00.obs;

  String get greeting {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  // Dummy Chart Data (Days of month, spending amount)
  final List<double> weeklySpending = [120, 250, 80, 410, 150, 300, 90];

  final recentTransactions = [
    {
      'title': 'Apple Music',
      'category': 'Entertainment',
      'amount': -10.99,
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': 'music', // mapping to icon later
    },
    {
      'title': 'Whole Foods',
      'category': 'Groceries',
      'amount': -85.20,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'icon': 'shoppingBag',
    },
    {
      'title': 'Salary',
      'category': 'Income',
      'amount': 4200.00,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'icon': 'briefcase',
    },
    {
      'title': 'Uber',
      'category': 'Transport',
      'amount': -24.50,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'icon': 'car',
    },
  ].obs;
}
