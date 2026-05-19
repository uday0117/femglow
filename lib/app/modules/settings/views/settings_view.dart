import 'package:femglow/app/core/values/app_colors.dart';
import 'package:femglow/app/modules/settings/controllers/settings_controller.dart';
import 'package:femglow/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: ListView(
        children: [
          // Profile Section
          _buildSectionHeader('Profile'),
          _buildListTile(
            icon: Icons.person,
            title: 'My Profile',
            onTap: () => Get.toNamed(AppRoutes.profile),
          ),

          const Divider(height: 32),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          Obx(
            () => _buildSwitchTile(
              icon: Icons.notifications,
              title: 'Enable Notifications',
              value: controller.notificationsEnabled.value,
              onChanged: controller.toggleNotifications,
            ),
          ),
          Obx(
            () => _buildSwitchTile(
              icon: Icons.event,
              title: 'Period Reminders',
              value: controller.periodReminders.value,
              onChanged: controller.togglePeriodReminders,
              enabled: controller.notificationsEnabled.value,
            ),
          ),
          Obx(
            () => _buildSwitchTile(
              icon: Icons.favorite,
              title: 'Ovulation Reminders',
              value: controller.ovulationReminders.value,
              onChanged: controller.toggleOvulationReminders,
              enabled: controller.notificationsEnabled.value,
            ),
          ),
          Obx(
            () => _buildSwitchTile(
              icon: Icons.calendar_today,
              title: 'Fertile Window Reminders',
              value: controller.fertileWindowReminders.value,
              onChanged: controller.toggleFertileWindowReminders,
              enabled: controller.notificationsEnabled.value,
            ),
          ),

          const Divider(height: 32),

          // Appearance Section
          _buildSectionHeader('Appearance'),
          Obx(
            () => _buildListTile(
              icon: Icons.palette,
              title: 'Theme',
              trailing: Text(
                controller.selectedTheme.value.capitalize!,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () => _showThemeDialog(context),
            ),
          ),

          const Divider(height: 32),

          // Data Section
          _buildSectionHeader('Data'),
          _buildListTile(
            icon: Icons.file_download,
            title: 'Export Data',
            onTap: () {
              Get.snackbar(
                'Coming Soon',
                'Data export feature will be available soon',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          _buildListTile(
            icon: Icons.delete_forever,
            title: 'Clear All Data',
            textColor: Colors.red,
            onTap: () => _showClearDataDialog(context),
          ),

          const Divider(height: 32),

          // About Section
          _buildSectionHeader('About'),
          _buildListTile(
            icon: Icons.info,
            title: 'About FemGlow',
            onTap: () {
              Get.snackbar(
                'FemGlow',
                'Version 1.0.1\nYour personal period tracking companion',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          _buildListTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () async {
              final url = Uri.parse(
                'https://uday0117.github.io/femglow/PRIVACY_POLICY.html',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                Get.snackbar(
                  'Error',
                  'Could not open Privacy Policy',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
          _buildListTile(
            icon: Icons.description,
            title: 'Terms & Conditions',
            onTap: () async {
              final url = Uri.parse(
                'https://uday0117.github.io/femglow/TERMS_AND_CONDITIONS.html',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                Get.snackbar(
                  'Error',
                  'Could not open Terms & Conditions',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.primary),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    bool enabled = true,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: enabled ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeThumbColor: AppColors.primary,
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('System', 'system'),
            _buildThemeOption('Light', 'light'),
            _buildThemeOption('Dark', 'dark'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  Widget _buildThemeOption(String label, String value) {
    return Obx(
      () => RadioListTile<String>(
        title: Text(label),
        value: value,
        groupValue: controller.selectedTheme.value,
        onChanged: (value) {
          if (value != null) {
            controller.updateTheme(value);
            Get.back();
          }
        },
        activeColor: AppColors.primary,
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your tracked data including periods, moods, and symptoms. This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back(result: true);
              controller.clearAllData();
            },
            child: const Text(
              'Clear Data',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
