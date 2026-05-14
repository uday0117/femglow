import 'package:femglow/app/data/models/period_entry.dart';
import 'package:femglow/app/data/services/cycle_service.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  final CycleService cycleService = Get.find<CycleService>();

  final focusedDay = Rx<DateTime>(DateTime.now());
  final selectedDay = Rx<DateTime>(DateTime.now());
  final calendarFormat = CalendarFormat.month.obs;

  // Get periods for date range
  List<PeriodEntry> getPeriodsForRange(DateTime start, DateTime end) {
    return cycleService.getPeriodsInRange(start, end);
  }

  // Check if date is period day
  bool isPeriodDay(DateTime date) {
    final periods = cycleService.cycleData.value.periods;
    return periods.any((period) {
      final startDate = DateTime(
        period.startDate.year,
        period.startDate.month,
        period.startDate.day,
      );
      final endDate = period.endDate != null
          ? DateTime(
              period.endDate!.year,
              period.endDate!.month,
              period.endDate!.day,
            )
          : startDate;

      final checkDate = DateTime(date.year, date.month, date.day);
      return checkDate.isAfterOrEqualTo(startDate) &&
          checkDate.isBeforeOrEqualTo(endDate);
    });
  }

  // Check if date is predicted period
  bool isPredictedPeriod(DateTime date) {
    final nextPeriodDate = cycleService.cycleData.value.nextPeriodDate;
    if (nextPeriodDate == null) return false;

    final avgPeriodLength = cycleService.cycleData.value.averagePeriodLength;
    final startDate = DateTime(
      nextPeriodDate.year,
      nextPeriodDate.month,
      nextPeriodDate.day,
    );
    final endDate = startDate.add(Duration(days: avgPeriodLength - 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    return checkDate.isAfterOrEqualTo(startDate) &&
        checkDate.isBeforeOrEqualTo(endDate);
  }

  // Check if date is ovulation
  bool isOvulationDay(DateTime date) {
    final ovulationDate = cycleService.cycleData.value.ovulationDate;
    if (ovulationDate == null) return false;

    final checkDate = DateTime(date.year, date.month, date.day);
    final ovDate = DateTime(
      ovulationDate.year,
      ovulationDate.month,
      ovulationDate.day,
    );
    return checkDate.isAtSameMomentAs(ovDate);
  }

  // Check if date is in fertile window
  bool isFertileWindowDay(DateTime date) {
    final fertileWindow = cycleService.cycleData.value.fertileWindow;
    if (fertileWindow == null) return false;

    final checkDate = DateTime(date.year, date.month, date.day);
    final startDate = DateTime(
      fertileWindow.start.year,
      fertileWindow.start.month,
      fertileWindow.start.day,
    );
    final endDate = DateTime(
      fertileWindow.end.year,
      fertileWindow.end.month,
      fertileWindow.end.day,
    );

    return checkDate.isAfterOrEqualTo(startDate) &&
        checkDate.isBeforeOrEqualTo(endDate);
  }

  // Update focused day
  void updateFocusedDay(DateTime day) {
    focusedDay.value = day;
  }

  // Update selected day
  void updateSelectedDay(DateTime day) {
    selectedDay.value = day;
  }

  // Update calendar format
  void updateCalendarFormat(CalendarFormat format) {
    calendarFormat.value = format;
  }

  // Get period for selected day
  PeriodEntry? getPeriodForDay(DateTime date) {
    final periods = cycleService.cycleData.value.periods;
    return periods.firstWhereOrNull((period) {
      final startDate = DateTime(
        period.startDate.year,
        period.startDate.month,
        period.startDate.day,
      );
      final endDate = period.endDate != null
          ? DateTime(
              period.endDate!.year,
              period.endDate!.month,
              period.endDate!.day,
            )
          : startDate;

      final checkDate = DateTime(date.year, date.month, date.day);
      return checkDate.isAfterOrEqualTo(startDate) &&
          checkDate.isBeforeOrEqualTo(endDate);
    });
  }
}

// Extension methods for date comparison
extension DateTimeExtension on DateTime {
  bool isAfterOrEqualTo(DateTime other) {
    return isAfter(other) || isAtSameMomentAs(other);
  }

  bool isBeforeOrEqualTo(DateTime other) {
    return isBefore(other) || isAtSameMomentAs(other);
  }
}
