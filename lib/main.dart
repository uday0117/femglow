import 'package:femglow/app/core/theme/app_theme.dart';
import 'package:femglow/app/core/values/app_strings.dart';
import 'package:femglow/app/data/services/cycle_service.dart';
import 'package:femglow/app/data/services/mood_service.dart';
import 'package:femglow/app/data/services/notification_service.dart';
import 'package:femglow/app/data/services/profile_service.dart';
import 'package:femglow/app/data/services/symptom_service.dart';
import 'package:femglow/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize timezone for notifications
  tz.initializeTimeZones();

  // Initialize services
  Get.put(CycleService());
  Get.put(MoodService());
  Get.put(SymptomService());
  Get.put(ProfileService());
  await Get.putAsync(() => NotificationService().init());

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
