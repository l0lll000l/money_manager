import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final pages = [
    {
      'title': 'Track Every Penny',
      'description': 'Keep an eye on your spending with beautiful charts and insights.',
      'icon': LucideIcons.pieChart,
    },
    {
      'title': 'Smart Budgets',
      'description': 'Set monthly budgets and let Aura notify you before you overspend.',
      'icon': LucideIcons.target,
    },
    {
      'title': 'Total Control',
      'description': 'Offline first. Your data stays on your device. Secure and fast.',
      'icon': LucideIcons.shieldCheck,
    },
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    Get.offAllNamed(AppRoutes.main);
  }

  void next() {
    if (currentPage.value == pages.length - 1) {
      _completeOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void skip() {
    _completeOnboarding();
  }
}
