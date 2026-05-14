import 'package:femglow/app/modules/calendar/bindings/calendar_binding.dart';
import 'package:femglow/app/modules/calendar/views/calendar_view.dart';
import 'package:femglow/app/modules/home/bindings/home_binding.dart';
import 'package:femglow/app/modules/home/views/home_view.dart';
import 'package:femglow/app/modules/insights/bindings/insights_binding.dart';
import 'package:femglow/app/modules/insights/views/insights_view.dart';
import 'package:femglow/app/modules/log_period/bindings/log_period_binding.dart';
import 'package:femglow/app/modules/log_period/views/log_period_view.dart';
import 'package:femglow/app/modules/mood_tracking/bindings/mood_tracking_binding.dart';
import 'package:femglow/app/modules/mood_tracking/views/mood_tracking_view.dart';
import 'package:femglow/app/modules/profile/bindings/profile_binding.dart';
import 'package:femglow/app/modules/profile/views/profile_view.dart';
import 'package:femglow/app/modules/settings/bindings/settings_binding.dart';
import 'package:femglow/app/modules/settings/views/settings_view.dart';
import 'package:femglow/app/modules/splash/bindings/splash_binding.dart';
import 'package:femglow/app/modules/splash/views/splash_view.dart';
import 'package:femglow/app/modules/symptom_tracking/bindings/symptom_tracking_binding.dart';
import 'package:femglow/app/modules/symptom_tracking/views/symptom_tracking_view.dart';
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
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.logPeriod,
      page: () => const LogPeriodView(),
      binding: LogPeriodBinding(),
    ),
    GetPage(
      name: AppRoutes.calendar,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: AppRoutes.insights,
      page: () => const InsightsView(),
      binding: InsightsBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.moodTracking,
      page: () => const MoodTrackingView(),
      binding: MoodTrackingBinding(),
    ),
    GetPage(
      name: AppRoutes.symptomTracking,
      page: () => const SymptomTrackingView(),
      binding: SymptomTrackingBinding(),
    ),
  ];
}
