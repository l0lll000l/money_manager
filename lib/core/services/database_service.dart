import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DatabaseService extends GetxService {
  late Database _database;

  Future<DatabaseService> init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'money_manager.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            category TEXT NOT NULL,
            amount REAL NOT NULL,
            date TEXT NOT NULL,
            icon TEXT NOT NULL
          )
        ''');
      },
    );
    return this;
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    return await _database.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getTransactions() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'transactions',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteTransaction(int id) async {
    await _database.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
