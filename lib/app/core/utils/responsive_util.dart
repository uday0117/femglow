import 'package:flutter/material.dart';

/// Responsive utility for adaptive sizing across different screen sizes
class ResponsiveUtil {
  /// Get screen width
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get responsive width based on percentage
  /// [percentage] should be between 0.0 and 1.0
  static double wp(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage / 100;
  }

  /// Get responsive height based on percentage
  /// [percentage] should be between 0.0 and 1.0
  static double hp(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage / 100;
  }

  /// Get responsive font size
  /// Base size is calculated for a 375px width screen (iPhone SE)
  static double sp(BuildContext context, double fontSize) {
    final width = MediaQuery.of(context).size.width;
    return fontSize * (width / 375);
  }

  /// Get responsive spacing/padding
  /// Base size is calculated for a 375px width screen
  static double spacing(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return size * (width / 375);
  }

  /// Check if device is tablet (width > 600px)
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  /// Check if device is desktop (width > 1200px)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  /// Check if device is mobile (width <= 600px)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= 600;
  }

  /// Get responsive border radius
  static double radius(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return size * (width / 375);
  }

  /// Get text scale factor
  static double textScale(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }
}
