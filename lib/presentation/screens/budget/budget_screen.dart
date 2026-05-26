import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import 'budget_controller.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BudgetController());
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () => _showSavingsGoalDialog(context, controller),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 100,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSavingsGoal(controller, context, formatter),
              const SizedBox(height: 32),
              Text(
                'Monthly Budgets',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.budgets.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final budget = controller.budgets[index];
                    return GestureDetector(
                      onTap: () => _showCategoryBudgetDialog(
                        context,
                        controller,
                        budget,
                      ),
                      child: _buildBudgetCard(budget, context, formatter),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsGoal(
    BudgetController controller,
    BuildContext context,
    NumberFormat formatter,
  ) {
    return Obx(() {
      final goal = controller.savingsGoal;
      if (goal.isEmpty) return const SizedBox();

      final target = goal['target'] as double;
      final saved = goal['saved'] as double;
      final progress = target > 0 ? (saved / target).clamp(0.0, 1.0) : 0.0;

      return GestureDetector(
        onTap: () => _showSavingsGoalDialog(context, controller),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: AppTheme.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          LucideIcons.target,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Savings Goal',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                goal['title'] as String,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    formatter.format(saved),
                    style: Theme.of(
                      context,
                    ).textTheme.displayMedium?.copyWith(color: Colors.white),
                  ),
                  Text(
                    ' / ${formatter.format(target)}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.black.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showSavingsGoalDialog(
    BuildContext context,
    BudgetController controller,
  ) {
    final goal = controller.savingsGoal;
    final titleController = TextEditingController(text: goal['title'] ?? '');
    final targetController = TextEditingController(
      text: (goal['target'] ?? 0).toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Savings Goal',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Goal Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: targetController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Target Amount'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final target =
                        double.tryParse(targetController.text) ?? 0.0;
                    final saved = goal['saved'] ?? 0.0;
                    controller.updateSavingsGoal(
                      titleController.text,
                      target,
                      saved,
                    );
                    Get.back();
                  },
                  child: const Text('Save Goal'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryBudgetDialog(
    BuildContext context,
    BudgetController controller,
    Map<String, dynamic> budget,
  ) {
    final category = budget['category'] as String;
    final limitController = TextEditingController(
      text: (budget['limit'] ?? 0).toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set limit for $category',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: limitController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Monthly Limit',
                  prefixIcon: const Icon(
                    LucideIcons.dollarSign,
                    color: Colors.white54,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final limit = double.tryParse(limitController.text) ?? 0.0;
                    controller.updateBudgetLimit(category, limit);
                    Get.back();
                  },
                  child: const Text('Save Budget'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
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
      default:
        return LucideIcons.moreHorizontal;
    }
  }

  Color _getColorForHex(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Widget _buildBudgetCard(
    Map<String, dynamic> budget,
    BuildContext context,
    NumberFormat formatter,
  ) {
    final limit = budget['limit'] as double;
    final spent = budget['spent'] as double;
    final progress = limit > 0 ? spent / limit : 0.0;
    final isExceeded = limit > 0 && spent > limit;
    final isNoLimit = limit == 0.0;
    final color = isExceeded
        ? AppTheme.error
        : _getColorForHex(budget['color'] as String);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isExceeded
              ? AppTheme.error.withValues(alpha: 0.5)
              : AppTheme.divider,
        ),
      ),
      child: Row(
        children: [
          // Circular Progress Ring
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: isNoLimit ? 1.0 : progress.clamp(0.0, 1.0),
                  backgroundColor: AppTheme.surfaceLight,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 6,
                ),
                Center(
                  child: Icon(
                    _getIconForName(budget['icon'] as String),
                    color: color,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      budget['category'] as String,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    if (isExceeded)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Exceeded',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.error, fontSize: 10),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      formatter.format(spent),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: isExceeded
                                ? AppTheme.error
                                : AppTheme.textPrimary,
                          ),
                    ),
                    if (!isNoLimit)
                      Text(
                        ' / ${formatter.format(limit)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isNoLimit
                      ? 'No limit set'
                      : isExceeded
                      ? '${formatter.format(spent - limit)} over budget'
                      : '${formatter.format(limit - spent)} left',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isNoLimit
                        ? AppTheme.textSecondary
                        : (isExceeded
                              ? AppTheme.error
                              : AppTheme.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
