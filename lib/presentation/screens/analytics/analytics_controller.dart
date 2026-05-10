import 'package:get/get.dart';
import '../../../core/services/database_service.dart';

class AnalyticsController extends GetxController {
  final dbService = Get.find<DatabaseService>();
  final currentPeriod = 'This Month'.obs;

  final periods = ['This Week', 'This Month', 'This Year', 'Select Month'].obs;
  DateTime? customMonthDate;

  final expenseByCategory = <Map<String, dynamic>>[].obs;
  final totalExpense = 0.0.obs;

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
    if (period != periods[3]) {
      periods[3] = 'Select Month';
      customMonthDate = null;
    }
    loadData();
  }

  void setCustomMonth(DateTime date) {
    customMonthDate = date;
    // We import intl below if not already imported
    final monthStr = _formatMonth(date);
    periods[3] = monthStr;
    currentPeriod.value = monthStr;
    loadData();
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
      if (tx.amount >= 0) return false; // Only expenses

      if (currentPeriod.value == 'This Week') {
        // Last 7 days including today
        final difference = now.difference(tx.date).inDays;
        return difference >= 0 && difference < 7;
      } else if (currentPeriod.value == 'This Month') {
        return tx.date.year == now.year && tx.date.month == now.month;
      } else if (currentPeriod.value == 'This Year') {
        return tx.date.year == now.year;
      } else if (customMonthDate != null) {
        return tx.date.year == customMonthDate!.year &&
            tx.date.month == customMonthDate!.month;
      }
      return false;
    }).toList();

    // Calculate total expense
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

    totalExpense.value = total;

    // Create the final list
    if (total == 0) {
      expenseByCategory.clear();
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
      });
      colorIndex++;
    }

    expenseByCategory.assignAll(result);
  }
}
