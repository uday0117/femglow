import 'package:femglow/app/data/models/period_entry.dart';
import 'package:femglow/app/data/services/cycle_service.dart';
import 'package:femglow/app/routes/app_routes.dart';
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
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

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

      // Close loading dialog
      Get.back();

      // Show success message with longer duration
      Get.snackbar(
        'Success',
        'Period logged successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );

      // Wait a moment for user to see snackbar, then go to home
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(
        AppRoutes.home,
      ); // Navigate to home and clear navigation stack
    } catch (e) {
      // Close loading dialog if it's open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'Failed to save period: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
