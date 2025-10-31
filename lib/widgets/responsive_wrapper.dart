import 'package:flutter/material.dart';
import '../utils/breakpoints.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? smallScreen;
  final Widget? mediumScreen;
  final Widget? largeScreen;

  const ResponsiveWrapper({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.smallScreen,
    this.mediumScreen,
    this.largeScreen,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Priority: smallScreen > mediumScreen > largeScreen > mobile/tablet/desktop
    if (Breakpoints.isSmallScreen(screenWidth) && smallScreen != null) {
      return smallScreen!;
    }

    if (Breakpoints.isMediumScreen(screenWidth) && mediumScreen != null) {
      return mediumScreen!;
    }

    if (Breakpoints.isLargeScreen(screenWidth) && largeScreen != null) {
      return largeScreen!;
    }

    // Fallback to mobile/tablet/desktop
    if (Breakpoints.isDesktop(screenWidth) && desktop != null) {
      return desktop!;
    }

    if (Breakpoints.isTablet(screenWidth) && tablet != null) {
      return tablet!;
    }

    return mobile;
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    double screenWidth,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  )
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(screenWidth);
    final isTablet = Breakpoints.isTablet(screenWidth);
    final isDesktop = Breakpoints.isDesktop(screenWidth);

    return builder(context, screenWidth, isMobile, isTablet, isDesktop);
  }
}
