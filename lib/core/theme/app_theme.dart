import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(Color primaryText, Color secondaryText) {
    final base = GoogleFonts.interTextTheme();
    return base
        .copyWith(
          displayLarge: GoogleFonts.plusJakartaSans(
            fontSize: 72,
            fontWeight: FontWeight.w800,
            height: 1.02,
            letterSpacing: -2.5,
            color: primaryText,
          ),
          displayMedium: GoogleFonts.plusJakartaSans(
            fontSize: 52,
            fontWeight: FontWeight.w800,
            height: 1.06,
            letterSpacing: -1.8,
            color: primaryText,
          ),
          displaySmall: GoogleFonts.plusJakartaSans(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: -1.2,
            color: primaryText,
          ),
          headlineLarge: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
            color: primaryText,
          ),
          headlineMedium: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            color: primaryText,
          ),
          titleLarge: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
          titleMedium: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: primaryText,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 17,
            height: 1.65,
            color: secondaryText,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 15,
            height: 1.6,
            color: secondaryText,
          ),
          labelLarge: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: primaryText,
          ),
          labelSmall: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: secondaryText,
          ),
        )
        .apply(bodyColor: secondaryText, displayColor: primaryText);
  }

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: _textTheme(AppColors.lightTextPrimary, AppColors.lightTextSecondary),
      dividerColor: AppColors.lightBorder,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        color: AppColors.lightSurface,
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: _textTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary),
      dividerColor: AppColors.darkBorder,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        color: AppColors.darkSurface,
      ),
    );
  }
}
