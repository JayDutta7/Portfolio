import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A reusable interactive Bento card wrapper engineered with:
/// - Glassmorphic Slate surface (`#0F1624` @ 75% opacity) + `BackdropFilter`
/// - Default 1px `#1E293B` solid border
/// - Micro-interaction: Translates `-4px` on Y-axis with `duration: 220ms` and `Curves.easeOutCubic`
/// - Border brightening to Electric Cyan (`#38BDF8`) or Emerald (`#10B981`)
/// - Soft outer box-shadow ambient glow
class HoverBentoCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? hoverBorderColor;
  final Color? hoverGlowColor;
  final Color accentGlowColor;
  final VoidCallback? onTap;
  final bool enableHover;
  final double blurSigma;
  final double hoverOffsetY;
  final Duration duration;
  final Curve curve;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;

  const HoverBentoCard({
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.margin,
    this.borderRadius = 20.0,
    this.backgroundColor,
    this.borderColor,
    this.hoverBorderColor,
    this.hoverGlowColor,
    this.accentGlowColor = AppColors.electricCyan,
    this.onTap,
    this.enableHover = true,
    this.blurSigma = 16.0,
    this.hoverOffsetY = -4.0,
    this.duration = const Duration(milliseconds: 220),
    this.curve = Curves.easeOutCubic,
    this.constraints,
    this.width,
    this.height,
    super.key,
  });

  @override
  State<HoverBentoCard> createState() => _HoverBentoCardState();
}

class _HoverBentoCardState extends State<HoverBentoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveHoverBorder = widget.hoverBorderColor ?? widget.accentGlowColor;
    final effectiveBorder = _isHovered && widget.enableHover
        ? effectiveHoverBorder
        : (widget.borderColor ?? AppColors.cardBorder);

    final effectiveGlowColor = widget.hoverGlowColor ??
        (widget.hoverBorderColor ?? widget.accentGlowColor).withValues(alpha: 0.28);

    final isElevated = _isHovered && widget.enableHover;

    return Container(
      margin: widget.margin,
      constraints: widget.constraints,
      width: widget.width,
      height: widget.height,
      child: MouseRegion(
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) {
          if (widget.enableHover && !_isHovered) {
            setState(() => _isHovered = true);
          }
        },
        onExit: (_) {
          if (widget.enableHover && _isHovered) {
            setState(() => _isHovered = false);
          }
        },
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: widget.duration,
            curve: widget.curve,
            transform: Matrix4.translationValues(
              0,
              isElevated ? widget.hoverOffsetY : 0.0,
              0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: effectiveBorder,
                width: 1.0,
              ),
              boxShadow: isElevated
                  ? [
                      BoxShadow(
                        color: effectiveGlowColor,
                        blurRadius: 28,
                        spreadRadius: 0,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.55),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                (widget.borderRadius - 1).clamp(0.0, 999.0),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.blurSigma,
                  sigmaY: widget.blurSigma,
                ),
                child: Container(
                  color: widget.backgroundColor ?? AppColors.cardSurface,
                  padding: widget.padding,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

