import 'package:femglow/app/core/values/app_colors.dart';
import 'package:femglow/app/core/values/app_strings.dart';
import 'package:femglow/app/modules/insights/controllers/insights_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InsightsView extends GetView<InsightsController> {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.insights),
        elevation: 0,
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.date_range),
            onSelected: controller.changePeriod,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 30, child: Text('Last 30 days')),
              const PopupMenuItem(value: 60, child: Text('Last 60 days')),
              const PopupMenuItem(value: 90, child: Text('Last 90 days')),
            ],
          ),
        ],
      ),
      body: Obx(() {
        // Check if there's enough data
        if (controller.totalCycles.value < 2) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.insights,
                    size: 80,
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Not Enough Data Yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Track your period for at least 2 cycles to see personalized insights and trends.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Summary Cards
            _buildSummaryCards(),

            const SizedBox(height: 24),

            // Cycle Length Chart
            _buildChartCard(
              title: 'Cycle Length Trend',
              child: _buildCycleLengthChart(),
            ),

            const SizedBox(height: 16),

            // Period Length Chart
            _buildChartCard(
              title: 'Period Length Trend',
              child: _buildPeriodLengthChart(),
            ),

            const SizedBox(height: 16),

            // Mood Distribution
            if (controller.getMoodDistribution().isNotEmpty)
              _buildChartCard(
                title: 'Mood Distribution',
                child: _buildMoodChart(),
              ),

            const SizedBox(height: 16),

            // Symptoms
            if (controller.getSymptomFrequency().isNotEmpty)
              _buildSymptomsCard(),

            const SizedBox(height: 16),

            // Common Emotions
            if (controller.getCommonEmotions().isNotEmpty) _buildEmotionsCard(),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Avg Cycle',
            '${controller.averageCycleLength.value} days',
            Icons.calendar_today,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Avg Period',
            '${controller.averagePeriodLength.value} days',
            Icons.water_drop,
            Colors.pink,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Cycles',
            '${controller.totalCycles.value}',
            Icons.repeat,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 200, child: child),
        ],
      ),
    );
  }

  Widget _buildCycleLengthChart() {
    final data = controller.getCycleLengthHistory();
    if (data.isEmpty) {
      return Center(
        child: Text(
          'Not enough data',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}d',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '#${value.toInt()}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map(
                  (e) => FlSpot(
                    (e.value['cycle'] as int).toDouble(),
                    (e.value['length'] as int).toDouble(),
                  ),
                )
                .toList(),
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withOpacity(0.1),
            ),
          ),
        ],
        minY: 21,
        maxY: 35,
      ),
    );
  }

  Widget _buildPeriodLengthChart() {
    final data = controller.getPeriodLengthHistory();
    if (data.isEmpty) {
      return Center(
        child: Text(
          'Not enough data',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return BarChart(
      BarChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}d',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '#${value.toInt() + 1}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data
            .asMap()
            .entries
            .map(
              (e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: (e.value['length'] as int).toDouble(),
                    color: Colors.pink,
                    width: 16,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
        maxY: 10,
      ),
    );
  }

  Widget _buildMoodChart() {
    final moodData = controller.getMoodDistribution();
    if (moodData.isEmpty) {
      return Center(
        child: Text(
          'No mood data available',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    final colors = {
      'great': Colors.green,
      'good': Colors.lightGreen,
      'okay': Colors.orange,
      'bad': Colors.deepOrange,
      'terrible': Colors.red,
    };

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: moodData.entries.map((entry) {
          final color = colors[entry.key] ?? AppColors.primary;
          return PieChartSectionData(
            value: entry.value.toDouble(),
            title: '${entry.value}',
            color: color,
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSymptomsCard() {
    final symptoms = controller.getMostCommonSymptoms();
    final frequency = controller.getSymptomFrequency();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Most Common Symptoms',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...symptoms.map((symptom) {
            final count = frequency[symptom] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      symptom,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '$count times',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmotionsCard() {
    final emotions = controller.getCommonEmotions();
    final topEmotions = emotions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final limitedEmotions = topEmotions.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Common Emotions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: limitedEmotions.map((entry) {
              return Chip(
                label: Text('${entry.key} (${entry.value})'),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
