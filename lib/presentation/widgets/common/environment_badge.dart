import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/app_environment.dart';

/// Floating environment watermark badge displayed exclusively on non-production
/// builds (DEV and UAT). Automatically hides on PRODUCTION builds.
class EnvironmentBadge extends StatefulWidget {
  const EnvironmentBadge({super.key});

  @override
  State<EnvironmentBadge> createState() => _EnvironmentBadgeState();
}

class _EnvironmentBadgeState extends State<EnvironmentBadge> {
  bool _isCollapsed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (AppEnvironment.isProd) {
      return const SizedBox.shrink();
    }

    final env = AppEnvironment.current;
    final color = env.badgeColor;

    return Positioned(
      left: 16,
      bottom: 16,
      child: Material(
        color: Colors.transparent,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: _isCollapsed ? 8 : 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withValues(alpha: _isHovered ? 0.95 : 0.85),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: color.withValues(alpha: _isHovered ? 0.8 : 0.4),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: _isHovered ? 0.25 : 0.12),
                  blurRadius: _isHovered ? 16 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing environment status dot
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.7),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                if (!_isCollapsed) ...[
                  const SizedBox(width: 8),
                  Text(
                    'ENV: ${env.label}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => setState(() => _isCollapsed = true),
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.close_rounded,
                        size: 13,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => setState(() => _isCollapsed = false),
                    child: Text(
                      env.label,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
