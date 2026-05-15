import 'package:get/get.dart';
import '../../../core/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard/dashboard_controller.dart';

class NotificationsController extends GetxController {
  final dbService = Get.find<DatabaseService>();

  // Using a list of maps to hold notification data dynamically
  final notifications = <Map<String, dynamic>>[].obs;
  
  final Map<String, Map<String, String>> categoryMeta = {
    'Food': {'icon': 'utensils', 'color': '#F59E0B'},
    'Transport': {'icon': 'car', 'color': '#EF4444'},
    'Shopping': {'icon': 'shoppingBag', 'color': '#EC4899'},
    'Entertainment': {'icon': 'film', 'color': '#10B981'},
    'Health': {'icon': 'activity', 'color': '#3B82F6'},
    'Work': {'icon': 'briefcase', 'color': '#F59E0B'},
    'Electronics': {'icon': 'laptop', 'color': '#F97316'},
    'Other': {'icon': 'moreHorizontal', 'color': '#8B5CF6'},
  };

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final budgetLimits = dbService.getBudgetLimits();
    final transactions = await dbService.getTransactions();

    final now = DateTime.now();

    // Group this month's expenses and track latest transaction date
    Map<String, double> spentByCategory = {};
    Map<String, DateTime> latestTransactionByCategory = {};
    
    for (var tx in transactions) {
      if (tx.amount < 0 &&
          tx.date.year == now.year &&
          tx.date.month == now.month) {
        spentByCategory[tx.category] =
            (spentByCategory[tx.category] ?? 0) + tx.amount.abs();
            
        final currentLatest = latestTransactionByCategory[tx.category];
        if (currentLatest == null || tx.date.isAfter(currentLatest)) {
          latestTransactionByCategory[tx.category] = tx.date;
        }
      }
    }

    final List<Map<String, dynamic>> generatedNotifications = [];

    budgetLimits.forEach((category, limit) {
      final spent = spentByCategory[category] ?? 0.0;
      final limitDouble = (limit as num).toDouble();
      
      if (limitDouble > 0 && spent > limitDouble) {
        final meta = categoryMeta[category] ?? {'icon': 'moreHorizontal', 'color': '#888888'};
        final latestTxDate = latestTransactionByCategory[category] ?? DateTime.now();
        
        generatedNotifications.add({
          'category': category,
          'overspentAmount': spent - limitDouble,
          'totalSpent': spent,
          'limit': limitDouble,
          'icon': meta['icon'],
          'color': meta['color'],
          'timestamp': latestTxDate,
        });
      }
    });

    // Sort by latest transaction date descending (last exceeded category on top)
    generatedNotifications.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    notifications.assignAll(generatedNotifications);
    
    // Update last opened time and clear badge
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_opened_notifications', DateTime.now().toIso8601String());
    
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().hasUnreadNotifications.value = false;
    }
  }
}
