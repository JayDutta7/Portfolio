import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Ambient mesh background with rich, eye-catching aurora nebula glows,
/// cyber matrix grid, and batched GPU path rendering.
///
/// UI Optimized:
/// - Wrapped in [RepaintBoundary] with [isComplex: true] and [willChange: false]
///   so Flutter rasterizes the background into a GPU texture once, avoiding
///   any repainting during scrolling or UI animations.
/// - Batches all grid lines, accent lines, and crosshair reticles into single [Path]
///   objects to execute just 3-4 batched GPU draw calls instead of hundreds.
class AmbientMeshBackground extends StatelessWidget {
  const AmbientMeshBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        willChange: false,
        painter: _EyeCatchingMeshPainter(isDark: isDark),
      ),
    );
  }
}

class _EyeCatchingMeshPainter extends CustomPainter {
  final bool isDark;

  const _EyeCatchingMeshPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    if (isDark) {
      _paintNightMode(canvas, size);
    } else {
      _paintLightMode(canvas, size);
    }
  }

  /// Eye-Catching Night Mode: 4-Orb Aurora Nebula, Cyber Matrix Grid, Crosshairs & Depth Vignette
  void _paintNightMode(Canvas canvas, Size size) {
    // 1. Multi-Orb Aurora Nebula Glows
    // Orb 1: Cyan & Electric Blue glow behind Hero Orbit Avatar
    final orb1Center = Offset(size.width * 0.76, 220);
    final orb1Radius = (size.width * 0.42).clamp(360.0, 560.0);
    final orb1Paint = Paint()
      ..shader = ui.Gradient.radial(
        orb1Center,
        orb1Radius,
        [
          const Color(0xFF06B6D4).withValues(alpha: 0.22),
          const Color(0xFF3B82F6).withValues(alpha: 0.12),
          Colors.transparent,
        ],
        const [0.0, 0.45, 1.0],
      );
    canvas.drawCircle(orb1Center, orb1Radius, orb1Paint);

    // Orb 2: Royal Indigo & Violet glow behind Greeting & Hero Title
    final orb2Center = Offset(size.width * 0.20, 240);
    final orb2Radius = (size.width * 0.38).clamp(320.0, 500.0);
    final orb2Paint = Paint()
      ..shader = ui.Gradient.radial(
        orb2Center,
        orb2Radius,
        [
          const Color(0xFF8B5CF6).withValues(alpha: 0.20),
          const Color(0xFF6366F1).withValues(alpha: 0.10),
          Colors.transparent,
        ],
        const [0.0, 0.50, 1.0],
      );
    canvas.drawCircle(orb2Center, orb2Radius, orb2Paint);

    // Orb 3: Iridescent Magenta / Purple shimmer (Center/Mid)
    final orb3Center = Offset(size.width * 0.85, size.height * 0.54);
    final orb3Radius = (size.width * 0.35).clamp(300.0, 480.0);
    final orb3Paint = Paint()
      ..shader = ui.Gradient.radial(
        orb3Center,
        orb3Radius,
        [
          const Color(0xFFEC4899).withValues(alpha: 0.14),
          const Color(0xFFA855F7).withValues(alpha: 0.08),
          Colors.transparent,
        ],
        const [0.0, 0.48, 1.0],
      );
    canvas.drawCircle(orb3Center, orb3Radius, orb3Paint);

    // Orb 4: Emerald & Cyan aurora glow (Bottom)
    final orb4Center = Offset(size.width * 0.15, size.height * 0.82);
    final orb4Radius = (size.width * 0.36).clamp(320.0, 460.0);
    final orb4Paint = Paint()
      ..shader = ui.Gradient.radial(
        orb4Center,
        orb4Radius,
        [
          const Color(0xFF10B981).withValues(alpha: 0.16),
          const Color(0xFF06B6D4).withValues(alpha: 0.08),
          Colors.transparent,
        ],
        const [0.0, 0.45, 1.0],
      );
    canvas.drawCircle(orb4Center, orb4Radius, orb4Paint);

    // 2. Batched Cyber Matrix Grid
    const double spacing = 48.0;
    final int numCols = (size.width / spacing).ceil();
    final int numRows = (size.height / spacing).ceil();

    final regularLinesPath = Path();
    final majorLinesPath = Path();
    final crosshairsPath = Path();
    final List<Offset> starPoints = [];

    // Vertical lines
    for (int i = 0; i <= numCols; i++) {
      final double x = i * spacing;
      if (i % 4 == 0) {
        majorLinesPath.moveTo(x, 0);
        majorLinesPath.lineTo(x, size.height);
      } else {
        regularLinesPath.moveTo(x, 0);
        regularLinesPath.lineTo(x, size.height);
      }
    }

    // Horizontal lines
    for (int j = 0; j <= numRows; j++) {
      final double y = j * spacing;
      if (j % 4 == 0) {
        majorLinesPath.moveTo(0, y);
        majorLinesPath.lineTo(size.width, y);
      } else {
        regularLinesPath.moveTo(0, y);
        regularLinesPath.lineTo(size.width, y);
      }
    }

    // Intersections: Crosshairs at major grid intersections, subtle glowing dots elsewhere
    for (int i = 0; i <= numCols; i++) {
      final double x = i * spacing;
      for (int j = 0; j <= numRows; j++) {
        final double y = j * spacing;
        if (i % 4 == 0 && j % 4 == 0) {
          // High-tech "+" crosshair marker at major grid coordinates
          crosshairsPath.moveTo(x - 5, y);
          crosshairsPath.lineTo(x + 5, y);
          crosshairsPath.moveTo(x, y - 5);
          crosshairsPath.lineTo(x, y + 5);
        } else if ((i + j) % 3 == 0) {
          starPoints.add(Offset(x, y));
        }
      }
    }

    // Batched Line Draws (Only 3 draw calls for all thousands of grid elements)
    final regularPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.038)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;
    canvas.drawPath(regularLinesPath, regularPaint);

    final majorPaint = Paint()
      ..color = const Color(0xFF06B6D4).withValues(alpha: 0.085)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawPath(majorLinesPath, majorPaint);

    final crosshairPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.38)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(crosshairsPath, crosshairPaint);

    if (starPoints.isNotEmpty) {
      final dotPaint = Paint()
        ..color = const Color(0xFF818CF8).withValues(alpha: 0.18)
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;
      canvas.drawPoints(ui.PointMode.points, starPoints, dotPaint);
    }

    // 3. Cinematic Vignette Depth Falloff (smooth perimeter fade)
    final vignetteCenter = Offset(size.width * 0.5, size.height * 0.4);
    final vignetteRadius = (size.width * 0.75).clamp(500.0, 1400.0);
    final vignettePaint = Paint()
      ..shader = ui.Gradient.radial(
        vignetteCenter,
        vignetteRadius,
        [
          Colors.transparent,
          const Color(0xFF06080F).withValues(alpha: 0.40),
        ],
        const [0.55, 1.0],
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), vignettePaint);
  }

  /// Eye-Catching Light Mode: Mirrors dark theme structure — 4-Orb Aurora Nebula,
  /// Cyber Matrix Grid, Crosshairs & Depth Vignette — with vibrant light-adapted palette.
  void _paintLightMode(Canvas canvas, Size size) {
    // 1. Multi-Orb Aurora Nebula Glows (same positions as dark, vibrant light palette)
    // Orb 1: Cyan & Electric Blue glow behind Hero Orbit Avatar
    final orb1Center = Offset(size.width * 0.76, 220);
    final orb1Radius = (size.width * 0.42).clamp(360.0, 560.0);
    final orb1Paint = Paint()
      ..shader = ui.Gradient.radial(
        orb1Center,
        orb1Radius,
        [
          const Color(0xFF0EA5E9).withValues(alpha: 0.22),
          const Color(0xFF38BDF8).withValues(alpha: 0.12),
          Colors.transparent,
        ],
        const [0.0, 0.45, 1.0],
      );
    canvas.drawCircle(orb1Center, orb1Radius, orb1Paint);

    // Orb 2: Royal Indigo & Violet glow behind Greeting & Hero Title
    final orb2Center = Offset(size.width * 0.20, 240);
    final orb2Radius = (size.width * 0.38).clamp(320.0, 500.0);
    final orb2Paint = Paint()
      ..shader = ui.Gradient.radial(
        orb2Center,
        orb2Radius,
        [
          const Color(0xFF818CF8).withValues(alpha: 0.22),
          const Color(0xFFA78BFA).withValues(alpha: 0.12),
          Colors.transparent,
        ],
        const [0.0, 0.50, 1.0],
      );
    canvas.drawCircle(orb2Center, orb2Radius, orb2Paint);

    // Orb 3: Iridescent Rose & Pink shimmer (Center/Mid)
    final orb3Center = Offset(size.width * 0.85, size.height * 0.54);
    final orb3Radius = (size.width * 0.35).clamp(300.0, 480.0);
    final orb3Paint = Paint()
      ..shader = ui.Gradient.radial(
        orb3Center,
        orb3Radius,
        [
          const Color(0xFFF472B6).withValues(alpha: 0.16),
          const Color(0xFFFB7185).withValues(alpha: 0.08),
          Colors.transparent,
        ],
        const [0.0, 0.48, 1.0],
      );
    canvas.drawCircle(orb3Center, orb3Radius, orb3Paint);

    // Orb 4: Emerald & Cyan aurora glow (Bottom)
    final orb4Center = Offset(size.width * 0.15, size.height * 0.82);
    final orb4Radius = (size.width * 0.36).clamp(320.0, 460.0);
    final orb4Paint = Paint()
      ..shader = ui.Gradient.radial(
        orb4Center,
        orb4Radius,
        [
          const Color(0xFF34D399).withValues(alpha: 0.18),
          const Color(0xFF06B6D4).withValues(alpha: 0.10),
          Colors.transparent,
        ],
        const [0.0, 0.45, 1.0],
      );
    canvas.drawCircle(orb4Center, orb4Radius, orb4Paint);

    // 2. Batched Cyber Matrix Grid (same structure as dark, light-adapted slate/indigo palette)
    const double spacing = 48.0;
    final int numCols = (size.width / spacing).ceil();
    final int numRows = (size.height / spacing).ceil();

    final regularLinesPath = Path();
    final majorLinesPath = Path();
    final crosshairsPath = Path();
    final List<Offset> starPoints = [];

    // Vertical lines
    for (int i = 0; i <= numCols; i++) {
      final double x = i * spacing;
      if (i % 4 == 0) {
        majorLinesPath.moveTo(x, 0);
        majorLinesPath.lineTo(x, size.height);
      } else {
        regularLinesPath.moveTo(x, 0);
        regularLinesPath.lineTo(x, size.height);
      }
    }

    // Horizontal lines
    for (int j = 0; j <= numRows; j++) {
      final double y = j * spacing;
      if (j % 4 == 0) {
        majorLinesPath.moveTo(0, y);
        majorLinesPath.lineTo(size.width, y);
      } else {
        regularLinesPath.moveTo(0, y);
        regularLinesPath.lineTo(size.width, y);
      }
    }

    // Intersections: Crosshairs at major grid intersections, subtle glowing dots elsewhere
    for (int i = 0; i <= numCols; i++) {
      final double x = i * spacing;
      for (int j = 0; j <= numRows; j++) {
        final double y = j * spacing;
        if (i % 4 == 0 && j % 4 == 0) {
          // High-tech "+" crosshair marker at major grid coordinates
          crosshairsPath.moveTo(x - 5, y);
          crosshairsPath.lineTo(x + 5, y);
          crosshairsPath.moveTo(x, y - 5);
          crosshairsPath.lineTo(x, y + 5);
        } else if ((i + j) % 3 == 0) {
          starPoints.add(Offset(x, y));
        }
      }
    }

    // Batched Line Draws (same 3-call pattern as dark mode)
    final regularPaint = Paint()
      ..color = const Color(0xFF94A3B8).withValues(alpha: 0.10)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;
    canvas.drawPath(regularLinesPath, regularPaint);

    final majorPaint = Paint()
      ..color = const Color(0xFF6366F1).withValues(alpha: 0.14)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawPath(majorLinesPath, majorPaint);

    final crosshairPaint = Paint()
      ..color = const Color(0xFF4F46E5).withValues(alpha: 0.32)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(crosshairsPath, crosshairPaint);

    if (starPoints.isNotEmpty) {
      final dotPaint = Paint()
        ..color = const Color(0xFF6366F1).withValues(alpha: 0.20)
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;
      canvas.drawPoints(ui.PointMode.points, starPoints, dotPaint);
    }

    // 3. Cinematic Vignette Depth Falloff (soft perimeter fade — light counterpart)
    final vignetteCenter = Offset(size.width * 0.5, size.height * 0.4);
    final vignetteRadius = (size.width * 0.75).clamp(500.0, 1400.0);
    final vignettePaint = Paint()
      ..shader = ui.Gradient.radial(
        vignetteCenter,
        vignetteRadius,
        [
          Colors.transparent,
          const Color(0xFFCBD5E1).withValues(alpha: 0.30),
        ],
        const [0.55, 1.0],
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), vignettePaint);
  }

  @override
  bool shouldRepaint(covariant _EyeCatchingMeshPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
