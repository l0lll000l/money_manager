import 'package:get/get.dart';
import '../../../core/services/database_service.dart';

class BudgetController extends GetxController {
  final dbService = Get.find<DatabaseService>();

  final budgets = <Map<String, dynamic>>[].obs;
  final savingsGoal = <String, dynamic>{}.obs;

  final Map<String, Map<String, String>> categoryMeta = {
    'Food & Dining': {'icon': 'utensils', 'color': '#3B82F6'},
    'Transport': {'icon': 'car', 'color': '#EF4444'},
    'Shopping': {'icon': 'shoppingBag', 'color': '#F59E0B'},
    'Entertainment': {'icon': 'film', 'color': '#10B981'},
    'Health': {'icon': 'activity', 'color': '#8B5CF6'},
    'Work': {'icon': 'briefcase', 'color': '#EC4899'},
    'Electronics': {'icon': 'laptop', 'color': '#F97316'},
    'Gifts': {'icon': 'gift', 'color': '#06B6D4'},
  };

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    // 1. Load Savings Goal
    savingsGoal.value = dbService.getSavingsGoal();

    // 2. Load Budgets
    final budgetLimits = dbService.getBudgetLimits();
    final transactions = await dbService.getTransactions();

    final now = DateTime.now();

    // Group this month's expenses
    Map<String, double> spentByCategory = {};
    for (var tx in transactions) {
      if (tx.amount < 0 &&
          tx.date.year == now.year &&
          tx.date.month == now.month) {
        spentByCategory[tx.category] =
            (spentByCategory[tx.category] ?? 0) + tx.amount.abs();
      }
    }

    final List<Map<String, dynamic>> loadedBudgets = [];

    // Ensure all defined limits are shown
    budgetLimits.forEach((category, limit) {
      final spent = spentByCategory[category] ?? 0.0;
      final meta =
          categoryMeta[category] ??
          {'icon': 'moreHorizontal', 'color': '#888888'};
      loadedBudgets.add({
        'category': category,
        'icon': meta['icon'],
        'color': meta['color'],
        'limit': (limit as num).toDouble(),
        'spent': spent,
      });
      // Remove from spent mapping so we don't duplicate
      spentByCategory.remove(category);
    });

    // Also show categories where user spent money but hasn't set a limit
    spentByCategory.forEach((category, spent) {
      final meta =
          categoryMeta[category] ??
          {'icon': 'moreHorizontal', 'color': '#888888'};
      loadedBudgets.add({
        'category': category,
        'icon': meta['icon'],
        'color': meta['color'],
        'limit': 0.0, // No limit set
        'spent': spent,
      });
    });

    // Sort by limit descending, then spent descending
    loadedBudgets.sort((a, b) {
      final limitA = a['limit'] as double;
      final limitB = b['limit'] as double;
      if (limitA != limitB) return limitB.compareTo(limitA);
      return (b['spent'] as double).compareTo(a['spent'] as double);
    });

    budgets.assignAll(loadedBudgets);
  }

  Future<void> updateSavingsGoal(
    String title,
    double target,
    double saved,
  ) async {
    await dbService.saveSavingsGoal(title, target, saved);
    await loadData();
  }

  Future<void> updateBudgetLimit(String category, double limit) async {
    await dbService.saveBudgetLimit(category, limit);
    await loadData();
  }
}
