import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DeviceMockup extends StatelessWidget {
  final String title;
  final String? assetPath;
  final IconData fallbackIcon;
  final Color glowColor;
  final double width;
  final double height;
  final double borderRadius;
  final bool showHeaderBar;

  const DeviceMockup({
    required this.title,
    this.assetPath,
    this.fallbackIcon = Icons.smartphone_rounded,
    this.glowColor = AppColors.primary,
    this.width = 240,
    this.height = 480,
    this.borderRadius = 40,
    this.showHeaderBar = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D0E15) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark ? const Color(0xFF2E3547) : const Color(0xFF475569),
          width: 8,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: isDark ? 0.25 : 0.15),
            blurRadius: 50,
            spreadRadius: -4,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 6),
        child: Stack(
          children: [
            // Screen Background
            Positioned.fill(
              child: Container(
                color: isDark ? const Color(0xFF0F121C) : const Color(0xFFF1F5F9),
              ),
            ),

            // Image Content or Fallback
            if (assetPath != null)
              Positioned.fill(
                child: Image.asset(
                  assetPath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _FallbackScreen(
                    title: title,
                    icon: fallbackIcon,
                    glowColor: glowColor,
                  ),
                ),
              )
            else
              Positioned.fill(
                child: _FallbackScreen(
                  title: title,
                  icon: fallbackIcon,
                  glowColor: glowColor,
                ),
              ),

            // Glass Sheen Reflection
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: const Alignment(0.4, 0.4),
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Status Bar & Notch / Dynamic Island
            if (showHeaderBar) ...[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.black.withValues(alpha: 0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '9:41',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // Dynamic Island pill
                      Container(
                        width: 48,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.wifi, size: 10, color: Colors.white),
                          SizedBox(width: 4),
                          Icon(Icons.battery_full, size: 10, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Bottom indicator bar
            Positioned(
              bottom: 6,
              left: width * 0.3,
              right: width * 0.3,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FallbackScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color glowColor;

  const _FallbackScreen({
    required this.title,
    required this.icon,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            glowColor.withValues(alpha: 0.15),
            AppColors.darkSurface,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: glowColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: glowColor.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, size: 48, color: glowColor),
          ),
          const SizedBox(height: 20),
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
