import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import 'all_transactions_controller.dart';

class AllTransactionsScreen extends GetView<AllTransactionsController> {
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: Obx(
          () => Text(
            controller.pageTitle.value,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.transactions.isEmpty) {
          return Center(
            child: Text(
              'No transactions yet',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          itemCount: controller.transactions.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final tx = controller.transactions[index];
            final amount = tx['amount'] as double;
            final isIncome = amount > 0;

            IconData iconData = _getIconForName(tx['icon'] as String?);

            return ListTile(
              onTap: () => Get.toNamed('/transaction_details', arguments: tx),
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(iconData, color: AppTheme.textPrimary, size: 20),
              ),
              title: Text(
                tx['title'] as String,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              subtitle: Text(
                DateFormat('MMM dd, yyyy').format(tx['date'] as DateTime),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Text(
                '${isIncome ? '+' : ''}${controller.currencyFormatter.format(amount)}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isIncome ? AppTheme.success : AppTheme.error,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  IconData _getIconForName(String? iconName) {
    switch (iconName) {
      case 'utensils':
        return LucideIcons.utensils;
      case 'car':
        return LucideIcons.car;
      case 'shoppingBag':
        return LucideIcons.shoppingBag;
      case 'film':
        return LucideIcons.film;
      case 'activity':
        return LucideIcons.activity;
      case 'briefcase':
        return LucideIcons.briefcase;
      case 'laptop':
        return LucideIcons.laptop;
      case 'gift':
        return LucideIcons.gift;
      case 'trendingUp':
        return LucideIcons.trendingUp;
      case 'music':
        return LucideIcons.music;
      case 'target':
        return LucideIcons.target;
      default:
        return LucideIcons.moreHorizontal;
    }
  }
}
