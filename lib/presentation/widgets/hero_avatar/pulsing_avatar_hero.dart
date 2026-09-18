import 'package:flutter/material.dart';

/// Bioluminescent Multi-Ring Ripple with Phase Offsets (PulsingAvatarHero).
///
/// Features:
/// 1. Multi-Ring Waves: Single [CustomPainter] renders 3 concentric wave circles
///    expanding outward from [avatarRadius] to [avatarRadius * rippleMaxScale].
/// 2. Phase Offsets & Opacity Decay: Staggers wave radii using an [AnimationController]
///    (ring 1: t, ring 2: (t + 0.33) % 1.0, ring 3: (t + 0.66) % 1.0).
///    Each ring expands and simultaneously fades out from opacity 0.45 down to 0.0.
/// 3. Bioluminescent Backdrop: Soft radial gradient glow that breathes between
///    opacity 0.2 and 0.55 using a smooth sine curve.
/// 4. Highly Configurable & Reusable: Accepts [imageProvider], [child], [avatarRadius],
///    [accentColor], [isHovered], and optional [badge] overlay widget.
/// 5. Zero Memory Leaks: Full controller disposal, isolated [RepaintBoundary].
class PulsingAvatarHero extends StatefulWidget {
  final ImageProvider? imageProvider;
  final Widget? child;
  final Widget? badge;
  final double avatarRadius;
  final Color accentColor;
  final Color secondaryColor;
  final bool isHovered;
  final double rippleMaxScale;
  final Duration rippleDuration;
  final Duration glowDuration;

  const PulsingAvatarHero({
    this.imageProvider,
    this.child,
    this.badge,
    this.avatarRadius = 80.0,
    this.accentColor = const Color(0xFF06B6D4),
    this.secondaryColor = const Color(0xFF6366F1),
    this.isHovered = false,
    this.rippleMaxScale = 1.85,
    this.rippleDuration = const Duration(milliseconds: 3200),
    this.glowDuration = const Duration(milliseconds: 2400),
    super.key,
  });

  @override
  State<PulsingAvatarHero> createState() => _PulsingAvatarHeroState();
}

class _PulsingAvatarHeroState extends State<PulsingAvatarHero>
    with TickerProviderStateMixin {
  late final AnimationController _rippleController;
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    // Continuous linear controller for expanding wave rings
    _rippleController = AnimationController(
      vsync: this,
      duration: widget.rippleDuration,
    )..repeat();

    // Reversing sine controller for bioluminescent breathing backdrop
    _glowController = AnimationController(
      vsync: this,
      duration: widget.glowDuration,
    )..repeat(reverse: true);

    _glowAnimation = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarDiameter = widget.avatarRadius * 2;
    final totalSize = widget.avatarRadius * widget.rippleMaxScale * 2;

    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 1. Bioluminescent radial backdrop and 3-ring expanding ripples
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: Listenable.merge([_rippleController, _glowAnimation]),
              builder: (context, _) {
                return CustomPaint(
                  size: Size(totalSize, totalSize),
                  painter: _BioluminescentRipplesPainter(
                    rippleProgress: _rippleController.value,
                    glowBreath: _glowAnimation.value,
                    avatarRadius: widget.avatarRadius,
                    maxRadius: widget.avatarRadius * widget.rippleMaxScale,
                    accentColor: widget.accentColor,
                    secondaryColor: widget.secondaryColor,
                    isHovered: widget.isHovered,
                  ),
                );
              },
            ),
          ),

          // 2. Central Avatar content (either child or ImageProvider)
          SizedBox(
            width: avatarDiameter,
            height: avatarDiameter,
            child: widget.child ??
                (widget.imageProvider != null
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: widget.imageProvider!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
          ),

          // 3. Optional anchored status badge (e.g. "🟢 9+ YRS • Senior Mobile Dev")
          if (widget.badge != null)
            Positioned(
              bottom: (totalSize - avatarDiameter) / 2 - 14,
              child: widget.badge!,
            ),
        ],
      ),
    );
  }
}

/// CustomPainter rendering:
/// - Breathing bioluminescent radial gradient backdrop.
/// - 3 staggered expanding wave rings fading from opacity 0.45 to 0.0.
class _BioluminescentRipplesPainter extends CustomPainter {
  final double rippleProgress;
  final double glowBreath;
  final double avatarRadius;
  final double maxRadius;
  final Color accentColor;
  final Color secondaryColor;
  final bool isHovered;

  const _BioluminescentRipplesPainter({
    required this.rippleProgress,
    required this.glowBreath,
    required this.avatarRadius,
    required this.maxRadius,
    required this.accentColor,
    required this.secondaryColor,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // --- 1. Bioluminescent Breathing Radial Glow Backdrop ---
    // Pulses opacity between 0.20 and 0.55, enhanced further on hover
    final breathOpacity = (0.20 + 0.35 * glowBreath) * (isHovered ? 1.25 : 1.0);
    final glowRadius = avatarRadius * (1.15 + 0.25 * glowBreath);

    final backdropPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          accentColor.withValues(alpha: (breathOpacity * 0.85).clamp(0.0, 1.0)),
          secondaryColor.withValues(alpha: (breathOpacity * 0.45).clamp(0.0, 1.0)),
          accentColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: glowRadius));

    canvas.drawCircle(center, glowRadius, backdropPaint);

    // --- 2. Multi-Ring Waves with Staggered Phase Offsets ---
    // 3 rings staggered at:
    // Ring 1: t
    // Ring 2: (t + 0.333) % 1.0
    // Ring 3: (t + 0.666) % 1.0
    const ringCount = 3;
    final radiusSpan = maxRadius - avatarRadius;

    for (int i = 0; i < ringCount; i++) {
      final phaseOffset = i / ringCount.toDouble();
      final t = (rippleProgress + phaseOffset) % 1.0;

      // Expand from avatarRadius outward to maxRadius
      final currentRadius = avatarRadius + (radiusSpan * t);

      // Opacity fades linearly from ~0.45 down to 0.0 as it reaches outer boundary
      final fadeProgress = 1.0 - t;
      final ringOpacity = (fadeProgress * (isHovered ? 0.55 : 0.40)).clamp(0.0, 1.0);

      if (ringOpacity <= 0.01) continue;

      // Color shifts gracefully from accentColor to secondaryColor along expansion
      final ringColor = Color.lerp(accentColor, secondaryColor, t) ?? accentColor;

      // Outer soft glow for the ring
      final ringGlowPaint = Paint()
        ..color = ringColor.withValues(alpha: ringOpacity * 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5 * fadeProgress + 1.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);

      canvas.drawCircle(center, currentRadius, ringGlowPaint);

      // Crisp focused expanding ring line
      final ringBorderPaint = Paint()
        ..color = ringColor.withValues(alpha: ringOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8 * fadeProgress + 0.6;

      canvas.drawCircle(center, currentRadius, ringBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BioluminescentRipplesPainter oldDelegate) {
    return oldDelegate.rippleProgress != rippleProgress ||
        oldDelegate.glowBreath != glowBreath ||
        oldDelegate.isHovered != isHovered ||
        oldDelegate.avatarRadius != avatarRadius ||
        oldDelegate.maxRadius != maxRadius ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
