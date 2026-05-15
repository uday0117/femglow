import 'package:femglow/app/core/utils/responsive_util.dart';
import 'package:femglow/app/core/values/app_colors.dart';
import 'package:femglow/app/core/values/app_strings.dart';
import 'package:femglow/app/modules/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon/Logo
            Container(
              width: ResponsiveUtil.spacing(context, 120),
              height: ResponsiveUtil.spacing(context, 120),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveUtil.radius(context, 30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite,
                size: ResponsiveUtil.sp(context, 60),
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: ResponsiveUtil.spacing(context, 24)),
            // App Name
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: ResponsiveUtil.sp(context, 36),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: ResponsiveUtil.spacing(context, 8)),
            // Tagline
            Text(
              AppStrings.appTagline,
              style: TextStyle(
                fontSize: ResponsiveUtil.sp(context, 16),
                color: Colors.white70,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: ResponsiveUtil.spacing(context, 48)),
            // Loading Indicator
            SizedBox(
              width: ResponsiveUtil.spacing(context, 40),
              height: ResponsiveUtil.spacing(context, 40),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
