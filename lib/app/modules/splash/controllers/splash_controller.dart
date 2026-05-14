import 'package:femglow/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));

    // Check if user has completed onboarding
    final bool hasSeenWelcome = storage.read('has_seen_welcome') ?? false;

    if (hasSeenWelcome) {
      // Navigate to home (will be implemented later)
      Get.offAllNamed(AppRoutes.welcome);
    } else {
      // Navigate to welcome/onboarding
      Get.offAllNamed(AppRoutes.welcome);
    }
  }
}
