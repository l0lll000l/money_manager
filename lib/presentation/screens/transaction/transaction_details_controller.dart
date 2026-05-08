import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';

class TransactionDetailsController extends GetxController {
  final Map<String, dynamic> transaction = Get.arguments ?? {};

  void deleteTransaction() {
    // Delete logic here
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
