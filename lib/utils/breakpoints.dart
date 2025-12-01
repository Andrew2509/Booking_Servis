class Breakpoints {
  // Mobile breakpoints
  static const double mobileSmall = 360;
  static const double mobileMedium = 400;
  static const double mobileLarge = 480;

  // Tablet breakpoints
  static const double tabletSmall = 600;
  static const double tabletMedium = 768;
  static const double tabletLarge = 900;

  // Desktop breakpoints
  static const double desktopSmall = 1024;
  static const double desktopMedium = 1200;
  static const double desktopLarge = 1440;

  // Helper methods
  static bool isMobile(double width) => width < tabletSmall;
  static bool isTablet(double width) =>
      width >= tabletSmall && width < desktopSmall;
  static bool isDesktop(double width) => width >= desktopSmall;

  static bool isSmallScreen(double width) => width < mobileMedium;
  static bool isMediumScreen(double width) =>
      width >= mobileMedium && width < tabletMedium;
  static bool isLargeScreen(double width) => width >= tabletMedium;
}
