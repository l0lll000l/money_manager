import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(controller, context),
              const SizedBox(height: 24),
              _buildBalanceCard(controller, context),
              const SizedBox(height: 32),
              _buildActionButtons(context),
              const SizedBox(height: 32),
              _buildChartSection(controller, context),
              const SizedBox(height: 32),
              _buildRecentTransactions(controller, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(DashboardController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.toNamed('/profile'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.greeting,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text('Athul', style: Theme.of(context).textTheme.headlineLarge),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.surfaceLight,
              border: Border.all(color: AppTheme.divider),
            ),
            child: IconButton(
              icon: const Icon(LucideIcons.bell, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
    DashboardController controller,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: AppTheme.cardGradient,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.05),
              blurRadius: 24,
              spreadRadius: 0,
              offset: const Offset(0, 12),
            ),
          ],
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                controller.currencyFormatter.format(
                  controller.totalBalance.value,
                ),
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: 36),
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _buildIncomeExpense(
                      context,
                      'Income',
                      controller.monthlyIncome.value,
                      LucideIcons.arrowDownLeft,
                      AppTheme.success,
                      controller,
                    ),
                  ),
                  Container(height: 40, width: 1, color: AppTheme.divider),
                  Expanded(
                    child: _buildIncomeExpense(
                      context,
                      'Expense',
                      controller.monthlyExpense.value,
                      LucideIcons.arrowUpRight,
                      AppTheme.error,
                      controller,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpense(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
    Color color,
    DashboardController controller,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              controller.currencyFormatter.format(amount),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionItem(context, LucideIcons.send, 'Transfer'),
          _buildActionItem(context, LucideIcons.wallet, 'Top up'),
          _buildActionItem(context, LucideIcons.layoutGrid, 'More'),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.divider),
          ),
          child: Icon(icon, color: AppTheme.textPrimary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildChartSection(
    DashboardController controller,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analytics', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.only(top: 24, right: 16, bottom: 10),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Obx(() {
              final maxSpending = controller.weeklySpending.isEmpty
                  ? 500.0
                  : controller.weeklySpending.reduce((a, b) => a > b ? a : b);
              // Add 20% padding to the top of the chart
              final dynamicMaxY = maxSpending > 0 ? maxSpending * 1.2 : 500.0;

              return LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: dynamicMaxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.weeklySpending
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: AppTheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(
    DashboardController controller,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(onPressed: () {}, child: const Text('See All')),
            ],
          ),
          const SizedBox(height: 8),
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recentTransactions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final tx = controller.recentTransactions[index];
                final amount = tx['amount'] as double;
                final isIncome = amount > 0;

                IconData iconData = LucideIcons.circleDollarSign;
                if (tx['icon'] == 'music') {
                  iconData = LucideIcons.music;
                }
                if (tx['icon'] == 'shoppingBag') {
                  iconData = LucideIcons.shoppingBag;
                }
                if (tx['icon'] == 'briefcase') {
                  iconData = LucideIcons.briefcase;
                }
                if (tx['icon'] == 'car') {
                  iconData = LucideIcons.car;
                }
                if (tx['icon'] == 'utensils') {
                  iconData = LucideIcons.utensils;
                }
                if (tx['icon'] == 'film') {
                  iconData = LucideIcons.film;
                }
                if (tx['icon'] == 'activity') {
                  iconData = LucideIcons.activity;
                }
                if (tx['icon'] == 'moreHorizontal') {
                  iconData = LucideIcons.moreHorizontal;
                }

                return ListTile(
                  onTap: () =>
                      Get.toNamed('/transaction_details', arguments: tx),
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      iconData,
                      color: AppTheme.textPrimary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    tx['title'] as String,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  subtitle: Text(
                    tx['category'] as String,
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
            ),
          ),
        ],
      ),
    );
  }
}
