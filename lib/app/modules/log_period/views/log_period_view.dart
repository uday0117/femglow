import 'package:femglow/app/core/values/app_colors.dart';
import 'package:femglow/app/core/values/app_strings.dart';
import 'package:femglow/app/modules/log_period/controllers/log_period_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LogPeriodView extends GetView<LogPeriodController> {
  const LogPeriodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.logPeriod), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Date
            _buildSectionTitle('Period Start Date'),
            const SizedBox(height: 12),
            _buildDateSelector(
              date: controller.startDate.value,
              onTap: () => _selectStartDate(context),
            ),
            const SizedBox(height: 24),

            // End Date
            _buildSectionTitle('Period End Date (Optional)'),
            const SizedBox(height: 12),
            Obx(
              () => _buildDateSelector(
                date: controller.endDate.value,
                onTap: () => _selectEndDate(context),
                isOptional: true,
              ),
            ),
            const SizedBox(height: 24),

            // Flow Intensity
            _buildSectionTitle('Flow Intensity'),
            const SizedBox(height: 12),
            Obx(() => _buildFlowSelector()),
            const SizedBox(height: 24),

            // Symptoms
            _buildSectionTitle('Symptoms (Optional)'),
            const SizedBox(height: 12),
            Obx(() => _buildSymptomsGrid()),
            const SizedBox(height: 24),

            // Notes
            _buildSectionTitle('Notes (Optional)'),
            const SizedBox(height: 12),
            _buildNotesField(),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.savePeriod,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Save Period',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDateSelector({
    required DateTime? date,
    required VoidCallback onTap,
    bool isOptional = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              date != null
                  ? DateFormat('MMM dd, yyyy').format(date)
                  : (isOptional ? 'Not set' : 'Select date'),
              style: TextStyle(
                fontSize: 16,
                color: date != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowSelector() {
    return Row(
      children: controller.flowOptions.map((option) {
        final isSelected = controller.flowIntensity.value == option;
        return Expanded(
          child: GestureDetector(
            onTap: () => controller.updateFlowIntensity(option),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  option.capitalize!,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSymptomsGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.symptomOptions.map((symptom) {
        final isSelected = controller.selectedSymptoms.contains(symptom);
        return GestureDetector(
          onTap: () => controller.toggleSymptom(symptom),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.3),
              ),
            ),
            child: Text(
              symptom,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotesField() {
    return TextField(
      controller: controller.notesController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Add any additional notes...',
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.startDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.updateStartDate(picked);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.endDate.value ?? controller.startDate.value,
      firstDate: controller.startDate.value,
      lastDate: DateTime.now(),
    );
    controller.updateEndDate(picked);
  }
}
