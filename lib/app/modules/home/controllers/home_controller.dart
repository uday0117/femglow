import 'package:femglow/app/data/services/cycle_service.dart';
import 'package:femglow/app/routes/app_routes.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final CycleService cycleService = Get.find<CycleService>();

  // Get cycle information
  int? get currentCycleDay => cycleService.cycleData.value.currentCycleDay;
  int? get daysUntilNextPeriod =>
      cycleService.cycleData.value.daysUntilNextPeriod;
  bool get isOnPeriod => cycleService.isOnPeriod;
  bool get isInFertileWindow => cycleService.cycleData.value.isInFertileWindow;

  // Navigate to period logging
  void navigateToLogPeriod() {
    Get.toNamed(AppRoutes.logPeriod);
  }

  // Navigate to calendar
  void navigateToCalendar() {
    Get.toNamed(AppRoutes.calendar);
  }

  // Navigate to insights
  void navigateToInsights() {
    Get.toNamed(AppRoutes.insights);
  }

  // Quick action to start period
  void quickStartPeriod() async {
    navigateToLogPeriod();
  }

  // Format cycle day display
  String get cycleDayText {
    if (currentCycleDay == null) return 'Start tracking';
    return 'Day $currentCycleDay';
  }

  // Format next period text
  String get nextPeriodText {
    if (daysUntilNextPeriod == null) return 'Log your first period';
    if (daysUntilNextPeriod == 0) return 'Expected today';
    return 'in $daysUntilNextPeriod days';
  }

  // Get status message
  String get statusMessage {
    if (isOnPeriod) return 'Your period is active';
    if (isInFertileWindow) return 'You are in your fertile window';
    if (cycleService.cycleData.value.periods.isEmpty) {
      return 'Welcome! Start by logging your period';
    }
    return 'Track your cycle for better predictions';
  }
}
