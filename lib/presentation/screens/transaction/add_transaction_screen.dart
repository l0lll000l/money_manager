import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import 'add_transaction_controller.dart';

class AddTransactionScreen extends GetView<AddTransactionController> {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTypeToggle(context, 'Expense', !controller.isIncome.value),
              const SizedBox(width: 16),
              _buildTypeToggle(context, 'Income', controller.isIncome.value),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildAmountDisplay(context),
                    const SizedBox(height: 32),
                    _buildCategorySelection(context),
                    const SizedBox(height: 32),
                    _buildDateSelection(context),
                    const SizedBox(height: 32),
                    _buildNoteInput(context),
                  ],
                ),
              ),
            ),
            _buildKeypad(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeToggle(BuildContext context, String label, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.toggleType(label == 'Income'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceLight : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountDisplay(BuildContext context) {
    return Obx(() {
      final color = controller.isIncome.value
          ? AppTheme.success
          : AppTheme.error;
      return Column(
        children: [
          Text('How much?', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\$',
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(color: color),
              ),
              const SizedBox(width: 4),
              Text(
                controller.amount.value,
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: 56, color: color),
              ),
            ],
          ),
        ],
      );
    });
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
      case 'music':
        return LucideIcons.music;
      case 'target':
        return LucideIcons.target;
      default:
        return LucideIcons.moreHorizontal;
    }
  }

  Widget _buildCategorySelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Obx(
          () => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: controller.currentCategories.map((cat) {
              final isSelected =
                  controller.selectedCategory.value == cat['name'];
              return GestureDetector(
                onTap: () => controller.selectedCategory.value = cat['name']!,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.divider,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconForName(cat['icon']!),
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        cat['name']!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelection(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            const Icon(
              LucideIcons.calendar,
              color: AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Obx(() {
              final date = controller.selectedDate.value;
              final now = DateTime.now();
              String dateText = DateFormat('MMM d, yyyy').format(date);
              if (date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day) {
                dateText = 'Today';
              } else if (date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day - 1) {
                dateText = 'Yesterday';
              }
              return Text(
                dateText,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textPrimary),
              );
            }),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteInput(BuildContext context) {
    return TextField(
      controller: controller.noteController,
      decoration: const InputDecoration(
        hintText: 'Add a note (optional)',
        prefixIcon: Icon(Icons.edit_outlined, color: AppTheme.textSecondary),
      ),
    );
  }

  Widget _buildKeypad(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32, top: 24),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKeypadButton(context, '1'),
              _buildKeypadButton(context, '2'),
              _buildKeypadButton(context, '3'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKeypadButton(context, '4'),
              _buildKeypadButton(context, '5'),
              _buildKeypadButton(context, '6'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKeypadButton(context, '7'),
              _buildKeypadButton(context, '8'),
              _buildKeypadButton(context, '9'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKeypadButton(context, '.'),
              _buildKeypadButton(context, '0'),
              _buildKeypadIconButton(
                context,
                LucideIcons.delete,
                controller.removeAmount,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.saveTransaction,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Save Transaction',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(BuildContext context, String text) {
    return Expanded(
      child: InkWell(
        onTap: () => controller.appendAmount(text),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadIconButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Icon(icon, color: AppTheme.textPrimary, size: 28),
        ),
      ),
    );
  }
}
