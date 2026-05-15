import 'package:femglow/app/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    debugPrint('✅ SplashController onInit called');
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('✅ SplashController onReady called');
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    debugPrint('🔄 Starting navigation delay...');
    // Shorter delay since native splash is now handled properly
    await Future.delayed(const Duration(milliseconds: 1500));
    debugPrint('✅ Delay completed');

    try {
      // Check if user has completed onboarding
      final bool hasSeenWelcome = storage.read('has_seen_welcome') ?? false;
      debugPrint('📱 has_seen_welcome: $hasSeenWelcome');

      if (hasSeenWelcome) {
        debugPrint('🏠 Navigating to home...');
        // Navigate to home
        Get.offAllNamed(AppRoutes.home);
      } else {
        debugPrint('👋 Navigating to welcome...');
        // Navigate to welcome/onboarding
        Get.offAllNamed(AppRoutes.welcome);
      }
      debugPrint('✅ Navigation completed');
    } catch (e) {
      debugPrint('❌ Error during navigation: $e');
      // Fallback to welcome if any error occurs
      Get.offAllNamed(AppRoutes.welcome);
    }
  }
}
