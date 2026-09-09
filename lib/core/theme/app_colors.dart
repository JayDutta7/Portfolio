import 'package:flutter/material.dart';

/// Centralized color palette for the portfolio.
/// A deep indigo / teal accent pairing, tuned for a
/// "senior engineer" feel rather than a generic template look.
class AppColors {
  AppColors._();

  // Brand / accent
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color secondary = Color(0xFF14B8A6); // Teal
  static const Color accent = Color(0xFF6366F1); // Primary Accent

  // Light theme surfaces
  static const Color lightBackground = Color(0xFFFAFAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF1F2F8);
  static const Color lightBorder = Color(0xFFE4E6EF);
  static const Color lightTextPrimary = Color(0xFF161821);
  static const Color lightTextSecondary = Color(0xFF5B5F73);

  // Dark theme surfaces (Premium 2026 direction - Product Focus)
  static const Color darkBackground = Color(0xFF0A0A0B); // Near-black (Updated)
  static const Color darkSurface = Color(0xFF111113); // Slightly lighter
  static const Color darkSurfaceAlt = Color(0xFF151517);
  static const Color darkBorder = Color(0xFF1F1F21);
  static const Color darkTextPrimary = Color(0xFFFAFAFA);
  static const Color darkTextSecondary = Color(0xFF888888); // More muted for secondary

  // Status / utility
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  static const List<Color> heroGradientDark = [
    Color(0xFF0A0A0B),
    Color(0xFF111113),
  ];

  static const List<Color> accentGradient = [primary, secondary];
}
