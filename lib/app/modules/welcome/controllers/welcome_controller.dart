import 'package:femglow/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingInfo {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingInfo({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class WelcomeController extends GetxController {
  final storage = GetStorage();
  final currentPage = 0.obs;
  final pageController = PageController();

  final List<OnboardingInfo> onboardingPages = [
    OnboardingInfo(
      title: 'Track Your Period',
      description:
          'Log your period dates and flow intensity with ease. Get insights into your menstrual health.',
      icon: Icons.calendar_today,
      color: const Color(0xFFFF5C8A),
    ),
    OnboardingInfo(
      title: 'Predict Ovulation',
      description:
          'Get accurate predictions for your fertile window and ovulation day based on your cycle.',
      icon: Icons.favorite,
      color: const Color(0xFF9C27B0),
    ),
    OnboardingInfo(
      title: 'Stay Informed',
      description:
          'Receive timely reminders and track your mood, symptoms, and overall wellness.',
      icon: Icons.notifications_active,
      color: const Color(0xFFFFB6C1),
    ),
  ];

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() {
    storage.write('has_seen_welcome', true);
    Get.offAllNamed(AppRoutes.home);
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
