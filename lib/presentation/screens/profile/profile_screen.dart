import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppTheme.background,
            expandedHeight: 280.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: controller.editProfile,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Account Details'),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    children: [
                      _buildInfoRow(Icons.person_outline, 'Name', controller.userName.value),
                      _buildDivider(),
                      _buildInfoRow(Icons.email_outlined, 'Email', controller.email.value),
                      _buildDivider(),
                      _buildInfoRow(Icons.phone_outlined, 'Phone', '+1 234 567 8900'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Financial Summary'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildSummaryCard('Total Balance', '\$24,562.00', AppTheme.primary)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildSummaryCard('Monthly Spent', '\$2,150.00', AppTheme.error)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Connected Accounts'),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    children: [
                      _buildBankRow('Chase Bank', '**** 1234', 'assets/icons/bank.png'), // Placeholder for bank icon
                      _buildDivider(),
                      _buildBankRow('Bank of America', '**** 5678', 'assets/icons/bank.png'),
                      _buildDivider(),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_circle_outline, color: AppTheme.primary),
                              SizedBox(width: 8),
                              Text('Add Account', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
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

  Widget _buildProfileHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.surfaceLight,
            AppTheme.background,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primary, width: 3),
                    image: const DecorationImage(
                      image: NetworkImage('https://i.pravatar.cc/300'), // Placeholder image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
              controller.userName.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )),
            const SizedBox(height: 4),
            Obx(() => Text(
              controller.email.value,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            )),
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
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBankRow(String name, String accountNum, String iconPath) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.account_balance, color: AppTheme.textSecondary),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              accountNum,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        const Spacer(),
        const Icon(Icons.more_vert, color: Colors.white54),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Divider(
        color: Colors.white.withValues(alpha: 0.1),
        height: 1,
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 8),
              Text(amount, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
