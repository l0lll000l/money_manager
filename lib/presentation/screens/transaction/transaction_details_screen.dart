import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:money_manager/presentation/screens/dashboard/dashboard_controller.dart';
import '../../../core/theme/app_theme.dart';
import 'transaction_details_controller.dart';

class TransactionDetailsScreen extends GetView<TransactionDetailsController> {
  const TransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> transaction = controller.transaction;

    // Provide default values if transaction data is empty
    final String title = transaction['title'] ?? '';
    final String category = transaction['category'] ?? '';
    final double amount = transaction['amount'] ?? 0;
    final DateTime date = transaction['date'] ?? DateTime.now();
    final String note = transaction['note'] ?? '';
    final String iconStr = transaction['icon'] ?? '';
    final IconData icon = _getIconForName(iconStr);
    final bool isExpense = amount < 0;
    final dashboardcontroller = Get.put(DashboardController());
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppTheme.background,
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(
                title: title,
                amount: amount,
                isExpense: isExpense,
                icon: icon,
                dashboardcontroller: dashboardcontroller,
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
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () {
                  // Edit logic here
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.error),
                onPressed: () {
                  _showDeleteDialog(context);
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Transaction Details'),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    children: [
                      _buildDetailRow(
                        'Status',
                        'Completed',
                        Icons.check_circle_outline,
                        AppTheme.success,
                      ),
                      _buildDivider(),
                      _buildDetailRow(
                        'Category',
                        category,
                        Icons.category_outlined,
                        Colors.white70,
                      ),
                      _buildDivider(),
                      _buildDetailRow(
                        'Date',
                        DateFormat('MMM dd, yyyy').format(date),
                        Icons.calendar_today_outlined,
                        Colors.white70,
                      ),
                      _buildDivider(),
                      _buildDetailRow(
                        'Time',
                        DateFormat('hh:mm a').format(date),
                        Icons.access_time,
                        Colors.white70,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Note'),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.notes,
                            color: Colors.white54,
                            size: 20,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              note,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required String title,
    required double amount,
    required bool isExpense,
    required IconData icon,
    required DashboardController dashboardcontroller,
  }) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.surfaceLight, AppTheme.background],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isExpense
                    ? AppTheme.error.withValues(alpha: 0.1)
                    : AppTheme.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isExpense
                      ? AppTheme.error.withValues(alpha: 0.3)
                      : AppTheme.success.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 40,
                color: isExpense ? AppTheme.error : AppTheme.success,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${isExpense ? '' : '+'}${dashboardcontroller.currencyFormatter.format(amount)}',
              style: TextStyle(
                color: isExpense ? Colors.white : AppTheme.success,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildDetailCard({required List<Widget> children}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 16),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Delete Transaction',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this transaction? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteTransaction();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForName(String iconName) {
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
      default:
        return LucideIcons.moreHorizontal;
    }
  }
}
