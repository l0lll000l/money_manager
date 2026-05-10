import 'package:get/get.dart';
import '../../../core/services/database_service.dart';

class BudgetController extends GetxController {
  final dbService = Get.find<DatabaseService>();

  final budgets = <Map<String, dynamic>>[].obs;
  final savingsGoal = <String, dynamic>{}.obs;

  final Map<String, Map<String, String>> categoryMeta = {
    'Food': {'icon': 'utensils', 'color': '#EF4444'},
    'Transport': {'icon': 'car', 'color': '#EC4899'},
    'Shopping': {'icon': 'shoppingBag', 'color': '#8B5CF6'},
    'Entertainment': {'icon': 'film', 'color': '#F59E0B'},
    'Health': {'icon': 'activity', 'color': '#3B82F6'},
    'Work': {'icon': 'briefcase', 'color': '#F59E0B'},
    'Electronics': {'icon': 'laptop', 'color': '#F97316'},
    'Other': {'icon': 'moreHorizontal', 'color': '#10B981'},
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
