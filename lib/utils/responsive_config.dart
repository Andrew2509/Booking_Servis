import 'package:flutter/material.dart';
import 'breakpoints.dart';

class ResponsiveConfig {
  // Font sizes
  static double getTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isSmallScreen(width)) return 24;
    if (Breakpoints.isMediumScreen(width)) return 28;
    if (Breakpoints.isLargeScreen(width)) return 32;
    return 28;
  }

  static double getSubtitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isSmallScreen(width)) return 16;
    if (Breakpoints.isMediumScreen(width)) return 18;
    if (Breakpoints.isLargeScreen(width)) return 20;
    return 18;
  }

  static double getBodyFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isSmallScreen(width)) return 12;
    if (Breakpoints.isMediumScreen(width)) return 14;
    if (Breakpoints.isLargeScreen(width)) return 16;
    return 14;
  }

  static double getCaptionFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isSmallScreen(width)) return 10;
    if (Breakpoints.isMediumScreen(width)) return 11;
    if (Breakpoints.isLargeScreen(width)) return 12;
    return 11;
  }

  // Spacing
  static double getSmallSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isSmallScreen(width)) return 8;
    if (Breakpoints.isMediumScreen(width)) return 12;
    if (Breakpoints.isLargeScreen(width)) return 16;
    return 12;
  }

  static double getMediumSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isSmallScreen(width)) return 16;
    if (Breakpoints.isMediumScreen(width)) return 20;
    if (Breakpoints.isLargeScreen(width)) return 24;
    return 20;
  }

  static double getLargeSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isSmallScreen(width)) return 24;
    if (Breakpoints.isMediumScreen(width)) return 32;
    if (Breakpoints.isLargeScreen(width)) return 40;
    return 32;
  }

  // Button heights
  static double getButtonHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isSmallScreen(width)) return 44;
    if (Breakpoints.isMediumScreen(width)) return 48;
    if (Breakpoints.isLargeScreen(width)) return 52;
    return 48;
  }

  // Input field heights
  static double getInputHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isSmallScreen(width)) return 44;
    if (Breakpoints.isMediumScreen(width)) return 48;
    if (Breakpoints.isLargeScreen(width)) return 52;
    return 48;
  }

  // Padding
  static EdgeInsets getScreenPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isSmallScreen(width)) {
      return const EdgeInsets.all(16);
    } else if (Breakpoints.isMediumScreen(width)) {
      return const EdgeInsets.all(20);
    } else if (Breakpoints.isLargeScreen(width)) {
      return const EdgeInsets.all(24);
    }
    return const EdgeInsets.all(20);
  }

  // Container widths
  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isSmallScreen(width)) return width * 0.9;
    if (Breakpoints.isMediumScreen(width)) return width * 0.8;
    if (Breakpoints.isLargeScreen(width)) return 600;
    return width * 0.8;
  }
}
