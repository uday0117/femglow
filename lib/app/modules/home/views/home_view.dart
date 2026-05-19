import 'package:femglow/app/core/utils/responsive_util.dart';
import 'package:femglow/app/core/values/app_colors.dart';
import 'package:femglow/app/core/values/app_strings.dart';
import 'package:femglow/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveUtil.spacing(context, 20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context),
                SizedBox(height: ResponsiveUtil.spacing(context, 32)),

                // Main Cycle Card
                _buildCycleCard(context),
                SizedBox(height: ResponsiveUtil.spacing(context, 24)),

                // Quick Actions
                _buildQuickActions(context),
                SizedBox(height: ResponsiveUtil.spacing(context, 24)),

                // Status Cards
                _buildStatusCards(context),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.quickStartPeriod,
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.logPeriod),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello! 👋',
          style: TextStyle(
            fontSize: ResponsiveUtil.sp(context, 28),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtil.spacing(context, 8)),
        Text(
          controller.statusMessage,
          style: TextStyle(
            fontSize: ResponsiveUtil.sp(context, 16),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCycleCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtil.spacing(context, 24)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtil.radius(context, 20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cycle Day
          Text(
            controller.cycleDayText,
            style: TextStyle(
              fontSize: ResponsiveUtil.sp(context, 48),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveUtil.spacing(context, 8)),
          Text(
            'Current Cycle',
            style: TextStyle(
              fontSize: ResponsiveUtil.sp(context, 16),
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: ResponsiveUtil.spacing(context, 24)),
          // Divider
          Container(height: 1, color: Colors.white.withOpacity(0.3)),
          SizedBox(height: ResponsiveUtil.spacing(context, 24)),
          // Next Period
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.white.withOpacity(0.9),
                size: ResponsiveUtil.sp(context, 20),
              ),
              SizedBox(width: ResponsiveUtil.spacing(context, 8)),
              Text(
                'Next Period ${controller.nextPeriodText}',
                style: TextStyle(
                  fontSize: ResponsiveUtil.sp(context, 16),
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: ResponsiveUtil.sp(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtil.spacing(context, 16)),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.event,
                label: AppStrings.calendar,
                color: AppColors.secondary,
                onTap: controller.navigateToCalendar,
              ),
            ),
            SizedBox(width: ResponsiveUtil.spacing(context, 12)),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.insights,
                label: AppStrings.insights,
                color: AppColors.ovulation,
                onTap: controller.navigateToInsights,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveUtil.radius(context, 16)),
        child: Ink(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              ResponsiveUtil.radius(context, 16),
            ),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          padding: EdgeInsets.all(ResponsiveUtil.spacing(context, 20)),
          child: Column(
            children: [
              Icon(icon, color: color, size: ResponsiveUtil.sp(context, 32)),
              SizedBox(height: ResponsiveUtil.spacing(context, 8)),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveUtil.sp(context, 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Status',
          style: TextStyle(
            fontSize: ResponsiveUtil.sp(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtil.spacing(context, 16)),
        // Period Status
        _buildStatusItem(
          context,
          icon: Icons.favorite,
          label: 'Period Status',
          value: controller.isOnPeriod ? 'Active' : 'Not active',
          color: controller.isOnPeriod
              ? AppColors.primary
              : AppColors.textSecondary,
        ),
        SizedBox(height: ResponsiveUtil.spacing(context, 12)),
        // Fertile Window
        _buildStatusItem(
          context,
          icon: Icons.wb_sunny,
          label: 'Fertile Window',
          value: controller.isInFertileWindow ? 'Active' : 'Not active',
          color: controller.isInFertileWindow
              ? AppColors.ovulation
              : AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtil.spacing(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(ResponsiveUtil.radius(context, 12)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtil.spacing(context, 12)),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: ResponsiveUtil.sp(context, 24),
            ),
          ),
          SizedBox(width: ResponsiveUtil.spacing(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtil.sp(context, 14),
                  ),
                ),
                SizedBox(height: ResponsiveUtil.spacing(context, 4)),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: ResponsiveUtil.sp(context, 16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
