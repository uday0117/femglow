import 'package:femglow/app/modules/splash/bindings/splash_binding.dart';
import 'package:femglow/app/modules/splash/views/splash_view.dart';
import 'package:femglow/app/modules/welcome/bindings/welcome_binding.dart';
import 'package:femglow/app/modules/welcome/views/welcome_view.dart';
import 'package:femglow/app/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
  ];
}
