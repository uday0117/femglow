import 'package:femglow/app/core/values/app_colors.dart';
import 'package:femglow/app/core/values/app_strings.dart';
import 'package:femglow/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: controller.skipOnboarding,
                  child: Text(
                    AppStrings.skip,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.onboardingPages.length,
                itemBuilder: (context, index) {
                  final page = controller.onboardingPages[index];
                  return _buildOnboardingPage(page);
                },
              ),
            ),

            // Page Indicators
            Obx(() => _buildPageIndicators()),

            const SizedBox(height: 32),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    if (controller.currentPage.value > 0)
                      TextButton(
                        onPressed: controller.previousPage,
                        child: const Text('Back'),
                      )
                    else
                      const SizedBox(width: 60),

                    // Next/Get Started Button
                    ElevatedButton(
                      onPressed: controller.nextPage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: Text(
                        controller.currentPage.value ==
                                controller.onboardingPages.length - 1
                            ? AppStrings.getStarted
                            : AppStrings.next,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingInfo page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 80, color: page.color),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller.onboardingPages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: controller.currentPage.value == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: controller.currentPage.value == index
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
