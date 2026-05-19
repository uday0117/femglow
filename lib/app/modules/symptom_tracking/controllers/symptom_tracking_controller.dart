import 'package:femglow/app/data/models/symptom_entry.dart';
import 'package:femglow/app/data/services/symptom_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SymptomTrackingController extends GetxController {
  final symptomService = Get.find<SymptomService>();

  final selectedSymptom = ''.obs;
  final selectedIntensity = ''.obs;
  final notesController = TextEditingController();
  final selectedDate = DateTime.now().obs;

  final availableSymptoms = [
    'Cramps',
    'Headache',
    'Backache',
    'Nausea',
    'Fatigue',
    'Bloating',
    'Breast Tenderness',
    'Acne',
    'Mood Swings',
    'Food Cravings',
    'Insomnia',
    'Dizziness',
  ];

  final intensityLevels = [
    {'value': 'mild', 'label': 'Mild', 'color': '🟢'},
    {'value': 'moderate', 'label': 'Moderate', 'color': '🟡'},
    {'value': 'severe', 'label': 'Severe', 'color': '🔴'},
  ];

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  void selectSymptom(String symptom) {
    selectedSymptom.value = symptom;
  }

  void selectIntensity(String intensity) {
    selectedIntensity.value = intensity;
  }

  Future<void> saveSymptom() async {
    if (selectedSymptom.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a symptom',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (selectedIntensity.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select intensity level',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final newSymptom = SymptomEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: selectedDate.value,
        symptom: selectedSymptom.value,
        intensity: selectedIntensity.value,
        notes: notesController.text.isNotEmpty ? notesController.text : null,
      );

      await symptomService.addSymptom(newSymptom);

      // Close loading dialog
      Get.back();

      Get.snackbar(
        'Success',
        'Symptom logged successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );

      // Wait a moment for user to see snackbar
      await Future.delayed(const Duration(milliseconds: 500));

      // Reset form
      selectedSymptom.value = '';
      selectedIntensity.value = '';
      notesController.clear();
    } catch (e) {
      // Close loading dialog if it's open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'Failed to log symptom: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  // Get symptoms for history view
  List<SymptomEntry> getSymptomHistory() {
    final symptoms = symptomService.symptoms.toList();
    symptoms.sort((a, b) => b.date.compareTo(a.date));
    return symptoms;
  }

  Future<void> deleteSymptom(String id) async {
    await symptomService.deleteSymptom(id);
  }
}
