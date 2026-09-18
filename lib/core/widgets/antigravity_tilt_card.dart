import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sensors_plus/sensors_plus.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AntigravityTiltCard
// ─────────────────────────────────────────────────────────────────────────────

/// An adaptive card that applies a real-time 3D perspective tilt effect.
///
/// **Web / Desktop** — Tracks mouse hover coordinates across the card surface
/// and applies a smooth [Matrix4] rotation tilt. A subtle specular sheen
/// follows the light direction implied by the tilt angle.
///
/// **Android / iOS** — Reads gyroscope data and tilts the card dynamically
/// as the user holds and moves the device.
///
/// In both cases a smooth spring-like animation returns the card to its
/// neutral (zero-tilt) position when the pointer leaves or the device
/// levels out.
///
/// ```dart
/// AntigravityTiltCard(
///   maxTiltAngle: 15.0,
///   elevation: 24.0,
///   child: MyContent(),
/// )
/// ```
class AntigravityTiltCard extends StatefulWidget {
  /// The widget rendered inside the card.
  final Widget child;

  /// Maximum tilt angle **in degrees**, applied symmetrically on X and Y axes.
  final double maxTiltAngle;

  /// Base shadow elevation of the card. Increases with tilt magnitude.
  final double elevation;

  /// Card corner radius.
  final double borderRadius;

  /// Card background colour. Defaults to the theme's surface colour.
  final Color? backgroundColor;

  /// Whether to render a specular sheen overlay that tracks the tilt direction.
  final bool showSheen;

  const AntigravityTiltCard({
    super.key,
    required this.child,
    this.maxTiltAngle = 12.0,
    this.elevation = 20.0,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.showSheen = true,
  });

  @override
  State<AntigravityTiltCard> createState() => _AntigravityTiltCardState();
}

