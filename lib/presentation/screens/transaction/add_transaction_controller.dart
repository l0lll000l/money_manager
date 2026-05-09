import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/database_service.dart';
import '../dashboard/dashboard_controller.dart';
import '../analytics/analytics_controller.dart';

class AddTransactionController extends GetxController {
  final isIncome = false.obs;
  final amount = '0'.obs;
  final selectedCategory = ''.obs;
  final noteController = TextEditingController();
  final selectedDate = DateTime.now().obs;

  final expenseCategories = [
    {'name': 'Food', 'icon': 'utensils'},
    {'name': 'Transport', 'icon': 'car'},
    {'name': 'Shopping', 'icon': 'shoppingBag'},
    {'name': 'Entertainment', 'icon': 'film'},
    {'name': 'Health', 'icon': 'activity'},
    {'name': 'Other', 'icon': 'moreHorizontal'},
  ];

  final incomeCategories = [
    {'name': 'Salary', 'icon': 'briefcase'},
    {'name': 'Freelance', 'icon': 'laptop'},
    {'name': 'Gift', 'icon': 'gift'},
    {'name': 'Investment', 'icon': 'trendingUp'},
    {'name': 'Other', 'icon': 'moreHorizontal'},
  ];

  List<Map<String, String>> get currentCategories => isIncome.value ? incomeCategories : expenseCategories;

  void toggleType(bool income) {
    isIncome.value = income;
    selectedCategory.value = ''; // Reset category
  }

  void appendAmount(String val) {
    if (amount.value == '0') {
      if (val == '.') {
        amount.value = '0.';
      } else {
        amount.value = val;
      }
    } else {
      if (val == '.' && amount.value.contains('.')) return;
      amount.value += val;
    }
  }

  void removeAmount() {
    if (amount.value.length > 1) {
      amount.value = amount.value.substring(0, amount.value.length - 1);
    } else {
      amount.value = '0';
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  void saveTransaction() async {
    if (amount.value == '0' || amount.value.isEmpty) {
      Get.snackbar('Error', 'Please enter an amount');
      return;
    }
    if (selectedCategory.value.isEmpty) {
      Get.snackbar('Error', 'Please select a category');
      return;
    }
    
    final dbService = Get.find<DatabaseService>();
    final parsedAmount = double.tryParse(amount.value) ?? 0.0;
    final finalAmount = isIncome.value ? parsedAmount : -parsedAmount;
    
    final categoryObj = currentCategories.firstWhere((cat) => cat['name'] == selectedCategory.value);
    final iconString = categoryObj['icon'] ?? 'moreHorizontal';

    final transaction = TransactionModel(
      title: noteController.text.isNotEmpty ? noteController.text : selectedCategory.value,
      category: selectedCategory.value,
      amount: finalAmount,
      date: selectedDate.value,
      icon: iconString,
    );

    await dbService.insertTransaction(transaction);

    // Refresh Dashboard if it's initialized
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadData();
    }
    // Refresh Analytics if it's initialized
    if (Get.isRegistered<AnalyticsController>()) {
      Get.find<AnalyticsController>().loadData();
    }

    Get.back();
    Get.snackbar('Success', 'Transaction saved successfully');
  }
}
