import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design System: "Linear / Vercel Dark Bento & Architecture Blueprint"
///
/// Implements Deep Obsidian canvas, Glassmorphic Slate cards,
/// Electric Cyan & Emerald accents, and typography driven by:
/// - Plus Jakarta Sans (Headings)
/// - Inter (Body)
/// - JetBrains Mono (Metrics, badges, and architecture blueprints)
class AppColors {
  AppColors._();

  // Canvas & Surfaces
  static const Color canvasBackground = Color(0xFF07090E); // Deep Obsidian
  static const Color cardSurface = Color(0xBF0F1624); // Glassmorphic Slate (75% opacity of #0F1624)
  static const Color cardSurfaceSolid = Color(0xFF0F1624);
  static const Color cardSurfaceElevated = Color(0xFF141D30);
  static const Color cardBorder = Color(0xFF1E293B); // Default 1px solid border
  static const Color cardBorderSubtle = Color(0xFF162032);

  // Technical Accents & Highlights
  static const Color electricCyan = Color(0xFF38BDF8); // Electric Cyan
  static const Color cyanGlow = Color(0xFF0EA5E9); // Ambient radial gradient cyan
  static const Color emerald = Color(0xFF10B981); // Emerald status & accent
  static const Color accentPurple = Color(0xFFA855F7); // Architecture Accent
  static const Color amber = Color(0xFFF59E0B); // Warning / Challenge Accent
  static const Color rose = Color(0xFFF43F5E);

  // Typography Tokens
  static const Color textPrimary = Color(0xFFF8FAFC); // Primary text
  static const Color textSecondary = Color(0xFF94A3B8); // Muted secondary text
  static const Color textMuted = Color(0xFF64748B); // Low-contrast technical annotations
  static const Color textCyan = Color(0xFF38BDF8);
  static const Color textEmerald = Color(0xFF10B981);

  // Backwards Compatibility Aliases
  static const Color primary = Color(0xFF38BDF8);
  static const Color secondary = Color(0xFF10B981);
  static const Color accent = Color(0xFFA855F7);
  static const Color androidGreen = Color(0xFF10B981);
  static const Color flutterBlue = Color(0xFF38BDF8);
  static const Color darkBackground = Color(0xFF07090E);
  static const Color darkSurface = Color(0xFF0F1624);
  static const Color darkSurfaceAlt = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color lightBackground = Color(0xFF07090E);
  static const Color lightSurface = Color(0xFF0F1624);
  static const Color lightSurfaceAlt = Color(0xFF1E293B);
  static const Color lightBorder = Color(0xFF1E293B);
  static const Color lightTextPrimary = Color(0xFFF8FAFC);
  static const Color lightTextSecondary = Color(0xFF94A3B8);

  // High-Impact Linear Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF38BDF8),
    Color(0xFF10B981),
  ];

  static const List<Color> cyanGradient = [
    Color(0xFF0EA5E9),
    Color(0xFF38BDF8),
  ];

  static const List<Color> emeraldGradient = [
    Color(0xFF059669),
    Color(0xFF10B981),
  ];

  static const List<Color> purpleGradient = [
    Color(0xFF7C3AED),
    Color(0xFFA855F7),
  ];

  static const List<Color> heroTitleGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFE2E8F0),
    Color(0xFF94A3B8),
  ];

  static const List<Color> heroTitleGradientLight = heroTitleGradient;
  static const List<Color> accentGradient = [Color(0xFF38BDF8), Color(0xFFA855F7)];
  static const List<Color> androidGradient = [Color(0xFF059669), Color(0xFF10B981)];
  static const List<Color> flutterGradient = [Color(0xFF0284C7), Color(0xFF38BDF8)];

  // Glassmorphism Box Decorations
  static BoxDecoration glassCardDecoration({
    Color? surfaceColor,
    Color? borderColor,
    double borderWidth = 1.0,
    double borderRadius = 20.0,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: surfaceColor ?? cardSurface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? cardBorder,
        width: borderWidth,
      ),
      boxShadow: shadows ??
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
    );
  }

  static List<BoxShadow> hoverGlowShadow(Color accentColor, {double blur = 24.0}) {
    return [
      BoxShadow(
        color: accentColor.withValues(alpha: 0.22),
        blurRadius: blur,
        spreadRadius: 1,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.5),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ];
  }
}

class AppTheme {
  AppTheme._();

  static TextTheme get textTheme {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      // Plus Jakarta Sans Headings
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -2.0,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -1.5,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -1.0,
        color: AppColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),

      // Inter Body
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      ),

      // JetBrains Mono for Metrics, Badges, Architecture Specs
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.textPrimary,
      ),
      labelMedium: GoogleFonts.jetBrainsMono(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.jetBrainsMono(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textMuted,
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.electricCyan,
      brightness: Brightness.dark,
      primary: AppColors.electricCyan,
      secondary: AppColors.emerald,
      surface: AppColors.cardSurfaceSolid,
      onSurface: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.canvasBackground,
      canvasColor: AppColors.canvasBackground,
      textTheme: textTheme,
      dividerColor: AppColors.cardBorder,
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.cardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.cardSurfaceSolid,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder),
        ),
        textStyle: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  // Linear dark is the authoritative visual theme; light maps gracefully to obsidian
  static ThemeData get light => dark;
}
