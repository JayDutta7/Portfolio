import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Data class representing a planetary tech stack badge item.
class OrbitBadgeItem {
  final String name;
  final Widget icon;
  final Color color;
  final Color glowColor;
  final String tooltip;

  const OrbitBadgeItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.glowColor,
    required this.tooltip,
  });
}

/// Interactive Planetary Motion widget featuring a central profile avatar
/// surrounded by orbiting tech stack icons moving along two concentric circular tracks.
///
/// Features:
/// 1. Dual concentric circular orbital tracks (inner and outer).
/// 2. Polar coordinate revolution: x = r * cos(angle + offset), y = r * sin(angle + offset).
/// 3. Upright Icons: Counter-rotated by -angle so icons never flip upside down.
/// 4. Interactivity: Hovering pauses/slows down orbital revolution, with tooltips.
/// 5. Wrapped in [RepaintBoundary] for Flutter Web performance.
class OrbitingTechBadges extends StatefulWidget {
  final Widget centerWidget;
  final List<OrbitBadgeItem> innerBadges;
  final List<OrbitBadgeItem> outerBadges;
  final double canvasSize;
  final double innerRadius;
  final double outerRadius;
  final double badgeSize;
  final Duration orbitDuration;
  final bool isDark;
  final ValueChanged<OrbitBadgeItem?>? onBadgeSelected;

  const OrbitingTechBadges({
    required this.centerWidget,
    required this.innerBadges,
    required this.outerBadges,
    this.canvasSize = 420.0,
    this.innerRadius = 125.0,
    this.outerRadius = 172.0,
    this.badgeSize = 44.0,
    this.orbitDuration = const Duration(seconds: 18),
    this.isDark = true,
    this.onBadgeSelected,
    super.key,
  });

  @override
  State<OrbitingTechBadges> createState() => _OrbitingTechBadgesState();
}

