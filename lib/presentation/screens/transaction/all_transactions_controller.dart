import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/services/database_service.dart';

class AllTransactionsController extends GetxController {
  final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  final dbService = Get.find<DatabaseService>();
  
  final transactions = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final allTx = await dbService.getTransactions();
    // Sort transactions by date descending
    allTx.sort((a, b) => b.date.compareTo(a.date));
    
    transactions.assignAll(allTx.map((tx) => {
      'id': tx.id,
      'title': tx.title,
      'category': tx.category,
      'amount': tx.amount,
      'date': tx.date,
      'icon': tx.icon,
    }).toList());
  }
}
