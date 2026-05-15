import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/services/database_service.dart';

class AllTransactionsController extends GetxController {
  final currencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );
  final dbService = Get.find<DatabaseService>();

  final transactions = [].obs;
  final pageTitle = 'All Transactions'.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('title')) {
        pageTitle.value = args['title'];
      }
      if (args.containsKey('transactions')) {
        final txns = args['transactions'] as List;

        transactions.assignAll(
          txns
              .map(
                (tx) => {
                  'id': tx.id,
                  'title': tx.title,
                  'category': tx.category,
                  'amount': tx.amount,
                  'date': tx.date,
                  'icon': tx.icon,
                },
              )
              .toList(),
        );

        transactions.sort(
          (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
        );
        return;
      }
    }

    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final allTx = await dbService.getTransactions();
    // Sort transactions by date descending
    allTx.sort((a, b) => b.date.compareTo(a.date));

    transactions.assignAll(
      allTx
          .map(
            (tx) => {
              'id': tx.id,
              'title': tx.title,
              'category': tx.category,
              'amount': tx.amount,
              'date': tx.date,
              'icon': tx.icon,
            },
          )
          .toList(),
    );
  }
}
