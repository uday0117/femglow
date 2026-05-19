import 'package:femglow/app/core/values/app_colors.dart';
import 'package:femglow/app/modules/symptom_tracking/controllers/symptom_tracking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SymptomTrackingView extends GetView<SymptomTrackingController> {
  const SymptomTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Symptom Tracking'),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Log Symptom'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(children: [_buildLogTab(context), _buildHistoryTab()]),
      ),
    );
  }

  Widget _buildLogTab(BuildContext context) {
    return SingleChildScrollView(
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
                      DateFormat(
                        'EEEE, MMM dd, yyyy',
                      ).format(controller.selectedDate.value),
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

          // Symptom Selection
          Text(
            'Select Symptom',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.availableSymptoms.map((symptom) {
                final isSelected = controller.selectedSymptom.value == symptom;
                return FilterChip(
                  label: Text(symptom),
                  selected: isSelected,
                  onSelected: (_) => controller.selectSymptom(symptom),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  selectedColor: AppColors.primary.withOpacity(0.3),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 32),

          // Intensity Level
          Text(
            'Intensity Level',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          Obx(
            () => Row(
              children: controller.intensityLevels.map((level) {
                final isSelected =
                    controller.selectedIntensity.value == level['value'];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => controller.selectIntensity(
                          level['value'] as String,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
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
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Text(
                                level['color'] as String,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                level['label'] as String,
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
                      ),
                    ),
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
              hintText: 'Add any additional notes about this symptom...',
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
              onPressed: controller.saveSymptom,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Log Symptom',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Bottom padding to ensure button is always visible
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 40),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Obx(() {
      final symptoms = controller.getSymptomHistory();

      if (symptoms.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.healing,
                size: 80,
                color: AppColors.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No symptoms logged yet',
                style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: symptoms.length,
        itemBuilder: (context, index) {
          final symptom = symptoms[index];
          final intensityColor = symptom.intensity == 'mild'
              ? Colors.green
              : symptom.intensity == 'moderate'
              ? Colors.orange
              : Colors.red;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: intensityColor.withOpacity(0.2),
                child: Icon(Icons.healing, color: intensityColor),
              ),
              title: Text(
                symptom.symptom,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Intensity: ${symptom.intensity.capitalize}',
                    style: TextStyle(color: intensityColor),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(symptom.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (symptom.notes != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      symptom.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Delete Symptom'),
                      content: const Text(
                        'Are you sure you want to delete this symptom entry?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.deleteSymptom(symptom.id);
                            Get.back();
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    });
  }
}
