import 'package:femglow/app/data/models/user_profile.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileService extends GetxService {
  final storage = GetStorage();
  late final Rx<UserProfile?> profile = Rx<UserProfile?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  // Load profile from storage
  void _loadProfile() {
    final data = storage.read('user_profile');
    if (data != null) {
      profile.value = UserProfile.fromJson(data);
    }
  }

  // Save profile to storage
  Future<void> _saveProfile() async {
    if (profile.value != null) {
      await storage.write('user_profile', profile.value!.toJson());
    }
  }

  // Update profile
  Future<void> updateProfile(UserProfile updatedProfile) async {
    profile.value = updatedProfile;
    await _saveProfile();
  }

  // Check if profile exists
  bool get hasProfile => profile.value != null;

  // Get user name
  String get userName => profile.value?.name ?? 'User';

  // Update specific profile fields
  Future<void> updateName(String name) async {
    if (profile.value != null) {
      await updateProfile(profile.value!.copyWith(name: name));
    }
  }

  Future<void> updateEmail(String email) async {
    if (profile.value != null) {
      await updateProfile(profile.value!.copyWith(email: email));
    }
  }

  Future<void> updateTheme(String theme) async {
    if (profile.value != null) {
      await updateProfile(profile.value!.copyWith(theme: theme));
    }
  }

  Future<void> updateNotificationSettings({
    bool? notificationsEnabled,
    bool? periodReminders,
    bool? ovulationReminders,
    bool? fertileWindowReminders,
  }) async {
    if (profile.value != null) {
      await updateProfile(
        profile.value!.copyWith(
          notificationsEnabled: notificationsEnabled,
          periodReminders: periodReminders,
          ovulationReminders: ovulationReminders,
          fertileWindowReminders: fertileWindowReminders,
        ),
      );
    }
  }
}
