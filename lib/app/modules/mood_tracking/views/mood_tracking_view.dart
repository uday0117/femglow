import 'package:femglow/app/core/values/app_colors.dart';
import 'package:femglow/app/modules/mood_tracking/controllers/mood_tracking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoodTrackingView extends GetView<MoodTrackingController> {
  const MoodTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Mood'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selector
            Obx(
              () => InkWell(
                onTap: () => controller.selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('EEEE, MMM dd, yyyy')
                            .format(controller.selectedDate.value),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // How are you feeling?
            Text(
              'How are you feeling today?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            // Mood Selection
            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: controller.availableMoods.map((mood) {
                  final isSelected =
                      controller.selectedMood.value == mood['value'];
                  return GestureDetector(
                    onTap: () => controller.selectMood(mood['value'] as String),
                    child: Container(
                      width: 65,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            mood['emoji'] as String,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mood['label'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),

            // Emotions
            Text(
              'What emotions are you experiencing?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            // Emotion Chips
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.availableEmotions.map((emotion) {
                  final isSelected =
                      controller.selectedEmotions.contains(emotion);
                  return FilterChip(
                    label: Text(emotion),
                    selected: isSelected,
                    onSelected: (_) => controller.toggleEmotion(emotion),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    selectedColor: AppColors.primary.withOpacity(0.3),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),

            // Notes
            Text(
              'Notes (Optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: controller.notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add any additional notes about how you\'re feeling...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.saveMood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Mood',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
