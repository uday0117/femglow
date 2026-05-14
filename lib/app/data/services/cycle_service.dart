import 'package:femglow/app/data/models/cycle_data.dart';
import 'package:femglow/app/data/models/period_entry.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CycleService extends GetxService {
  final storage = GetStorage();
  late final Rx<CycleData> cycleData;

  @override
  void onInit() {
    super.onInit();
    _loadCycleData();
  }

  // Load cycle data from storage
  void _loadCycleData() {
    final data = storage.read('cycle_data');
    if (data != null) {
      cycleData = CycleData.fromJson(data).obs;
    } else {
      // Initialize with empty data
      cycleData = CycleData(periods: []).obs;
    }
  }

  // Save cycle data to storage
  Future<void> _saveCycleData() async {
    await storage.write('cycle_data', cycleData.value.toJson());
  }

  // Add a new period entry
  Future<void> addPeriod(PeriodEntry period) async {
    final periods = List<PeriodEntry>.from(cycleData.value.periods);
    periods.add(period);

    cycleData.value = cycleData.value.copyWith(periods: periods);
    await _updateAverages();
    await _saveCycleData();
  }

  // Update an existing period
  Future<void> updatePeriod(PeriodEntry updatedPeriod) async {
    final periods = cycleData.value.periods.map((p) {
      return p.id == updatedPeriod.id ? updatedPeriod : p;
    }).toList();

    cycleData.value = cycleData.value.copyWith(periods: periods);
    await _updateAverages();
    await _saveCycleData();
  }

  // Delete a period entry
  Future<void> deletePeriod(String periodId) async {
    final periods = cycleData.value.periods
        .where((p) => p.id != periodId)
        .toList();

    cycleData.value = cycleData.value.copyWith(periods: periods);
    await _updateAverages();
    await _saveCycleData();
  }

  // End current period
  Future<void> endCurrentPeriod(DateTime endDate) async {
    final currentPeriod = cycleData.value.periods.firstWhereOrNull(
      (p) => p.isOngoing,
    );

    if (currentPeriod != null) {
      await updatePeriod(currentPeriod.copyWith(endDate: endDate));
    }
  }

  // Get current ongoing period
  PeriodEntry? get currentPeriod {
    return cycleData.value.periods.firstWhereOrNull((p) => p.isOngoing);
  }

  // Check if currently on period
  bool get isOnPeriod => currentPeriod != null;

  // Update cycle averages based on historical data
  Future<void> _updateAverages() async {
    final avgCycleLength = cycleData.value.calculateAverageCycleLength();
    final avgPeriodLength = cycleData.value.calculateAveragePeriodLength();

    cycleData.value = cycleData.value.copyWith(
      averageCycleLength: avgCycleLength,
      averagePeriodLength: avgPeriodLength,
    );
  }

  // Get periods within a date range
  List<PeriodEntry> getPeriodsInRange(DateTime start, DateTime end) {
    return cycleData.value.periods.where((period) {
      return period.startDate.isAfter(
            start.subtract(const Duration(days: 1)),
          ) &&
          period.startDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Clear all data (for testing/reset)
  Future<void> clearAllData() async {
    cycleData.value = CycleData(periods: []);
    await storage.remove('cycle_data');
  }
}
