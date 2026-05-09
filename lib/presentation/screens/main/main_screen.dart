import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../routes/app_pages.dart';
import '../dashboard/dashboard_screen.dart';
import '../analytics/analytics_screen.dart';
import '../budget/budget_screen.dart';
import '../settings/settings_screen.dart';
import 'main_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());

    final screens = [
      DashboardScreen(),
      const AnalyticsScreen(),
      const BudgetScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: screens,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.addTransaction);
        },
        backgroundColor: AppTheme.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(LucideIcons.plus, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() => _buildBottomNavBar(controller)),
    );
  }

  Widget _buildBottomNavBar(MainController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.9),
        border: const Border(
          top: BorderSide(color: AppTheme.divider, width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, LucideIcons.layoutDashboard, 'Home', controller),
              _buildNavItem(1, LucideIcons.pieChart, 'Analytics', controller),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(2, LucideIcons.target, 'Budget', controller),
              _buildNavItem(3, LucideIcons.settings, 'Settings', controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    MainController controller,
  ) {
    final isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
