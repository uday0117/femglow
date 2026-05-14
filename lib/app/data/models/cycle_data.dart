import 'package:femglow/app/data/models/period_entry.dart';

class CycleData {
  final List<PeriodEntry> periods;
  final int averageCycleLength; // days
  final int averagePeriodLength; // days

  CycleData({
    required this.periods,
    this.averageCycleLength = 28,
    this.averagePeriodLength = 5,
  });

  // Get the most recent period
  PeriodEntry? get lastPeriod {
    if (periods.isEmpty) return null;
    return periods.reduce((a, b) => a.startDate.isAfter(b.startDate) ? a : b);
  }

  // Get current cycle day (day 1 is first day of last period)
  int? get currentCycleDay {
    if (lastPeriod == null) return null;
    return DateTime.now().difference(lastPeriod!.startDate).inDays + 1;
  }

  // Predict next period start date
  DateTime? get nextPeriodDate {
    if (lastPeriod == null) return null;
    return lastPeriod!.startDate.add(Duration(days: averageCycleLength));
  }

  // Days until next period
  int? get daysUntilNextPeriod {
    if (nextPeriodDate == null) return null;
    final days = nextPeriodDate!.difference(DateTime.now()).inDays;
    return days < 0 ? 0 : days;
  }

  // Predict ovulation day (typically 14 days before next period)
  DateTime? get ovulationDate {
    if (nextPeriodDate == null) return null;
    return nextPeriodDate!.subtract(const Duration(days: 14));
  }

  // Calculate fertile window (5 days before ovulation + ovulation day)
  DateTimeRange? get fertileWindow {
    if (ovulationDate == null) return null;
    final start = ovulationDate!.subtract(const Duration(days: 5));
    return DateTimeRange(start: start, end: ovulationDate!);
  }

  // Check if currently in fertile window
  bool get isInFertileWindow {
    if (fertileWindow == null) return false;
    final now = DateTime.now();
    return now.isAfter(fertileWindow!.start) &&
        now.isBefore(fertileWindow!.end.add(const Duration(days: 1)));
  }

  // Calculate average cycle length from historical data
  int calculateAverageCycleLength() {
    if (periods.length < 2) return averageCycleLength;

    final sortedPeriods = List<PeriodEntry>.from(periods)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    int totalDays = 0;
    int count = 0;

    for (int i = 1; i < sortedPeriods.length; i++) {
      final cycleLength = sortedPeriods[i].startDate
          .difference(sortedPeriods[i - 1].startDate)
          .inDays;

      // Only count cycles between 21-35 days as valid
      if (cycleLength >= 21 && cycleLength <= 35) {
        totalDays += cycleLength;
        count++;
      }
    }

    return count > 0 ? (totalDays / count).round() : averageCycleLength;
  }

  // Calculate average period length from historical data
  int calculateAveragePeriodLength() {
    final completedPeriods = periods.where((p) => p.endDate != null).toList();
    if (completedPeriods.isEmpty) return averagePeriodLength;

    int totalDays = 0;
    for (var period in completedPeriods) {
      totalDays += (period.periodLength ?? 0);
    }

    return (totalDays / completedPeriods.length).round();
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'periods': periods.map((p) => p.toJson()).toList(),
      'averageCycleLength': averageCycleLength,
      'averagePeriodLength': averagePeriodLength,
    };
  }

  // Create from JSON
  factory CycleData.fromJson(Map<String, dynamic> json) {
    return CycleData(
      periods: (json['periods'] as List)
          .map((p) => PeriodEntry.fromJson(p))
          .toList(),
      averageCycleLength: json['averageCycleLength'] ?? 28,
      averagePeriodLength: json['averagePeriodLength'] ?? 5,
    );
  }

  // Create a copy with modified fields
  CycleData copyWith({
    List<PeriodEntry>? periods,
    int? averageCycleLength,
    int? averagePeriodLength,
  }) {
    return CycleData(
      periods: periods ?? this.periods,
      averageCycleLength: averageCycleLength ?? this.averageCycleLength,
      averagePeriodLength: averagePeriodLength ?? this.averagePeriodLength,
    );
  }
}

class DateTimeRange {
  final DateTime start;
  final DateTime end;

  DateTimeRange({required this.start, required this.end});
}
