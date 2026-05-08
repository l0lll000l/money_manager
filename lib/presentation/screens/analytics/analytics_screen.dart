import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import 'analytics_controller.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnalyticsController());
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPeriodSelector(controller, context),
              const SizedBox(height: 32),
              _buildChartSection(controller, context, formatter),
              const SizedBox(height: 32),
              Text('Spending Breakdown', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              _buildCategoryList(controller, context, formatter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(AnalyticsController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Obx(() => Row(
        children: controller.periods.map((period) {
          final isSelected = controller.currentPeriod.value == period;
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.setPeriod(period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ] : null,
                ),
                child: Text(
                  period,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      )),
    );
  }

  Color _getColorForHex(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Widget _buildChartSection(AnalyticsController controller, BuildContext context, NumberFormat formatter) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(() => PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 80,
              sections: controller.expenseByCategory.map((data) {
                return PieChartSectionData(
                  color: _getColorForHex(data['color'] as String),
                  value: (data['percentage'] as int).toDouble(),
                  title: '', // No title on slice for minimal look
                  radius: 20,
                );
              }).toList(),
            ),
          )),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Spent', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Obx(() => Text(
                formatter.format(controller.totalExpense.value),
                style: Theme.of(context).textTheme.headlineLarge,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(AnalyticsController controller, BuildContext context, NumberFormat formatter) {
    return Obx(() => ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.expenseByCategory.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final data = controller.expenseByCategory[index];
        final color = _getColorForHex(data['color'] as String);
        final percentage = data['percentage'] as int;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
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
                        Text(data['category'] as String, style: Theme.of(context).textTheme.labelLarge),
                        Text(
                          formatter.format(data['amount'] as double),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: AppTheme.surfaceLight,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
