import 'package:get/get.dart';
import '../../../core/services/database_service.dart';

class AnalyticsController extends GetxController {
  final dbService = Get.find<DatabaseService>();
  final transactionType = 'Expense'.obs;
  final currentPeriod = 'This Month'.obs;

  final periods = [
    'This Day',
    'This Week',
    'This Month',
    'This Year',
    'Select Day',
    'Select Month',
  ].obs;
  DateTime? customDayDate;
  DateTime? customMonthDate;

  final analyticsByCategory = <Map<String, dynamic>>[].obs;
  final totalAmount = 0.0.obs;

  final List<String> _colors = [
    '#3B82F6', // Blue
    '#EF4444', // Red
    '#F59E0B', // Amber
    '#10B981', // Emerald
    '#8B5CF6', // Purple
    '#EC4899', // Pink
    '#F97316', // Orange
    '#06B6D4', // Cyan
  ];

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void setPeriod(String period) {
    currentPeriod.value = period;
    if (period != periods[4]) {
      periods[4] = 'Select Day';
      customDayDate = null;
    }
    if (period != periods[5]) {
      periods[5] = 'Select Month';
      customMonthDate = null;
    }
    loadData();
  }

  void setCustomMonth(DateTime date) {
    customMonthDate = date;
    // We import intl below if not already imported
    final monthStr = _formatMonth(date);
    periods[5] = monthStr;
    currentPeriod.value = monthStr;
    
    periods[4] = 'Select Day';
    customDayDate = null;
    loadData();
  }

  void setCustomDay(DateTime date) {
    customDayDate = date;
    final dayStr = _formatDay(date);
    periods[4] = dayStr;
    currentPeriod.value = dayStr;
    
    periods[5] = 'Select Month';
    customMonthDate = null;
    loadData();
  }

  String _formatDay(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatMonth(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  Future<void> loadData() async {
    final transactions = await dbService.getTransactions();
    final now = DateTime.now();

    // Filter transactions by period
    final filteredTransactions = transactions.where((tx) {
      if (transactionType.value == 'Expense' && tx.amount >= 0) return false;
      if (transactionType.value == 'Income' && tx.amount < 0) return false;

      if (currentPeriod.value == 'This Day') {
        return tx.date.year == now.year &&
            tx.date.month == now.month &&
            tx.date.day == now.day;
      } else if (currentPeriod.value == 'This Week') {
        // Last 7 days including today
        final difference = now.difference(tx.date).inDays;
        return difference >= 0 && difference < 7;
      } else if (currentPeriod.value == 'This Month') {
        return tx.date.year == now.year && tx.date.month == now.month;
      } else if (currentPeriod.value == 'This Year') {
        return tx.date.year == now.year;
      } else if (customDayDate != null) {
        return tx.date.year == customDayDate!.year &&
            tx.date.month == customDayDate!.month &&
            tx.date.day == customDayDate!.day;
      } else if (customMonthDate != null) {
        return tx.date.year == customMonthDate!.year &&
            tx.date.month == customMonthDate!.month;
      }
      return false;
    }).toList();

    // Calculate total amount
    double total = 0.0;
    Map<String, double> categorySums = {};

    for (var tx in filteredTransactions) {
      final amount = tx.amount.abs();
      total += amount;
      if (categorySums.containsKey(tx.category)) {
        categorySums[tx.category] = categorySums[tx.category]! + amount;
      } else {
        categorySums[tx.category] = amount;
      }
    }

    totalAmount.value = total;

    // Create the final list
    if (total == 0) {
      analyticsByCategory.clear();
      return;
    }

    int colorIndex = 0;
    final List<Map<String, dynamic>> result = [];

    // Sort categories by amount descending
    final sortedCategories = categorySums.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (var entry in sortedCategories) {
      final percentage = ((entry.value / total) * 100).round();
      result.add({
        'category': entry.key,
        'amount': entry.value,
        'color': _colors[colorIndex % _colors.length],
        'percentage': percentage,
        'transactions': filteredTransactions.where((tx) => tx.category == entry.key).toList(),
      });
      colorIndex++;
    }

    analyticsByCategory.assignAll(result);
  }
}
