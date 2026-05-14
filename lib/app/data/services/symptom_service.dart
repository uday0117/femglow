import 'package:femglow/app/data/models/symptom_entry.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SymptomService extends GetxService {
  final storage = GetStorage();
  final RxList<SymptomEntry> symptoms = <SymptomEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSymptoms();
  }

  // Load symptoms from storage
  void _loadSymptoms() {
    final data = storage.read<List>('symptoms');
    if (data != null) {
      symptoms.value = data.map((s) => SymptomEntry.fromJson(s)).toList();
    }
  }

  // Save symptoms to storage
  Future<void> _saveSymptoms() async {
    await storage.write('symptoms', symptoms.map((s) => s.toJson()).toList());
  }

  // Add a new symptom entry
  Future<void> addSymptom(SymptomEntry symptom) async {
    symptoms.add(symptom);
    await _saveSymptoms();
  }

  // Update an existing symptom
  Future<void> updateSymptom(SymptomEntry updatedSymptom) async {
    final index = symptoms.indexWhere((s) => s.id == updatedSymptom.id);
    if (index != -1) {
      symptoms[index] = updatedSymptom;
      await _saveSymptoms();
    }
  }

  // Delete a symptom entry
  Future<void> deleteSymptom(String symptomId) async {
    symptoms.removeWhere((s) => s.id == symptomId);
    await _saveSymptoms();
  }

  // Get symptoms within a date range
  List<SymptomEntry> getSymptomsInRange(DateTime start, DateTime end) {
    return symptoms.where((symptom) {
      return symptom.date.isAfter(start.subtract(const Duration(days: 1))) &&
          symptom.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Get symptoms for a specific date
  List<SymptomEntry> getSymptomsForDate(DateTime date) {
    return symptoms
        .where(
          (symptom) =>
              symptom.date.year == date.year &&
              symptom.date.month == date.month &&
              symptom.date.day == date.day,
        )
        .toList();
  }

  // Get symptom frequency
  Map<String, int> getSymptomFrequency({int days = 30}) {
    final startDate = DateTime.now().subtract(Duration(days: days));
    final recentSymptoms = getSymptomsInRange(startDate, DateTime.now());

    final frequency = <String, int>{};
    for (var symptom in recentSymptoms) {
      frequency[symptom.symptom] = (frequency[symptom.symptom] ?? 0) + 1;
    }

    return frequency;
  }

  // Get symptoms by intensity
  Map<String, List<SymptomEntry>> groupByIntensity({int days = 30}) {
    final startDate = DateTime.now().subtract(Duration(days: days));
    final recentSymptoms = getSymptomsInRange(startDate, DateTime.now());

    final grouped = <String, List<SymptomEntry>>{
      'mild': [],
      'moderate': [],
      'severe': [],
    };

    for (var symptom in recentSymptoms) {
      grouped[symptom.intensity]?.add(symptom);
    }

    return grouped;
  }

  // Get most common symptoms
  List<String> getMostCommonSymptoms({int days = 30, int limit = 5}) {
    final frequency = getSymptomFrequency(days: days);
    final sorted = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).map((e) => e.key).toList();
  }
}
