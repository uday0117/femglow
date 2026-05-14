import 'package:femglow/app/core/values/app_colors.dart';
import 'package:femglow/app/core/values/app_strings.dart';
import 'package:femglow/app/modules/calendar/controllers/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.calendar), elevation: 0),
      body: Column(
        children: [
          // Calendar
          Obx(() => _buildCalendar()),

          // Legend
          _buildLegend(),

          // Selected Day Info
          Expanded(child: Obx(() => _buildSelectedDayInfo())),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: controller.focusedDay.value,
        selectedDayPredicate: (day) {
          return isSameDay(controller.selectedDay.value, day);
        },
        calendarFormat: controller.calendarFormat.value,
        onDaySelected: (selectedDay, focusedDay) {
          controller.updateSelectedDay(selectedDay);
          controller.updateFocusedDay(focusedDay);
        },
        onFormatChanged: (format) {
          controller.updateCalendarFormat(format);
        },
        onPageChanged: (focusedDay) {
          controller.updateFocusedDay(focusedDay);
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 1,
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            return _buildDayCell(day);
          },
          todayBuilder: (context, day, focusedDay) {
            return _buildDayCell(day, isToday: true);
          },
          selectedBuilder: (context, day, focusedDay) {
            return _buildDayCell(day, isSelected: true);
          },
        ),
      ),
    );
  }

  Widget _buildDayCell(
    DateTime day, {
    bool isToday = false,
    bool isSelected = false,
  }) {
    final isPeriod = controller.isPeriodDay(day);
    final isPredicted = controller.isPredictedPeriod(day);
    final isOvulation = controller.isOvulationDay(day);
    final isFertile = controller.isFertileWindowDay(day);

    Color? backgroundColor;
    Color? textColor;

    if (isSelected) {
      backgroundColor = AppColors.primary;
      textColor = Colors.white;
    } else if (isPeriod) {
      backgroundColor = AppColors.primary.withOpacity(0.8);
      textColor = Colors.white;
    } else if (isPredicted) {
      backgroundColor = AppColors.primary.withOpacity(0.3);
      textColor = AppColors.primary;
    } else if (isOvulation) {
      backgroundColor = AppColors.ovulation;
      textColor = Colors.white;
    } else if (isFertile) {
      backgroundColor = AppColors.fertile;
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = AppColors.primary.withOpacity(0.5);
      textColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: textColor ?? AppColors.textPrimary,
            fontWeight: isSelected || isPeriod
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(
                color: AppColors.primary.withOpacity(0.8),
                label: 'Period',
              ),
              _buildLegendItem(
                color: AppColors.primary.withOpacity(0.3),
                label: 'Predicted',
              ),
              _buildLegendItem(color: AppColors.ovulation, label: 'Ovulation'),
              _buildLegendItem(color: AppColors.fertile, label: 'Fertile'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildSelectedDayInfo() {
    final selectedDate = controller.selectedDay.value;
    final period = controller.getPeriodForDay(selectedDate);
    final isPeriod = controller.isPeriodDay(selectedDate);
    final isPredicted = controller.isPredictedPeriod(selectedDate);
    final isOvulation = controller.isOvulationDay(selectedDate);
    final isFertile = controller.isFertileWindowDay(selectedDate);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE, MMM dd, yyyy').format(selectedDate),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (isPeriod && period != null) ...[
            _buildInfoRow(
              icon: Icons.favorite,
              label: 'Period Day',
              color: AppColors.primary,
            ),
            if (period.flowIntensity.isNotEmpty)
              _buildInfoRow(
                icon: Icons.water_drop,
                label: 'Flow: ${period.flowIntensity.capitalize}',
                color: AppColors.primary,
              ),
            if (period.symptoms.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: period.symptoms
                      .map(
                        (s) => Chip(
                          label: Text(s, style: const TextStyle(fontSize: 12)),
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ),
            if (period.notes != null && period.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Notes: ${period.notes}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
          ] else if (isPredicted)
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Predicted Period',
              color: AppColors.primary.withOpacity(0.7),
            )
          else if (isOvulation)
            _buildInfoRow(
              icon: Icons.wb_sunny,
              label: 'Ovulation Day',
              color: AppColors.ovulation,
            )
          else if (isFertile)
            _buildInfoRow(
              icon: Icons.spa,
              label: 'Fertile Window',
              color: AppColors.fertile,
            )
          else
            Text(
              'No data for this day',
              style: TextStyle(color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
