import 'package:flutter/material.dart';

/// Centralized color palette for the portfolio.
/// A deep indigo / teal accent pairing, tuned for a
/// "senior engineer" feel rather than a generic template look.
class AppColors {
  AppColors._();

  // Brand / accent
  static const Color primary = Color(0xFF6366F1); // Indigo (Premium)
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color secondary = Color(0xFF14B8A6); // Teal (Premium)

  // Light theme surfaces
  static const Color lightBackground = Color(0xFFF9FAFB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF3F4F6);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF4B5563);

  // Dark theme surfaces (Premium 2026 direction)
  static const Color darkBackground = Color(0xFF050505); // Near-black
  static const Color darkSurface = Color(0xFF0D0D0D); // Slightly lighter
  static const Color darkSurfaceAlt = Color(0xFF141414);
  static const Color darkBorder = Color(0xFF1F1F1F);
  static const Color darkTextPrimary = Color(0xFFFAFAFA);
  static const Color darkTextSecondary = Color(0xFFA3A3A3);

  // Status / utility
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  static const List<Color> heroGradientDark = [
    Color(0xFF0D0D0D),
    Color(0xFF050505),
  ];

  static const List<Color> accentGradient = [primary, secondary];
}