class _AntigravityTiltCardState extends State<AntigravityTiltCard>
    with TickerProviderStateMixin {
  // ── Target tilt angles (radians) ─────────────────────────────────
  double _targetRX = 0.0; // rotation around X (pitch — up/down)
  double _targetRY = 0.0; // rotation around Y (yaw  — left/right)

  // ── Smoothed / displayed tilt angles ─────────────────────────────
  double _currentRX = 0.0;
  double _currentRY = 0.0;

  // ── Normalised sheen centre (-1..1 on both axes) ──────────────────
  Offset _sheenNorm = Offset.zero;

  bool _isHovered = false;

  // ── Smooth-lerp ticker ────────────────────────────────────────────
  late final Ticker _lerpTicker;

  // ── Gyroscope subscription (mobile only) ─────────────────────────
  StreamSubscription<GyroscopeEvent>? _gyroSub;

  // Key so we can read the card's RenderBox for local-coordinate mapping.
  final _cardKey = GlobalKey();

  // ── Tuning constants ──────────────────────────────────────────────
  /// Lerp speed while hovering (higher = snappier, lower = smoother).
  static const double _kLerpHover = 0.13;
  /// Lerp speed when returning to centre.
  static const double _kLerpReturn = 0.08;
  /// Gyro angular-velocity → tilt-angle gain (rad/s → rad per frame).
  static const double _kGyroGain = 0.016;
  /// Natural decay applied to gyro-accumulated angle each frame.
  static const double _kGyroDecay = 0.97;

  @override
  void initState() {
    super.initState();
    _lerpTicker = createTicker(_onLerpTick)..start();
    _initGyro();
  }

  // ── Gyroscope init ────────────────────────────────────────────────
  void _initGyro() {
    if (kIsWeb) return;
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) { return; }
    try {
      _gyroSub = gyroscopeEventStream(
        samplingPeriod: SensorInterval.gameInterval,
      ).listen((GyroscopeEvent ev) {
        // When the user is hovering with a mouse on a hybrid device,
        // the mouse takes priority.
        if (_isHovered) return;
        final maxRad = widget.maxTiltAngle * math.pi / 180.0;
        // Integrate angular velocity (radians/s × dt ≈ radians/frame at 60 fps)
        _targetRY = (_targetRY + ev.y * _kGyroGain).clamp(-maxRad, maxRad);
        _targetRX = (_targetRX - ev.x * _kGyroGain).clamp(-maxRad, maxRad);
        // Gentle decay toward zero so a stationary phone levels out.
        _targetRX *= _kGyroDecay;
        _targetRY *= _kGyroDecay;
      });
    } catch (e) {
      debugPrint('[AntigravityTiltCard] Gyroscope unavailable: $e');
    }
  }

  // ── Smooth lerp ticker (runs every frame) ─────────────────────────
  void _onLerpTick(Duration _) {
    if (!mounted) return;
    final speed = _isHovered ? _kLerpHover : _kLerpReturn;
    final newRX = _currentRX + (_targetRX - _currentRX) * speed;
    final newRY = _currentRY + (_targetRY - _currentRY) * speed;

    // Skip setState if change is imperceptible (< 0.01°)
    if ((newRX - _currentRX).abs() < 0.00018 &&
        (newRY - _currentRY).abs() < 0.00018) { return; }

    setState(() {
      _currentRX = newRX;
      _currentRY = newRY;
    });
  }

  // ── Pointer handling ──────────────────────────────────────────────
  void _updateFromPointer(Offset localPos) {
    final box = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final size = box.size;
    if (size.isEmpty) return;

    // Normalise pointer to [-1, 1] within the card bounds.
    final nx = ((localPos.dx / size.width) - 0.5) * 2.0;
    final ny = ((localPos.dy / size.height) - 0.5) * 2.0;

    final maxRad = widget.maxTiltAngle * math.pi / 180.0;
    _targetRX = -ny.clamp(-1.0, 1.0) * maxRad; // tilt top/bottom
    _targetRY =  nx.clamp(-1.0, 1.0) * maxRad; // tilt left/right
    _sheenNorm = Offset(nx.clamp(-1.0, 1.0), ny.clamp(-1.0, 1.0));
  }

  void _onEnter() {
    _isHovered = true;
  }

  void _onExit() {
    _isHovered = false;
    // Drive targets back to zero — the lerp ticker will animate the return.
    _targetRX = 0.0;
    _targetRY = 0.0;
    _sheenNorm = Offset.zero;
  }

  @override
  void dispose() {
    _lerpTicker.dispose();
    _gyroSub?.cancel();
    super.dispose();
  }

  // ── Matrix builder ────────────────────────────────────────────────
  Matrix4 _buildMatrix() {
    return Matrix4.identity()
      ..setEntry(3, 2, 0.0012) // perspective projection
      ..rotateX(_currentRX)
      ..rotateY(_currentRY);
  }

  // ── Build ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg =
        widget.backgroundColor ?? (isDark ? const Color(0xFF1E293B) : Colors.white);

    // Shadow intensity and offset track the tilt magnitude.
    final maxRad = widget.maxTiltAngle * math.pi / 180.0;
    final tiltFactor =
        (math.sqrt(_currentRX * _currentRX + _currentRY * _currentRY) / maxRad)
            .clamp(0.0, 1.0);
    final shadowBlur = widget.elevation * (1.0 + tiltFactor * 1.6);
    final shadowOffset = Offset(
      _currentRY / (maxRad > 0 ? maxRad : 1) * widget.elevation * 0.55,
      -_currentRX / (maxRad > 0 ? maxRad : 1) * widget.elevation * 0.55,
    );

    return MouseRegion(
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      onHover: (e) => _updateFromPointer(e.localPosition),
      child: Transform(
        transform: _buildMatrix(),
        alignment: Alignment.center,
        child: Container(
          key: _cardKey,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              // Primary shadow — deep and offset
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.48 : 0.18),
                blurRadius: shadowBlur,
                offset: shadowOffset,
              ),
              // Ambient fill shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.06),
                blurRadius: shadowBlur * 0.4,
                offset: shadowOffset * 0.35,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              widget.child,
              // ── Specular sheen overlay ──────────────────────────────
              if (widget.showSheen)
                Positioned.fill(
                  child: IgnorePointer(
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: _SheenPainter(
                          normalised: _sheenNorm,
                          intensity: tiltFactor * 0.14,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Specular sheen painter
// ─────────────────────────────────────────────────────────────────────────────

/// Paints a soft radial highlight that simulates a light source opposite
/// to the tilt direction, giving the card a glossy, 3-D feel.
class _SheenPainter extends CustomPainter {
  /// Normalised sheen centre in [-1, 1] on both axes.
  final Offset normalised;

  /// Peak opacity of the sheen (0 = invisible, 1 = fully opaque).
  final double intensity;

  const _SheenPainter({required this.normalised, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0.001) return;

    // Place the highlight opposite to the tilt to simulate a fixed light source.
    final alignX = -normalised.dx;
    final alignY = -normalised.dy;

    final gradient = RadialGradient(
      center: Alignment(alignX, alignY),
      radius: 0.90,
      colors: [
        Colors.white.withValues(alpha: intensity),
        Colors.white.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 1.0],
    );

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = gradient.createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(_SheenPainter old) =>
      old.normalised != normalised || old.intensity != intensity;
}
