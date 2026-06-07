import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
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
              // _buildActionButtons(context),
              // const SizedBox(height: 32),
              _buildContributionCalendar(controller, context),
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
            onTap: () {
              final TextEditingController nameController =
                  TextEditingController(text: controller.userName.value);
              Get.dialog(
                AlertDialog(
                  backgroundColor: AppTheme.surface,
                  title: Text(
                    'Edit Name',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  content: TextField(
                    controller: nameController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.divider),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primary),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.updateUserName(nameController.text);
                        Get.back();
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: AppTheme.primary),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.greeting,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Obx(
                      () => Text(
                        controller.userName.value,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      LucideIcons.edit2,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.surfaceLight,
              border: Border.all(color: AppTheme.divider),
            ),
            child: Obx(
              () => Stack(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.bell, size: 20),
                    onPressed: () => Get.toNamed('/notifications'),
                  ),
                  if (controller.hasUnreadNotifications.value)
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
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



  Widget _buildContributionCalendar(
    DashboardController controller,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Calendar',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  if (controller.contributionWeeks.isEmpty) {
                    return const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Days of the week label column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16), // Align with month labels
                          _buildDayOfWeekLabel('Su'),
                          _buildDayOfWeekLabel('Mo'),
                          _buildDayOfWeekLabel('Tu'),
                          _buildDayOfWeekLabel('We'),
                          _buildDayOfWeekLabel('Th'),
                          _buildDayOfWeekLabel('Fr'),
                          _buildDayOfWeekLabel('Sa'),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Heatmap grid with Month labels scrollable horizontally
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse:
                              true, // Display the current week (far right) by default
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMonthLabels(controller),
                              const SizedBox(height: 6),
                              _buildGridRows(controller),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const Divider(height: 32, thickness: 1),
                // Interactive selected date info
                Obx(() {
                  final selected = controller.selectedContribution.value;
                  if (selected == null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tap a cell to view daily activity',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                        _buildLegend(context),
                      ],
                    );
                  }

                  final date = selected['date'] as DateTime;
                  final count = selected['count'] as int;
                  final amount = selected['totalAmount'] as double;
                  final dateStr = DateFormat('EEEE, MMM d, y').format(date);
                  final dayTxs =
                      selected['transactions'] as List<dynamic>? ?? [];

                  String activityText = count == 0
                      ? 'No transactions recorded'
                      : '$count transaction${count > 1 ? 's' : ''} logged';
                  if (count > 0) {
                    activityText +=
                        ' (${controller.currencyFormatter.format(amount)})';
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dateStr,
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: AppTheme.textPrimary,
                                        fontSize: 12,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: count > 0
                                            ? AppTheme.success
                                            : AppTheme.textSecondary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      activityText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: count > 0
                                                ? AppTheme.success
                                                : AppTheme.textSecondary,
                                            fontWeight: count > 0
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              LucideIcons.x,
                              size: 14,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () {
                              controller.selectedContribution.value = null;
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      if (dayTxs.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dayTxs.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 16),
                          itemBuilder: (context, index) {
                            final tx = dayTxs[index];
                            final txAmount = tx['amount'] as double;
                            final isIncome = txAmount > 0;

                            return ListTile(
                              onTap: () => Get.toNamed(
                                '/transaction_details',
                                arguments: tx,
                              ),
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getTxIcon(tx['icon'] as String?),
                                  color: AppTheme.textPrimary,
                                  size: 16,
                                ),
                              ),
                              title: Text(
                                tx['category'] as String,
                                style: Theme.of(
                                  context,
                                ).textTheme.labelLarge?.copyWith(fontSize: 13),
                              ),
                              subtitle: Text(
                                tx['title'] as String,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(fontSize: 11),
                              ),
                              trailing: Text(
                                '${isIncome ? '+' : ''}${controller.currencyFormatter.format(txAmount)}',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: isIncome
                                          ? AppTheme.success
                                          : AppTheme.error,
                                      fontSize: 13,
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayOfWeekLabel(String label) {
    return Container(
      height: 13,
      margin: const EdgeInsets.symmetric(vertical: 1.5),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMonthLabels(DashboardController controller) {
    final weeks = controller.contributionWeeks;
    if (weeks.isEmpty) return const SizedBox(height: 12);

    List<Widget> children = [];
    for (int index = 0; index < weeks.length; index++) {
      final firstDayOfWeek = weeks[index][0]['date'] as DateTime;
      // Display month label every 4 weeks to avoid overlapping text
      final showLabel = index % 4 == 0;
      if (showLabel) {
        children.add(
          Positioned(
            left: index * 16.0,
            top: 0,
            child: Text(
              DateFormat('MMM').format(firstDayOfWeek),
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }
    }

    return SizedBox(
      height: 14,
      width: weeks.length * 16.0,
      child: Stack(clipBehavior: Clip.none, children: children),
    );
  }

  Widget _buildGridRows(DashboardController controller) {
    final weeks = controller.contributionWeeks;

    return Row(
      children: List.generate(weeks.length, (wIndex) {
        final week = weeks[wIndex];
        return Column(
          children: List.generate(week.length, (dIndex) {
            final day = week[dIndex];
            final date = day['date'] as DateTime;
            final count = day['count'] as int;

            // Determine color based on transaction count
            Color cellColor;
            if (count == 0) {
              cellColor = AppTheme.divider.withValues(alpha: 0.5);
            } else if (count == 1) {
              cellColor = AppTheme.success.withValues(alpha: 0.25);
            } else if (count == 2) {
              cellColor = AppTheme.success.withValues(alpha: 0.5);
            } else if (count == 3) {
              cellColor = AppTheme.success.withValues(alpha: 0.75);
            } else {
              cellColor = AppTheme.success;
            }

            final isSelected =
                controller.selectedContribution.value != null &&
                (controller.selectedContribution.value!['date'] as DateTime)
                        .difference(date)
                        .inDays ==
                    0;

            return GestureDetector(
              onTap: () {
                controller.selectedContribution.value = day;
              },
              child: Container(
                width: 13,
                height: 13,
                margin: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: BorderRadius.circular(3),
                  border: isSelected
                      ? Border.all(color: AppTheme.textPrimary, width: 1.0)
                      : Border.all(color: Colors.transparent, width: 1.0),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Less',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 9),
        ),
        const SizedBox(width: 4),
        _buildLegendCell(AppTheme.divider.withValues(alpha: 0.5)),
        _buildLegendCell(AppTheme.success.withValues(alpha: 0.25)),
        _buildLegendCell(AppTheme.success.withValues(alpha: 0.5)),
        _buildLegendCell(AppTheme.success.withValues(alpha: 0.75)),
        _buildLegendCell(AppTheme.success),
        const SizedBox(width: 4),
        Text(
          'More',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 9),
        ),
      ],
    );
  }

  Widget _buildLegendCell(Color color) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }

  IconData _getTxIcon(String? icon) {
    switch (icon) {
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
      case 'music':
        return LucideIcons.music;
      case 'target':
        return LucideIcons.target;
      default:
        return LucideIcons.circleDollarSign;
    }
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
              TextButton(
                onPressed: () => Get.toNamed('/all_transactions'),
                child: const Text('See All'),
              ),
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
                final iconData = _getTxIcon(tx['icon'] as String?);

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
                    tx['category'] as String,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  subtitle: Text(
                    tx['title'] as String,
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
