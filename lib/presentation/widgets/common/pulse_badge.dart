import 'package:flutter/material.dart';

class PulseBadge extends StatefulWidget {
  final String label;
  final Color dotColor;
  final Color? backgroundColor;

  const PulseBadge({
    required this.label,
    this.dotColor = const Color(0xFF10B981),
    this.backgroundColor,
    super.key,
  });

  @override
  State<PulseBadge> createState() => _PulseBadgeState();
}

class _PulseBadgeState extends State<PulseBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            (isDark
                ? widget.dotColor.withValues(alpha: 0.12)
                : widget.dotColor.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: widget.dotColor.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.dotColor,
                boxShadow: [
                  BoxShadow(
                    color: widget.dotColor.withValues(alpha: _animation.value * 0.8),
                    blurRadius: 8,
                    spreadRadius: 2 * _animation.value,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              widget.label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
