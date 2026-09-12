import 'package:flutter/material.dart';

/// Breakpoints used consistently across the whole site.
///
///  mobile   : < 640
///  tablet   : 640 – 1023
///  laptop   : 1024 – 1439
///  desktop  : 1440 – 1919
///  ultrawide: >= 1920
class Breakpoints {
  Breakpoints._();

  static const double mobile = 640;
  static const double tablet = 1024;
  static const double laptop = 1440;
  static const double desktop = 1920;
}

enum DeviceType { mobile, tablet, laptop, desktop, ultrawide }

class Responsive {
  Responsive._();

  static DeviceType deviceTypeOf(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < Breakpoints.mobile) return DeviceType.mobile;
    if (width < Breakpoints.tablet) return DeviceType.tablet;
    if (width < Breakpoints.laptop) return DeviceType.laptop;
    if (width < Breakpoints.desktop) return DeviceType.desktop;
    return DeviceType.ultrawide;
  }

  static bool isCompactMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 380;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < Breakpoints.mobile;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= Breakpoints.mobile && w < Breakpoints.tablet;
  }

  static bool isDesktopOrWider(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

  /// True when the viewport is wide enough for the full horizontal navbar (>= 1150px).
  static bool isDesktopNavBar(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1150;

  /// Horizontal page padding that scales with viewport size.
  static double pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 380) return 16;
    if (width < Breakpoints.mobile) return 20;
    if (width < Breakpoints.tablet) return 32;
    if (width < Breakpoints.laptop) return 40;
    if (width < Breakpoints.desktop) return 64;
    return 80;
  }

  /// Caps content width on very large / ultrawide screens so text
  /// doesn't stretch edge-to-edge.
  static double maxContentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= Breakpoints.desktop) return 1320;
    return width;
  }

  /// Number of grid columns for cards (skills, projects, stats).
  static int gridColumns(BuildContext context, {int max = 3}) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < Breakpoints.mobile) return 1;
    if (width < Breakpoints.tablet) return 2;
    return max;
  }
}
