import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: AppTheme.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: '1. Information We Collect',
              content: 'When you use Aura Money Manager, we collect information you provide directly to us, such as your transactions, budgets, and categories. Since this is an offline-first app, this data is stored locally on your device.',
            ),
            _buildSection(
              title: '2. How We Use Your Data',
              content: 'Your data is strictly used to provide financial analytics and transaction tracking within the app. We do not sell, rent, or share your financial data with third parties.',
            ),
            _buildSection(
              title: '3. Data Security',
              content: 'We take data security seriously. While your data resides on your personal device, we recommend securing your device with a passcode or biometric authentication to protect your financial information.',
            ),
            _buildSection(
              title: '4. Changes to This Policy',
              content: 'We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page.',
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Last updated: May 2026',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
