import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import 'settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final controller = Get.put(SettingsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildSectionHeader('Preferences'),
            // const SizedBox(height: 16),
            // _buildSettingsCard(
            //   children: [
            // _buildStaticTile(
            //   icon: Icons.language,
            //   title: 'Language',
            //   value: 'English',
            // ),
            // _buildDivider(),
            // _buildSwitchTile(
            //   icon: Icons.dark_mode_outlined,
            //   title: 'Dark Theme',
            //   value: controller.darkThemeEnabled,
            //   onChanged: controller.toggleDarkTheme,
            // ),
            //   ],
            // ),

            // const SizedBox(height: 32),
            _buildSectionHeader('Notifications'),
            const SizedBox(height: 16),
            _buildSettingsCard(
              children: [
                _buildSwitchTile(
                  icon: Icons.notifications_none,
                  title: 'Push Notifications',
                  value: controller.notificationsEnabled,
                  onChanged: controller.toggleNotifications,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('About'),
            const SizedBox(height: 16),
            _buildSettingsCard(
              children: [
                _buildNavigationTile(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () => Get.toNamed('/help_support'),
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => Get.toNamed('/privacy_policy'),
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.info_outline,
                  title: 'Terms of Service',
                  onTap: () => Get.toNamed('/terms_of_service'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Center(
            //   child: TextButton.icon(
            //     onPressed: controller.logout,
            //     icon: const Icon(Icons.logout, color: AppTheme.error),
            //     label: const Text(
            //       'Log Out',
            //       style: TextStyle(
            //         color: AppTheme.error,
            //         fontSize: 16,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //     style: TextButton.styleFrom(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 24,
            //         vertical: 12,
            //       ),
            //       backgroundColor: AppTheme.error.withValues(alpha: 0.1),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(16),
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withValues(alpha: 0.05),
      height: 1,
      indent: 64,
      endIndent: 24,
    );
  }

  Widget _buildStaticTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildIconContainer(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required RxBool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          _buildIconContainer(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Obx(
            () => Switch(
              value: value.value,
              onChanged: onChanged,
              activeThumbColor: AppTheme.primary,
              activeTrackColor: AppTheme.primary.withValues(alpha: 0.5),
              inactiveThumbColor: Colors.white54,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            _buildIconContainer(icon),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppTheme.primary, size: 20),
    );
  }
}
