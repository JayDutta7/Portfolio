import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlassContainer extends StatefulWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final Color? glowColor;
  final bool useBlur;
  final VoidCallback? onTap;

  const GlassContainer({
    required this.child,
    this.blur = 16.0,
    this.borderRadius = 24.0,
    this.padding,
    this.margin,
    this.borderColor,
    this.glowColor,
    this.useBlur = false, // Disabled by default on list/grid items for Web performance
    this.onTap,
    super.key,
  });

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBorderColor = widget.borderColor ??
        (_isHovered
            ? theme.colorScheme.primary.withValues(alpha: 0.5)
            : theme.dividerColor.withValues(alpha: isDark ? 0.6 : 0.8));

    final effectiveGlowColor = widget.glowColor ?? theme.colorScheme.primary;

    final cardDecoration = BoxDecoration(
      color: isDark
          ? theme.colorScheme.surface.withValues(alpha: _isHovered ? 0.95 : 0.85)
          : Colors.white.withValues(alpha: _isHovered ? 0.98 : 0.92),
      borderRadius: BorderRadius.circular(widget.borderRadius),
      border: Border.all(
        color: effectiveBorderColor,
        width: _isHovered ? 1.5 : 1.0,
      ),
      boxShadow: [
        if (_isHovered)
          BoxShadow(
            color: effectiveGlowColor.withValues(alpha: isDark ? 0.22 : 0.12),
            blurRadius: 28,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          )
        else
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
      ],
    );

    Widget innerContent = Container(
      padding: widget.padding ?? const EdgeInsets.all(28),
      decoration: cardDecoration,
      child: widget.onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                onTap: widget.onTap,
                child: widget.child,
              ),
            )
          : widget.child,
    );

    if (widget.useBlur && !kIsWeb) {
      innerContent = ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: innerContent,
        ),
      );
    }

    return Container(
      margin: widget.margin,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -3.0 : 0.0),
          child: innerContent,
        ),
      ),
    );
  }
}