class _OrbitingTechBadgesState extends State<OrbitingTechBadges>
    with SingleTickerProviderStateMixin {
  late final AnimationController _orbitController;
  int? _hoveredBadgeKey;
  int? _selectedBadgeKey;
  final Map<int, GlobalKey<TooltipState>> _tooltipKeys = {};

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: widget.orbitDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    super.dispose();
  }

  void _onBadgeTap(int badgeKey, OrbitBadgeItem badge) {
    setState(() {
      if (_selectedBadgeKey == badgeKey) {
        _selectedBadgeKey = null;
        _hoveredBadgeKey = null;
        widget.onBadgeSelected?.call(null);
        if (!_orbitController.isAnimating) {
          _orbitController.repeat();
        }
      } else {
        _selectedBadgeKey = badgeKey;
        _hoveredBadgeKey = badgeKey;
        widget.onBadgeSelected?.call(badge);
        _orbitController.stop();
      }
    });

    if (_selectedBadgeKey == badgeKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tooltipKeys[badgeKey]?.currentState?.ensureTooltipVisible();
      });
    }
  }

  void _onBadgeHover(bool isHovered, int badgeKey, OrbitBadgeItem badge) {
    if (_selectedBadgeKey != null) return;
    setState(() {
      _hoveredBadgeKey = isHovered ? badgeKey : null;
      widget.onBadgeSelected?.call(isHovered ? badge : null);
    });
    if (isHovered) {
      _orbitController.stop();
    } else {
      if (!_orbitController.isAnimating) {
        _orbitController.repeat();
      }
    }
  }

  void _clearSelection() {
    if (_selectedBadgeKey != null) {
      setState(() {
        _selectedBadgeKey = null;
        _hoveredBadgeKey = null;
        widget.onBadgeSelected?.call(null);
        if (!_orbitController.isAnimating) {
          _orbitController.repeat();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final centerCoord = widget.canvasSize / 2;

    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _clearSelection,
        child: SizedBox(
          width: widget.canvasSize,
          height: widget.canvasSize,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
          children: [
            // Concentric orbit guide tracks
            CustomPaint(
              size: Size(widget.canvasSize, widget.canvasSize),
              painter: _ConcentricTrackPainter(
                innerRadius: widget.innerRadius,
                outerRadius: widget.outerRadius,
                isDark: widget.isDark,
              ),
            ),

            // Center Avatar Widget
            Center(child: widget.centerWidget),

            // Animated Orbiting Badges layer
            AnimatedBuilder(
              animation: _orbitController,
              builder: (context, _) {
                final baseAngle = _orbitController.value * 2 * math.pi;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Inner Track Badges (Clockwise revolution)
                    ..._buildOrbitTrackBadges(
                      badges: widget.innerBadges,
                      radius: widget.innerRadius,
                      baseAngle: baseAngle,
                      centerCoord: centerCoord,
                      trackId: 100,
                      speedMultiplier: 1.0,
                    ),

                    // Outer Track Badges (Counter-clockwise revolution for depth)
                    ..._buildOrbitTrackBadges(
                      badges: widget.outerBadges,
                      radius: widget.outerRadius,
                      baseAngle: -baseAngle * 0.7,
                      centerCoord: centerCoord,
                      trackId: 200,
                      speedMultiplier: -0.7,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

  List<Widget> _buildOrbitTrackBadges({
    required List<OrbitBadgeItem> badges,
    required double radius,
    required double baseAngle,
    required double centerCoord,
    required int trackId,
    required double speedMultiplier,
  }) {
    if (badges.isEmpty) return const [];
    final step = (2 * math.pi) / badges.length;

    return List.generate(badges.length, (index) {
      final badge = badges[index];
      final currentAngle = baseAngle + (index * step);

      // Polar coordinate conversion: x = r * cos(θ), y = r * sin(θ)
      final x = centerCoord + radius * math.cos(currentAngle);
      final y = centerCoord + radius * math.sin(currentAngle);
      final badgeKey = trackId + index;
      final tooltipKey = _tooltipKeys.putIfAbsent(badgeKey, () => GlobalKey<TooltipState>());
      final isHovered = _hoveredBadgeKey == badgeKey || _selectedBadgeKey == badgeKey;

      return Positioned(
        left: x - widget.badgeSize / 2,
        top: y - widget.badgeSize / 2,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onBadgeTap(badgeKey, badge),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => _onBadgeHover(true, badgeKey, badge),
            onExit: (_) => _onBadgeHover(false, badgeKey, badge),
            child: Tooltip(
              key: tooltipKey,
              triggerMode: TooltipTriggerMode.tap,
              waitDuration: Duration.zero,
              showDuration: const Duration(seconds: 4),
              message: badge.tooltip,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: badge.color.withValues(alpha: 0.75),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: badge.glowColor.withValues(alpha: 0.5),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: AnimatedScale(
                scale: isHovered ? 1.28 : 1.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
              // Upright Icons: Counter-rotate by -currentAngle so the icon never flips upside down!
              child: Transform.rotate(
                angle: -currentAngle,
                child: Container(
                  width: widget.badgeSize,
                  height: widget.badgeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isDark
                        ? const Color(0xFF0F172A).withValues(alpha: 0.95)
                        : Colors.white.withValues(alpha: 0.96),
                    border: Border.all(
                      color: isHovered
                          ? badge.color
                          : badge.color.withValues(alpha: widget.isDark ? 0.65 : 0.45),
                      width: isHovered ? 2.4 : 1.6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: badge.glowColor.withValues(alpha: isHovered ? 0.75 : 0.28),
                        blurRadius: isHovered ? 20 : 10,
                        spreadRadius: isHovered ? 2 : 0.5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      width: widget.badgeSize * 0.55,
                      height: widget.badgeSize * 0.55,
                      child: badge.icon,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  });
  }
}

/// Painter for the two concentric circular guide tracks with subtle radar ticks and dashed arcs
class _ConcentricTrackPainter extends CustomPainter {
  final double innerRadius;
  final double outerRadius;
  final bool isDark;

  const _ConcentricTrackPainter({
    required this.innerRadius,
    required this.outerRadius,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Inner track baseline paint (smooth cyan glow)
    final innerPaint = Paint()
      ..color = (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
          .withValues(alpha: isDark ? 0.18 : 0.10)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, innerRadius, innerPaint);

    // 2. Outer track baseline paint (smooth purple/indigo glow)
    final outerPaint = Paint()
      ..color = (isDark ? const Color(0xFFA855F7) : const Color(0xFF7C3AED))
          .withValues(alpha: isDark ? 0.16 : 0.08)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, outerRadius, outerPaint);

    // 3. Futuristic dashed cyber arcs along the outer track
    final dashPaint = Paint()
      ..color = (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
          .withValues(alpha: isDark ? 0.28 : 0.18)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const totalDashes = 36;
    const dashAngle = (2 * math.pi) / totalDashes;
    const dashDrawAngle = dashAngle * 0.45;

    for (int i = 0; i < totalDashes; i++) {
      final startAngle = i * dashAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle,
        dashDrawAngle,
        false,
        dashPaint,
      );
    }

    // 4. Subtle aerospace radar ticks at 30-degree increments (12 compass points)
    final tickPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black)
          .withValues(alpha: isDark ? 0.20 : 0.12)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 12; i++) {
      final angle = i * math.pi / 6;
      final isCardinal = i % 3 == 0;
      final tickLen = isCardinal ? 5.0 : 3.0;
      final p1 = Offset(
        center.dx + (innerRadius - tickLen) * math.cos(angle),
        center.dy + (innerRadius - tickLen) * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + (innerRadius + tickLen) * math.cos(angle),
        center.dy + (innerRadius + tickLen) * math.sin(angle),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConcentricTrackPainter oldDelegate) {
    return oldDelegate.innerRadius != innerRadius ||
        oldDelegate.outerRadius != outerRadius ||
        oldDelegate.isDark != isDark;
  }
}
