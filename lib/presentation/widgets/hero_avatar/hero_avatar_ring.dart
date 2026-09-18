import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Production-ready, high-performance Flutter Web Hero Avatar Ring.
///
/// Features:
/// 1. Continuous 4-second linear rotating conic border with cyan, indigo, and deep purple highlights.
/// 2. Interactive mouse parallax (3D card-tilt) using perspective Transform Matrix4.
/// 3. Smooth hover scale feedback (1.0 -> 1.05) with [Curves.easeOutCubic].
/// 4. Enclosed in [RepaintBoundary] for optimal Flutter Web raster performance.
class HeroAvatarRing extends StatefulWidget {
  final Widget child;
  final double size;
  final double borderWidth;
  final List<Color>? gradientColors;
  final double maxTiltAngle;
  final Duration rotationDuration;
  final ValueChanged<bool>? onHoverChanged;

  const HeroAvatarRing({
    required this.child,
    this.size = 220.0,
    this.borderWidth = 4.0,
    this.gradientColors,
    this.maxTiltAngle = 0.22,
    this.rotationDuration = const Duration(seconds: 4),
    this.onHoverChanged,
    super.key,
  });

  @override
  State<HeroAvatarRing> createState() => _HeroAvatarRingState();
}

class _HeroAvatarRingState extends State<HeroAvatarRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;
  double _tiltX = 0.0;
  double _tiltY = 0.0;
  bool _isHovered = false;

  static const List<Color> _defaultColors = [
    Color(0xFF06B6D4), // Cyan highlight
    Color(0xFF6366F1), // Indigo
    Color(0xFFA855F7), // Deep purple
    Color(0xFFEC4899), // Pink accent
    Color(0xFF06B6D4), // Loop back to Cyan
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handlePointerHover(PointerEvent event, BoxConstraints constraints) {
    final width = constraints.maxWidth > 0 ? constraints.maxWidth : widget.size;
    final height = constraints.maxHeight > 0 ? constraints.maxHeight : widget.size;

    final localPos = event.localPosition;
    final normalizedX = ((localPos.dx / width) * 2.0 - 1.0).clamp(-1.0, 1.0);
    final normalizedY = ((localPos.dy / height) * 2.0 - 1.0).clamp(-1.0, 1.0);

    if (!_isHovered || _tiltX != normalizedX || _tiltY != normalizedY) {
      setState(() {
        _isHovered = true;
        _tiltX = normalizedX;
        _tiltY = normalizedY;
      });
      widget.onHoverChanged?.call(true);
    }
  }

  void _handlePointerExit() {
    setState(() {
      _isHovered = false;
      _tiltX = 0.0;
      _tiltY = 0.0;
    });
    widget.onHoverChanged?.call(false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.gradientColors ?? _defaultColors;

    // 3D Tilt Transform Matrix with realistic perspective distortion
    final tiltTransform = Matrix4.identity()
      ..setEntry(3, 2, 0.001) // Perspective focal length
      ..rotateX(-_tiltY * widget.maxTiltAngle)
      ..rotateY(_tiltX * widget.maxTiltAngle);

    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onHover: (e) => _handlePointerHover(e, constraints),
          onExit: (_) => _handlePointerExit(),
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            transform: tiltTransform,
            transformAlignment: Alignment.center,
            child: AnimatedScale(
              scale: _isHovered ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Isolated RepaintBoundary for high-performance rotating conic border
                    RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: _rotationController,
                        builder: (context, _) {
                          return CustomPaint(
                            size: Size(widget.size, widget.size),
                            painter: _ConicBorderPainter(
                              rotationAngle: _rotationController.value * 2 * math.pi,
                              borderWidth: widget.borderWidth,
                              colors: colors,
                              isHovered: _isHovered,
                            ),
                          );
                        },
                      ),
                    ),

                    // Inner Avatar Content clipped to perfect circle
                    Padding(
                      padding: EdgeInsets.all(widget.borderWidth + 3.0),
                      child: ClipOval(
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// CustomPainter that renders a continuous rotating conic SweepGradient border
/// with outer ambient neon drop-shadow.
class _ConicBorderPainter extends CustomPainter {
  final double rotationAngle;
  final double borderWidth;
  final List<Color> colors;
  final bool isHovered;

  const _ConicBorderPainter({
    required this.rotationAngle,
    required this.borderWidth,
    required this.colors,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - borderWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Ambient blurred neon glow ring
    final glowPaint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        transform: GradientRotation(rotationAngle),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * (isHovered ? 2.8 : 1.8)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, isHovered ? 14.0 : 8.0);

    canvas.drawCircle(center, radius, glowPaint);

    // 2. Crisp focused rotating conic border
    final borderPaint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        transform: GradientRotation(rotationAngle),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _ConicBorderPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.isHovered != isHovered ||
        oldDelegate.borderWidth != borderWidth;
  }
}
