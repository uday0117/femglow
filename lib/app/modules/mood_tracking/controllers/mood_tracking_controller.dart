import 'package:femglow/app/data/models/mood_entry.dart';
import 'package:femglow/app/data/services/mood_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoodTrackingController extends GetxController {
  final moodService = Get.find<MoodService>();

  final selectedMood = ''.obs;
  final selectedEmotions = <String>[].obs;
  final notesController = TextEditingController();
  final selectedDate = DateTime.now().obs;

  final availableMoods = [
    {'value': 'great', 'emoji': '😄', 'label': 'Great'},
    {'value': 'good', 'emoji': '🙂', 'label': 'Good'},
    {'value': 'okay', 'emoji': '😐', 'label': 'Okay'},
    {'value': 'bad', 'emoji': '😞', 'label': 'Bad'},
    {'value': 'terrible', 'emoji': '😢', 'label': 'Terrible'},
  ];

  final availableEmotions = [
    'Happy',
    'Sad',
    'Anxious',
    'Energetic',
    'Tired',
    'Irritable',
    'Calm',
    'Stressed',
    'Excited',
    'Lonely',
    'Content',
    'Overwhelmed',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadExistingMood();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  void _loadExistingMood() {
    final existingMood = moodService.getMoodForDate(selectedDate.value);
    if (existingMood != null) {
      selectedMood.value = existingMood.mood;
      selectedEmotions.value = existingMood.emotions;
      notesController.text = existingMood.notes ?? '';
    }
  }

  void selectMood(String mood) {
    selectedMood.value = mood;
  }

  void toggleEmotion(String emotion) {
    if (selectedEmotions.contains(emotion)) {
      selectedEmotions.remove(emotion);
    } else {
      selectedEmotions.add(emotion);
    }
  }

  Future<void> saveMood() async {
    if (selectedMood.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a mood',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final existingMood = moodService.getMoodForDate(selectedDate.value);

    if (existingMood != null) {
      // Update existing mood
      final updatedMood = existingMood.copyWith(
        mood: selectedMood.value,
        emotions: selectedEmotions.toList(),
        notes: notesController.text.isNotEmpty ? notesController.text : null,
      );
      await moodService.updateMood(updatedMood);
    } else {
      // Create new mood
      final newMood = MoodEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: selectedDate.value,
        mood: selectedMood.value,
        emotions: selectedEmotions.toList(),
        notes: notesController.text.isNotEmpty ? notesController.text : null,
      );
      await moodService.addMood(newMood);
    }

    Get.snackbar(
      'Success',
      'Mood saved successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.back();
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
      _loadExistingMood();
    }
  }
}
