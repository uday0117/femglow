import 'package:femglow/app/data/models/period_entry.dart';
import 'package:femglow/app/data/services/cycle_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogPeriodController extends GetxController {
  final CycleService cycleService = Get.find<CycleService>();

  final startDate = Rx<DateTime>(DateTime.now());
  final endDate = Rx<DateTime?>(null);
  final flowIntensity = 'medium'.obs;
  final selectedSymptoms = <String>[].obs;
  final notesController = TextEditingController();

  final List<String> flowOptions = ['light', 'medium', 'heavy'];
  final List<String> symptomOptions = [
    'Cramps',
    'Headache',
    'Backache',
    'Bloating',
    'Fatigue',
    'Mood swings',
    'Breast tenderness',
    'Nausea',
  ];

  // Update start date
  void updateStartDate(DateTime date) {
    startDate.value = date;
  }

  // Update end date
  void updateEndDate(DateTime? date) {
    endDate.value = date;
  }

  // Update flow intensity
  void updateFlowIntensity(String intensity) {
    flowIntensity.value = intensity;
  }

  // Toggle symptom selection
  void toggleSymptom(String symptom) {
    if (selectedSymptoms.contains(symptom)) {
      selectedSymptoms.remove(symptom);
    } else {
      selectedSymptoms.add(symptom);
    }
  }

  // Validate and save period
  Future<void> savePeriod() async {
    // Validation
    if (endDate.value != null && endDate.value!.isBefore(startDate.value)) {
      Get.snackbar(
        'Invalid Date',
        'End date cannot be before start date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Create period entry
      final period = PeriodEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        startDate: startDate.value,
        endDate: endDate.value,
        flowIntensity: flowIntensity.value,
        symptoms: selectedSymptoms.toList(),
        notes: notesController.text.isNotEmpty ? notesController.text : null,
      );

      // Save to service
      await cycleService.addPeriod(period);

      // Show success message
      Get.snackbar(
        'Success',
        'Period logged successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Go back
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save period: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
