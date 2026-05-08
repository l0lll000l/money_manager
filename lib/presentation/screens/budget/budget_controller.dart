import 'package:get/get.dart';

class BudgetController extends GetxController {
  final budgets = [
    {
      'category': 'Food & Dining',
      'icon': 'utensils',
      'limit': 500.0,
      'spent': 420.50,
      'color': '#3B82F6', // primary
    },
    {
      'category': 'Transport',
      'icon': 'car',
      'limit': 200.0,
      'spent': 210.00, // Exceeded
      'color': '#EF4444', // error
    },
    {
      'category': 'Shopping',
      'icon': 'shoppingBag',
      'limit': 300.0,
      'spent': 150.00,
      'color': '#F59E0B', // warning
    },
    {
      'category': 'Entertainment',
      'icon': 'film',
      'limit': 150.0,
      'spent': 40.00,
      'color': '#10B981', // success
    },
  ].obs;

  final savingsGoal = {
    'title': 'New Macbook Pro',
    'target': 2500.0,
    'saved': 1200.0,
  }.obs;
}
