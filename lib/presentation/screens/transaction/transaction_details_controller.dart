import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/database_service.dart';
import '../dashboard/dashboard_controller.dart';
import '../analytics/analytics_controller.dart';
import '../budget/budget_controller.dart';

class TransactionDetailsController extends GetxController {
  final Map<String, dynamic> transaction = Get.arguments ?? {};

  void deleteTransaction() async {
    final dbService = Get.find<DatabaseService>();
    final int? id = transaction['id'];
    
    if (id != null) {
      await dbService.deleteTransaction(id);
      
      // Refresh Dashboard if it's initialized
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().loadData();
      }
      // Refresh Analytics if it's initialized
      if (Get.isRegistered<AnalyticsController>()) {
        Get.find<AnalyticsController>().loadData();
      }
      // Refresh Budgets if it's initialized
      if (Get.isRegistered<BudgetController>()) {
        Get.find<BudgetController>().loadData();
      }
    }

    Get.back();
    Get.snackbar(
      'Success',
      'Transaction deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.success,
      colorText: Colors.white,
    );
  }
}
