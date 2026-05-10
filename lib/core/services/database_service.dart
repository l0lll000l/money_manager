import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/transaction_model.dart';

class DatabaseService extends GetxService {
  final _storage = GetStorage();
  final _key = 'transactions';
  final _budgetKey = 'budgets';
  final _savingsKey = 'savings_goal';

  Future<DatabaseService> init() async {
    return this;
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    final transactions = await getTransactions();

    // Auto-increment ID logic
    int nextId = 1;
    if (transactions.isNotEmpty) {
      nextId =
          transactions.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b) +
          1;
    }

    final newTransaction = TransactionModel(
      id: nextId,
      title: transaction.title,
      category: transaction.category,
      amount: transaction.amount,
      date: transaction.date,
      icon: transaction.icon,
    );

    transactions.add(newTransaction);
    await _saveTransactions(transactions);
    return nextId;
  }

  Future<void> updateTransaction(TransactionModel updatedTransaction) async {
    final transactions = await getTransactions();
    final index = transactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      transactions[index] = updatedTransaction;
      await _saveTransactions(transactions);
    }
  }

  Future<List<TransactionModel>> getTransactions() async {
    final List<dynamic>? rawList = _storage.read<List<dynamic>>(_key);
    if (rawList == null) return [];

    final transactions = rawList
        .map((item) => TransactionModel.fromMap(item))
        .toList();
    // Sort by date descending
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }

  Future<void> deleteTransaction(int id) async {
    final transactions = await getTransactions();
    transactions.removeWhere((t) => t.id == id);
    await _saveTransactions(transactions);
  }

  Future<void> _saveTransactions(List<TransactionModel> transactions) async {
    final rawList = transactions.map((t) => t.toMap()).toList();
    await _storage.write(_key, rawList);
  }

  // Budget Limits
  Map<String, dynamic> getBudgetLimits() {
    return _storage.read<Map<String, dynamic>>(_budgetKey) ?? {};
  }

  Future<void> saveBudgetLimit(String category, double limit) async {
    final limits = getBudgetLimits();
    limits[category] = limit;
    await _storage.write(_budgetKey, limits);
  }

  // Savings Goal
  Map<String, dynamic> getSavingsGoal() {
    return _storage.read<Map<String, dynamic>>(_savingsKey) ?? {
      'title': 'New Goal',
      'target': 1000.0,
      'saved': 0.0,
    };
  }

  Future<void> saveSavingsGoal(String title, double target, double saved) async {
    await _storage.write(_savingsKey, {
      'title': title,
      'target': target,
      'saved': saved,
    });
  }
}
