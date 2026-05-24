import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  final currencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );
  final dbService = Get.find<DatabaseService>();

  final totalBalance = 0.0.obs;
  final monthlyIncome = 0.0.obs;
  final monthlyExpense = 0.0.obs;

  final savingsGoal = 5000.00.obs;
  final savingsCurrent = 3200.00.obs;

  final RxList<double> weeklySpending = <double>[0, 0, 0, 0, 0, 0, 0].obs;
  final recentTransactions = [].obs;
  final userName = 'User'.obs;
  final hasUnreadNotifications = false.obs;

  // Contribution Calendar State
  final RxList<List<Map<String, dynamic>>> contributionWeeks = <List<Map<String, dynamic>>>[].obs;
  final selectedContribution = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadData();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('user_name') ?? 'User';
  }

  Future<void> updateUserName(String newName) async {
    if (newName.trim().isEmpty) return;
    userName.value = newName.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', userName.value);
  }

  Future<void> loadData() async {
    final transactions = await dbService.getTransactions();

    double balance = 0;
    double income = 0;
    double expense = 0;

    List<double> spending = [0, 0, 0, 0, 0, 0, 0];
    final now = DateTime.now();

    for (var tx in transactions) {
      balance += tx.amount;

      // Calculate monthly income/expense
      if (tx.date.year == now.year && tx.date.month == now.month) {
        if (tx.amount > 0) {
          income += tx.amount;
        } else {
          expense += tx.amount.abs();
        }
      }

      // Calculate weekly spending (last 7 days)
      final difference = now.difference(tx.date).inDays;
      if (difference >= 0 && difference < 7 && tx.amount < 0) {
        spending[6 - difference] += tx.amount.abs();
      }
    }

    totalBalance.value = balance;
    monthlyIncome.value = income;
    monthlyExpense.value = expense;
    weeklySpending.assignAll(spending);

    // Check for unread over-budget notifications
    final prefs = await SharedPreferences.getInstance();
    final lastOpenedStr = prefs.getString('last_opened_notifications');
    DateTime? lastOpened;
    if (lastOpenedStr != null) {
      lastOpened = DateTime.tryParse(lastOpenedStr);
    }
    
    final budgetLimits = dbService.getBudgetLimits();
    Map<String, double> spentByCategory = {};
    Map<String, DateTime> latestTransactionByCategory = {};
    
    for (var tx in transactions) {
      if (tx.amount < 0 && tx.date.year == now.year && tx.date.month == now.month) {
        spentByCategory[tx.category] = (spentByCategory[tx.category] ?? 0) + tx.amount.abs();
        final currentLatest = latestTransactionByCategory[tx.category];
        if (currentLatest == null || tx.date.isAfter(currentLatest)) {
          latestTransactionByCategory[tx.category] = tx.date;
        }
      }
    }
    
    bool unread = false;
    budgetLimits.forEach((category, limit) {
      final limitDouble = (limit as num).toDouble();
      final spent = spentByCategory[category] ?? 0.0;
      if (limitDouble > 0 && spent > limitDouble) {
        final latestTxDate = latestTransactionByCategory[category] ?? now;
        if (lastOpened == null || latestTxDate.isAfter(lastOpened)) {
          unread = true;
        }
      }
    });
    hasUnreadNotifications.value = unread;

    recentTransactions.assignAll(
      transactions
          .take(5)
          .map(
            (tx) => {
              'id': tx.id,
              'title': tx.title,
              'category': tx.category,
              'amount': tx.amount,
              'date': tx.date,
              'icon': tx.icon,
            },
          )
          .toList(),
    );

    // Calculate GitHub Contribution Calendar Weeks
    final today = DateTime(now.year, now.month, now.day);
    // Find Sunday of the current week (GitHub calendar columns start on Sunday)
    // today.weekday is 1 (Monday) to 7 (Sunday). So subtract today.weekday % 7 to get Sunday.
    final currentWeekSunday = today.subtract(Duration(days: today.weekday % 7));
    // Start date is 19 weeks before this Sunday (so we have exactly 20 columns/weeks in total)
    final firstDate = currentWeekSunday.subtract(const Duration(days: 19 * 7));

    final Map<String, int> txCounts = {};
    final Map<String, double> txAmounts = {};
    
    for (var tx in transactions) {
      final txDateOnly = DateTime(tx.date.year, tx.date.month, tx.date.day);
      final key = txDateOnly.toIso8601String().split('T')[0];
      txCounts[key] = (txCounts[key] ?? 0) + 1;
      txAmounts[key] = (txAmounts[key] ?? 0) + tx.amount.abs();
    }

    final List<List<Map<String, dynamic>>> weeks = [];
    for (int w = 0; w < 20; w++) {
      final List<Map<String, dynamic>> weekDays = [];
      for (int d = 0; d < 7; d++) {
        final date = firstDate.add(Duration(days: w * 7 + d));
        final key = date.toIso8601String().split('T')[0];
        weekDays.add({
          'date': date,
          'count': txCounts[key] ?? 0,
          'totalAmount': txAmounts[key] ?? 0.0,
        });
      }
      weeks.add(weekDays);
    }
    contributionWeeks.assignAll(weeks);
  }

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
}
