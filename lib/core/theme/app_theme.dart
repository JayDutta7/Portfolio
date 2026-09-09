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
            fontSize: 88,
            fontWeight: FontWeight.w800,
            height: 1.0,
            letterSpacing: -4.0,
            color: primaryText,
          ),
          displayMedium: GoogleFonts.plusJakartaSans(
            fontSize: 64,
            fontWeight: FontWeight.w800,
            height: 1.05,
            letterSpacing: -2.5,
            color: primaryText,
          ),
          displaySmall: GoogleFonts.plusJakartaSans(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: -1.5,
            color: primaryText,
          ),
          headlineLarge: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.0,
            color: primaryText,
          ),
          headlineMedium: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: primaryText,
          ),
          titleLarge: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: primaryText,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            color: primaryText,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 19,
            height: 1.6,
            color: secondaryText,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 16,
            height: 1.6,
            color: secondaryText,
          ),
          labelLarge: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: primaryText,
          ),
          labelSmall: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: FontWeight.w500,
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
      surfaceTint: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: _textTheme(
        AppColors.lightTextPrimary,
        AppColors.lightTextSecondary,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        color: AppColors.lightSurface,
      ),
      dividerColor: AppColors.lightBorder,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: AppColors.primary.withValues(alpha: 0.04),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
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
      surfaceTint: AppColors.primary,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: _textTheme(
        AppColors.darkTextPrimary,
        AppColors.darkTextSecondary,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        color: AppColors.darkSurface,
      ),
      dividerColor: AppColors.darkBorder,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: AppColors.secondary.withValues(alpha: 0.06),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
