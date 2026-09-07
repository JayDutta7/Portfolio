import 'package:flutter/material.dart';

/// Centralized color palette for the portfolio.
/// A deep indigo / teal accent pairing, tuned for a
/// "senior engineer" feel rather than a generic template look.
class AppColors {
  AppColors._();

  // Brand / accent
  static const Color primary = Color(0xFF3D5AFE); // Indigo accent
  static const Color primaryDark = Color(0xFF2A3EB1);
  static const Color secondary = Color(0xFF00BFA5); // Teal accent

  // Light theme surfaces
  static const Color lightBackground = Color(0xFFFAFAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF1F2F8);
  static const Color lightBorder = Color(0xFFE4E6EF);
  static const Color lightTextPrimary = Color(0xFF161821);
  static const Color lightTextSecondary = Color(0xFF5B5F73);

  // Dark theme surfaces
  static const Color darkBackground = Color(0xFF0B0D14);
  static const Color darkSurface = Color(0xFF12141F);
  static const Color darkSurfaceAlt = Color(0xFF181B29);
  static const Color darkBorder = Color(0xFF262A3C);
  static const Color darkTextPrimary = Color(0xFFF3F4F9);
  static const Color darkTextSecondary = Color(0xFFA6AABE);

  // Status / utility
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF5A623);

  static const List<Color> heroGradientLight = [
    Color(0xFFEEF0FF),
    Color(0xFFF7FAFF),
  ];

  static const List<Color> heroGradientDark = [
    Color(0xFF11132033),
    Color(0xFF0B0D14),
  ];

  static const List<Color> accentGradient = [primary, secondary];
}
