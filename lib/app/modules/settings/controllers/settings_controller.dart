import 'package:femglow/app/data/services/notification_service.dart';
import 'package:femglow/app/data/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final profileService = Get.find<ProfileService>();
  final notificationService = Get.find<NotificationService>();

  // Notification settings
  final notificationsEnabled = true.obs;
  final periodReminders = true.obs;
  final ovulationReminders = true.obs;
  final fertileWindowReminders = true.obs;

  // Theme
  final selectedTheme = 'system'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    final profile = profileService.profile.value;
    if (profile != null) {
      notificationsEnabled.value = profile.notificationsEnabled;
      periodReminders.value = profile.periodReminders;
      ovulationReminders.value = profile.ovulationReminders;
      fertileWindowReminders.value = profile.fertileWindowReminders;
      selectedTheme.value = profile.theme;
    }
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    await profileService.updateNotificationSettings(
      notificationsEnabled: value,
    );

    if (!value) {
      await notificationService.cancelAllNotifications();
    }
  }

  Future<void> togglePeriodReminders(bool value) async {
    periodReminders.value = value;
    await profileService.updateNotificationSettings(periodReminders: value);
  }

  Future<void> toggleOvulationReminders(bool value) async {
    ovulationReminders.value = value;
    await profileService.updateNotificationSettings(ovulationReminders: value);
  }

  Future<void> toggleFertileWindowReminders(bool value) async {
    fertileWindowReminders.value = value;
    await profileService.updateNotificationSettings(
      fertileWindowReminders: value,
    );
  }

  Future<void> updateTheme(String theme) async {
    selectedTheme.value = theme;
    await profileService.updateTheme(theme);
  }

  Future<void> clearAllData() async {
    // Show confirmation dialog first
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your tracked data including periods, moods, and symptoms. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Clear Data',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Clear all data logic
      // This would clear data from all services
    }
  }
}
