import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AmbientMeshBackground extends StatelessWidget {
  const AmbientMeshBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPaint(
      painter: _GridMeshPainter(
        gridColor: isDark
            ? Colors.white.withValues(alpha: 0.025)
            : Colors.black.withValues(alpha: 0.02),
        dotColor: isDark
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.primary.withValues(alpha: 0.05),
        primaryGlow: AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.05),
        secondaryGlow: AppColors.secondary.withValues(alpha: isDark ? 0.08 : 0.04),
        accentGlow: AppColors.accent.withValues(alpha: isDark ? 0.08 : 0.04),
      ),
    );
  }
}

class _GridMeshPainter extends CustomPainter {
  final Color gridColor;
  final Color dotColor;
  final Color primaryGlow;
  final Color secondaryGlow;
  final Color accentGlow;

  _GridMeshPainter({
    required this.gridColor,
    required this.dotColor,
    required this.primaryGlow,
    required this.secondaryGlow,
    required this.accentGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw smooth ambient radial glow spots directly on canvas
    final primaryGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [primaryGlow, primaryGlow.withValues(alpha: 0.0)],
      ).createShader(Rect.fromCircle(center: const Offset(100, 100), radius: 380));
    canvas.drawCircle(const Offset(100, 100), 380, primaryGlowPaint);

    final secondaryGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [secondaryGlow, secondaryGlow.withValues(alpha: 0.0)],
      ).createShader(Rect.fromCircle(center: Offset(size.width - 100, 500), radius: 350));
    canvas.drawCircle(Offset(size.width - 100, 500), 350, secondaryGlowPaint);

    final accentGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [accentGlow, accentGlow.withValues(alpha: 0.0)],
      ).createShader(Rect.fromCircle(center: Offset(150, size.height - 200), radius: 350));
    canvas.drawCircle(Offset(150, size.height - 200), 350, accentGlowPaint);

    // 2. Draw mesh grid lines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const spacing = 50.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        if ((x / spacing + y / spacing) % 4 == 0) {
          canvas.drawCircle(Offset(x, y), 1.2, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridMeshPainter oldDelegate) => false;
}
