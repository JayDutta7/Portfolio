import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sensors_plus/sensors_plus.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Internal physics state for a single floating element
// ─────────────────────────────────────────────────────────────────────────────
class _Particle {
  Offset position; // current position, local to the wrapper Stack
  Offset velocity; // pixels per physics frame
  Offset origin; // resting position captured from layout
  Size size; // widget dimensions captured from layout

  _Particle({
    required this.position,
    required this.velocity,
    required this.origin,
    required this.size,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// AntigravityWrapper
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps a list of children and adds a zero-gravity floating physics mode.
///
/// When the **Antigravity Mode** toggle is pressed:
/// - Each child detaches from its static layout and floats with organic drift.
/// - Moving the mouse (or dragging on touch) near a widget pushes it away.
/// - On Android/iOS the device's accelerometer shifts the gravity vector so
///   tilting the phone alters where everything floats toward.
/// - Bouncing softly against the wrapper's inner boundaries keeps widgets on-screen.
///
/// Toggling OFF springs every widget smoothly back to its original slot.
///
/// ```dart
/// AntigravityWrapper(
///   children: [MyCard(), AnotherCard()],
/// )
/// ```
class AntigravityWrapper extends StatefulWidget {
  /// The widgets to float. Rendered in a [Wrap] when physics are off.
  final List<Widget> children;

  /// Show/hide the built-in toggle button.
  final bool showToggle;

  /// Accent colour for the toggle button and glow effect.
  final Color accentColor;

  /// Horizontal spacing between children in normal (non-float) mode.
  final double spacing;

  /// Vertical spacing between children in normal (non-float) mode.
  final double runSpacing;

  /// Alignment of the [Wrap] in normal mode.
  final WrapAlignment wrapAlignment;

  const AntigravityWrapper({
    super.key,
    required this.children,
    this.showToggle = true,
    this.accentColor = const Color(0xFF06B6D4),
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.wrapAlignment = WrapAlignment.start,
  });

  @override
  State<AntigravityWrapper> createState() => AntigravityWrapperState();
}

class AntigravityWrapperState extends State<AntigravityWrapper>
    with TickerProviderStateMixin {
  // ── Per-child keys for measuring layout positions ─────────────────
  late final List<GlobalKey> _childKeys;
  late final List<_Particle> _particles;

  // Key assigned to the root Stack so we can measure its RenderBox.
  final _rootKey = GlobalKey();

  // ── Mode flags ────────────────────────────────────────────────────
  bool _isActive = false;
  bool _returning = false;

  // ── Physics ticker ────────────────────────────────────────────────
  late final Ticker _ticker;
  Duration _prevElapsed = Duration.zero;

  // ── Gravity vector (local coords, px / physics-frame) ─────────────
  Offset _gravity = const Offset(0.0, -0.10); // default: gentle upward drift

  // ── Cursor repulsion position (local to wrapper) ──────────────────
  Offset _cursorLocal = const Offset(-99999, -99999);

  // ── Sensor subscription ───────────────────────────────────────────
  StreamSubscription<AccelerometerEvent>? _accelSub;

  // ── Physics constants ─────────────────────────────────────────────
  static const double _kDamping = 0.982;
  static const double _kBrownian = 0.055;
  static const double _kBounce = 0.36;
  static const double _kRepulseRadius = 130.0;
  static const double _kRepulseStrength = 3.8;
  static const double _kSpringK = 0.058;
  static const double _kSpringDamp = 0.76;
  static const double _kSettleThresh = 1.8;

  @override
  void initState() {
    super.initState();
    _childKeys = List.generate(widget.children.length, (_) => GlobalKey());
    _particles = List.generate(
      widget.children.length,
      (_) => _Particle(
        position: Offset.zero,
        velocity: Offset.zero,
        origin: Offset.zero,
        size: Size.zero,
      ),
    );
    _ticker = createTicker(_physicsStep)..start();
    _initSensors();
  }

  // ── Sensor initialisation ─────────────────────────────────────────
  void _initSensors() {
    if (kIsWeb) return;
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) { return; }
    try {
      _accelSub = accelerometerEventStream(
        samplingPeriod: SensorInterval.gameInterval,
      ).listen((AccelerometerEvent ev) {
        if (_isActive && !_returning) {
          _gravity = Offset(
            -ev.x.clamp(-9.8, 9.8) / 9.8 * 0.28,
            ev.y.clamp(-9.8, 9.8) / 9.8 * 0.28,
          );
        }
      });
    } catch (e) {
      debugPrint('[AntigravityWrapper] Sensor unavailable: $e');
    }
  }

  // ── Physics step (Ticker callback, ~60 fps) ───────────────────────
  void _physicsStep(Duration elapsed) {
    if (!mounted) return;
    // Normalise dt; clamp to [0.5, 3.0] to avoid blow-up on lag spikes.
    final dt = ((elapsed - _prevElapsed).inMilliseconds / 16.0).clamp(0.5, 3.0);
    _prevElapsed = elapsed;

    if (!_isActive && !_returning) return;

    final rootBox = _rootKey.currentContext?.findRenderObject() as RenderBox?;
    if (rootBox == null) return;
    final wrapSize = rootBox.size;

    bool allSettled = true;
    final rng = math.Random();

    for (final p in _particles) {
      if (p.size == Size.zero) continue;

      if (_returning) {
        // ── Spring back toward origin ───────────────────────────────
        final diff = p.origin - p.position;
        p.velocity = Offset(
          p.velocity.dx * _kSpringDamp + diff.dx * _kSpringK * dt,
          p.velocity.dy * _kSpringDamp + diff.dy * _kSpringK * dt,
        );
        p.position = p.position + p.velocity * dt;
        if (diff.distance < _kSettleThresh && p.velocity.distance < _kSettleThresh) {
          p.position = p.origin;
          p.velocity = Offset.zero;
        } else {
          allSettled = false;
        }
      } else {
        // ── Free-float physics ──────────────────────────────────────
        allSettled = false;

        // Brownian (organic) noise
        final noise = Offset(
          (rng.nextDouble() - 0.5) * _kBrownian,
          (rng.nextDouble() - 0.5) * _kBrownian,
        );

        // Cursor / touch repulsion impulse
        final center = p.position + Offset(p.size.width * 0.5, p.size.height * 0.5);
        final toCursor = center - _cursorLocal;
        final dist = toCursor.distance;
        Offset repulse = Offset.zero;
        if (dist < _kRepulseRadius && dist > 1.0) {
          final s = (1.0 - dist / _kRepulseRadius) * _kRepulseStrength;
          repulse = Offset(toCursor.dx / dist * s, toCursor.dy / dist * s);
        }

        // Integrate velocity
        p.velocity = Offset(
          (p.velocity.dx + (_gravity.dx + noise.dx + repulse.dx) * dt) * _kDamping,
          (p.velocity.dy + (_gravity.dy + noise.dy + repulse.dy) * dt) * _kDamping,
        );
        p.position = p.position + p.velocity * dt;

        // ── Soft boundary collision ─────────────────────────────────
        final maxX = wrapSize.width - p.size.width;
        final maxY = wrapSize.height - p.size.height;
        if (p.position.dx < 0) {
          p.position = Offset(0, p.position.dy);
          p.velocity = Offset(p.velocity.dx.abs() * _kBounce, p.velocity.dy);
        } else if (maxX > 0 && p.position.dx > maxX) {
          p.position = Offset(maxX, p.position.dy);
          p.velocity = Offset(-p.velocity.dx.abs() * _kBounce, p.velocity.dy);
        }
        if (p.position.dy < 0) {
          p.position = Offset(p.position.dx, 0);
          p.velocity = Offset(p.velocity.dx, p.velocity.dy.abs() * _kBounce);
        } else if (maxY > 0 && p.position.dy > maxY) {
          p.position = Offset(p.position.dx, maxY);
          p.velocity = Offset(p.velocity.dx, -p.velocity.dy.abs() * _kBounce);
        }
      }
    }

    if (_returning && allSettled) {
      setState(() {
        _returning = false;
        _isActive = false;
        _gravity = const Offset(0, -0.10);
      });
    } else {
      if (mounted) setState(() {});
    }
  }

  // ── Position capture ──────────────────────────────────────────────
  void _capturePositions() {
    final rootBox = _rootKey.currentContext?.findRenderObject() as RenderBox?;
    if (rootBox == null) return;
    final rng = math.Random();
    for (int i = 0; i < _childKeys.length; i++) {
      final ctx = _childKeys[i].currentContext;
      if (ctx == null) continue;
      final childBox = ctx.findRenderObject() as RenderBox?;
      if (childBox == null) continue;
      final localPos = rootBox.globalToLocal(childBox.localToGlobal(Offset.zero));
      _particles[i]
        ..origin = localPos
        ..position = localPos
        ..size = childBox.size
        ..velocity = Offset(
          (rng.nextDouble() - 0.5) * 4.0,
          -(rng.nextDouble() * 2.5 + 0.8),
        );
    }
  }

  // ── Public toggle ─────────────────────────────────────────────────
  /// Programmatically toggle antigravity mode (same as pressing the button).
  void toggle() {
    if (!_isActive && !_returning) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _capturePositions();
        if (mounted) setState(() => _isActive = true);
      });
    } else {
      if (mounted) setState(() => _returning = true);
    }
  }

  // ── Pointer / cursor handling ─────────────────────────────────────
  void _onPointer(Offset globalPos) {
    final rootBox = _rootKey.currentContext?.findRenderObject() as RenderBox?;
    if (rootBox != null) _cursorLocal = rootBox.globalToLocal(globalPos);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _accelSub?.cancel();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final showOverlay = _isActive || _returning;

    return Stack(
      key: _rootKey,
      clipBehavior: Clip.none,
      children: [
        // Ghost layout — invisible when floating, keeps wrapper sized.
        Opacity(
          opacity: showOverlay ? 0.0 : 1.0,
          child: Wrap(
            spacing: widget.spacing,
            runSpacing: widget.runSpacing,
            alignment: widget.wrapAlignment,
            children: [
              for (int i = 0; i < widget.children.length; i++)
                KeyedSubtree(key: _childKeys[i], child: widget.children[i]),
            ],
          ),
        ),

        // Floating overlay — only shown when active or returning.
        if (showOverlay)
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerMove: (e) => _onPointer(e.position),
            onPointerHover: (e) => _onPointer(e.position),
            child: MouseRegion(
              onExit: (_) => _cursorLocal = const Offset(-99999, -99999),
              child: RepaintBoundary(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    for (int i = 0; i < _particles.length; i++)
                      if (_particles[i].size != Size.zero)
                        Positioned(
                          left: _particles[i].position.dx,
                          top: _particles[i].position.dy,
                          width: _particles[i].size.width,
                          height: _particles[i].size.height,
                          child: widget.children[i],
                        ),
                  ],
                ),
              ),
            ),
          ),

        // Built-in toggle button.
        if (widget.showToggle)
          Positioned(
            bottom: 14,
            right: 14,
            child: _AntigravityToggle(
              isActive: showOverlay,
              color: widget.accentColor,
              onTap: toggle,
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Toggle button widget
// ─────────────────────────────────────────────────────────────────────────────
class _AntigravityToggle extends StatefulWidget {
  final bool isActive;
  final Color color;
  final VoidCallback onTap;
  const _AntigravityToggle({required this.isActive, required this.color, required this.onTap});
  @override
  State<_AntigravityToggle> createState() => _AntigravityToggleState();
}

class _AntigravityToggleState extends State<_AntigravityToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _glow;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
      ..repeat(reverse: true);
    _glow = CurvedAnimation(parent: _pulse, curve: Curves.easeInOut);
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _glow,
          builder: (_, child) => AnimatedScale(
            scale: _hovered ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 160),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              decoration: BoxDecoration(
                gradient: widget.isActive
                    ? LinearGradient(colors: [
                        widget.color,
                        Color.lerp(widget.color, const Color(0xFF8B5CF6), 0.55)!,
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF334155)]),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: widget.isActive
                        ? widget.color.withValues(alpha: 0.22 + _glow.value * 0.28)
                        : Colors.black.withValues(alpha: 0.30),
                    blurRadius: widget.isActive ? 18 + _glow.value * 14 : 8,
                    spreadRadius: widget.isActive ? 1 : 0,
                  ),
                ],
                border: Border.all(
                  color: widget.isActive
                      ? widget.color.withValues(alpha: 0.60)
                      : Colors.white.withValues(alpha: 0.10),
                  width: 1.2,
                ),
              ),
              child: child,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedRotation(
                turns: widget.isActive ? -0.14 : 0.0,
                duration: const Duration(milliseconds: 420),
                curve: Curves.elasticOut,
                child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Text(
                  widget.isActive ? 'Antigravity ON' : 'Antigravity Mode',
                  key: ValueKey(widget.isActive),
                  style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700,
                    fontSize: 13, letterSpacing: 0.3,
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
