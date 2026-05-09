import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/transaction_model.dart';

class DatabaseService extends GetxService {
  final _storage = GetStorage();
  final _key = 'transactions';

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
}
