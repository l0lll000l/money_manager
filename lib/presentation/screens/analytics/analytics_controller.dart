import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  final currentPeriod = 'This Month'.obs;
  
  final periods = ['This Week', 'This Month', 'This Year'].obs;

  final expenseByCategory = [
    {'category': 'Food & Dining', 'amount': 420.50, 'color': '#3B82F6', 'percentage': 45},
    {'category': 'Transport', 'amount': 210.00, 'color': '#EF4444', 'percentage': 22},
    {'category': 'Shopping', 'amount': 150.00, 'color': '#F59E0B', 'percentage': 16},
    {'category': 'Entertainment', 'amount': 40.00, 'color': '#10B981', 'percentage': 4},
    {'category': 'Other', 'amount': 120.00, 'color': '#8B5CF6', 'percentage': 13},
  ].obs;

  final totalExpense = 940.50.obs;

  void setPeriod(String period) {
    currentPeriod.value = period;
    // mock updating data based on period
  }
}
