import 'package:femglow/app/data/models/user_profile.dart';
import 'package:femglow/app/data/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final profileService = Get.find<ProfileService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final name = ''.obs;
  final email = ''.obs;
  final dateOfBirth = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void _loadProfile() {
    final profile = profileService.profile.value;
    if (profile != null) {
      name.value = profile.name;
      email.value = profile.email ?? '';
      dateOfBirth.value = profile.dateOfBirth;

      nameController.text = profile.name;
      emailController.text = profile.email ?? '';
    }
  }

  Future<void> updateProfile() async {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final currentProfile = profileService.profile.value;
    final updatedProfile = currentProfile != null
        ? currentProfile.copyWith(
            name: nameController.text,
            email: emailController.text.isNotEmpty
                ? emailController.text
                : null,
            dateOfBirth: dateOfBirth.value,
          )
        : UserProfile(
            name: nameController.text,
            email: emailController.text.isNotEmpty
                ? emailController.text
                : null,
            dateOfBirth: dateOfBirth.value,
          );

    await profileService.updateProfile(updatedProfile);

    Get.snackbar(
      'Success',
      'Profile updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.back();
  }

  Future<void> selectDateOfBirth(BuildContext context) async {
    final initialDate = dateOfBirth.value ?? DateTime(2000, 1, 1);
    final firstDate = DateTime(1950);
    final lastDate = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      dateOfBirth.value = picked;
    }
  }
}
