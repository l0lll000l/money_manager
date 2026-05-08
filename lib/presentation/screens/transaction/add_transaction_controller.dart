import 'package:get/get.dart';
import 'package:flutter/material.dart';

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

  void saveTransaction() {
    if (amount.value == '0' || amount.value.isEmpty) {
      Get.snackbar('Error', 'Please enter an amount');
      return;
    }
    if (selectedCategory.value.isEmpty) {
      Get.snackbar('Error', 'Please select a category');
      return;
    }
    // Simulate save
    Get.back();
    Get.snackbar('Success', 'Transaction saved successfully');
  }
}
