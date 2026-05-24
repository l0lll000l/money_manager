import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
          'Terms of Service',
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
              title: '1. Acceptance of Terms',
              content:
                  'By downloading, installing, or using the Aura application, you agree to be bound by these Terms of Service. If you do not agree, please do not use the application.',
            ),
            _buildSection(
              title: '2. Use of Service',
              content:
                  'AuraMoney is designed to help you track your personal finances. You agree to use the app responsibly and not for any unlawful or prohibited activities.',
            ),
            _buildSection(
              title: '3. Intellectual Property',
              content:
                  'All intellectual property rights in the application, including design, text, graphics, and underlying code, are owned by us. You may not copy, modify, or distribute any part of it without permission.',
            ),
            _buildSection(
              title: '4. Limitation of Liability',
              content:
                  'We are not liable for any financial decisions you make based on the analytics provided by this application. The app is a tool for personal tracking, not professional financial advice.',
            ),
            _buildSection(
              title: '5. Termination',
              content:
                  'We reserve the right to terminate or suspend your access to the application at any time without prior notice if you violate these terms.',
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
