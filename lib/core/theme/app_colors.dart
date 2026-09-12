import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand / Accents
  static const Color primary = Color(0xFF6366F1); // Indigo Primary
  static const Color secondary = Color(0xFF06B6D4); // Cyan Pulse
  static const Color accent = Color(0xFFA855F7); // Neon Purple
  static const Color androidGreen = Color(0xFF3DDC84); // Kotlin / Android Green
  static const Color flutterBlue = Color(0xFF38BDF8); // Flutter Electric Sky
  static const Color emerald = Color(0xFF10B981); // Emerald Success
  static const Color amber = Color(0xFFF59E0B); // Warm Gold

  // Light Theme Surfaces (Clean Apple-Style Porcelain)
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Dark Theme Surfaces (Deep Space Glass Obsidian)
  static const Color darkBackground = Color(0xFF07090E);
  static const Color darkSurface = Color(0xFF0F121C);
  static const Color darkSurfaceAlt = Color(0xFF161B29);
  static const Color darkBorder = Color(0xFF1E2436);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // High Impact Gradients
  static const List<Color> primaryGradient = [Color(0xFF6366F1), Color(0xFF06B6D4)];
  static const List<Color> heroTitleGradient = [Color(0xFFF8FAFC), Color(0xFF818CF8), Color(0xFF38BDF8)];
  static const List<Color> heroTitleGradientLight = [Color(0xFF0F172A), Color(0xFF4F46E5), Color(0xFF0284C7)];
  static const List<Color> accentGradient = [Color(0xFFA855F7), Color(0xFFEC4899)];
  static const List<Color> androidGradient = [Color(0xFF3DDC84), Color(0xFF10B981)];
  static const List<Color> flutterGradient = [Color(0xFF02569B), Color(0xFF38BDF8)];
}
