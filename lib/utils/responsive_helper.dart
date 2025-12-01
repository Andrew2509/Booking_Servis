import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isMobile(BuildContext context) {
    return getScreenWidth(context) < 600;
  }

  static bool isTablet(BuildContext context) {
    return getScreenWidth(context) >= 600 && getScreenWidth(context) < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return getScreenWidth(context) >= 1024;
  }

  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    double screenWidth = getScreenWidth(context);
    if (screenWidth < 360) {
      return baseFontSize * 0.8;
    } else if (screenWidth < 400) {
      return baseFontSize * 0.9;
    } else if (screenWidth > 600) {
      return baseFontSize * 1.2;
    }
    return baseFontSize;
  }

  static double getResponsivePaddingValue(
    BuildContext context,
    double basePadding,
  ) {
    double screenWidth = getScreenWidth(context);
    if (screenWidth < 360) {
      return basePadding * 0.8;
    } else if (screenWidth > 600) {
      return basePadding * 1.2;
    }
    return basePadding;
  }

  static double getResponsiveHeight(BuildContext context, double baseHeight) {
    double screenHeight = getScreenHeight(context);
    if (screenHeight < 600) {
      return baseHeight * 0.8;
    } else if (screenHeight > 800) {
      return baseHeight * 1.1;
    }
    return baseHeight;
  }

  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    double screenWidth = getScreenWidth(context);
    double multiplier =
        screenWidth < 360
            ? 0.8
            : screenWidth > 600
            ? 1.2
            : 1.0;

    return EdgeInsets.only(
      left: (left ?? horizontal ?? all ?? 0) * multiplier,
      top: (top ?? vertical ?? all ?? 0) * multiplier,
      right: (right ?? horizontal ?? all ?? 0) * multiplier,
      bottom: (bottom ?? vertical ?? all ?? 0) * multiplier,
    );
  }
}
