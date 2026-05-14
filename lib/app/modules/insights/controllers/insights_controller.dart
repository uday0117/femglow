import 'package:femglow/app/data/services/cycle_service.dart';
import 'package:femglow/app/data/services/mood_service.dart';
import 'package:femglow/app/data/services/symptom_service.dart';
import 'package:get/get.dart';

class InsightsController extends GetxController {
  final cycleService = Get.find<CycleService>();
  final moodService = Get.find<MoodService>();
  final symptomService = Get.find<SymptomService>();

  final selectedPeriod = 30.obs; // Days to analyze

  // Cycle insights
  RxInt get averageCycleLength =>
      cycleService.cycleData.value.averageCycleLength.obs;
  RxInt get averagePeriodLength =>
      cycleService.cycleData.value.averagePeriodLength.obs;
  RxInt get totalCycles => cycleService.cycleData.value.periods.length.obs;

  // Get cycle length history for chart
  List<Map<String, dynamic>> getCycleLengthHistory() {
    final periods = cycleService.cycleData.value.periods;
    if (periods.length < 2) return [];

    final sortedPeriods = List.from(periods)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final history = <Map<String, dynamic>>[];
    for (int i = 1; i < sortedPeriods.length; i++) {
      final cycleLength = sortedPeriods[i].startDate
          .difference(sortedPeriods[i - 1].startDate)
          .inDays;

      if (cycleLength >= 21 && cycleLength <= 35) {
        history.add({
          'cycle': i,
          'length': cycleLength,
          'date': sortedPeriods[i].startDate,
        });
      }
    }

    return history;
  }

  // Get period length history for chart
  List<Map<String, dynamic>> getPeriodLengthHistory() {
    final periods = cycleService.cycleData.value.periods
        .where((p) => p.endDate != null)
        .toList();

    final sortedPeriods = List.from(periods)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    return sortedPeriods.asMap().entries.map((entry) {
      return {
        'period': entry.key + 1,
        'length': entry.value.periodLength,
        'date': entry.value.startDate,
      };
    }).toList();
  }

  // Get mood distribution
  Map<String, int> getMoodDistribution() {
    return moodService.getMoodStatistics(days: selectedPeriod.value);
  }

  // Get common emotions
  Map<String, int> getCommonEmotions() {
    return moodService.getEmotionFrequency(days: selectedPeriod.value);
  }

  // Get symptom frequency
  Map<String, int> getSymptomFrequency() {
    return symptomService.getSymptomFrequency(days: selectedPeriod.value);
  }

  // Get most common symptoms
  List<String> getMostCommonSymptoms() {
    return symptomService.getMostCommonSymptoms(
      days: selectedPeriod.value,
      limit: 5,
    );
  }

  void changePeriod(int days) {
    selectedPeriod.value = days;
  }
}
