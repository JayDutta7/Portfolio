import 'dart:ui';
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
  final Widget? customScreen;

  const DeviceMockup({
    required this.title,
    this.assetPath,
    this.fallbackIcon = Icons.smartphone_rounded,
    this.glowColor = AppColors.primary,
    this.width = 240,
    this.height = 490,
    this.borderRadius = 44,
    this.showHeaderBar = true,
    this.customScreen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: SizedBox(
        width: width + 8,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left Side Button (Volume Rocker)
            Positioned(
              left: 0,
              top: height * 0.22,
              child: Container(
                width: 3,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFF94A3B8),
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(2)),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: height * 0.33,
              child: Container(
                width: 3,
                height: 34,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFF94A3B8),
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(2)),
                ),
              ),
            ),
            // Right Side Button (Power)
            Positioned(
              right: 0,
              top: height * 0.25,
              child: Container(
                width: 3,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFF94A3B8),
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(2)),
                ),
              ),
            ),

            // Main Phone Chassis
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0D0E15) : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: isDark ? const Color(0xFF2E3547) : const Color(0xFF475569),
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: isDark ? 0.3 : 0.18),
                    blurRadius: 40,
                    spreadRadius: -4,
                    offset: const Offset(0, 16),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius - 5),
                child: Stack(
                  children: [
                    // Screen Background
                    Positioned.fill(
                      child: Container(
                        color: const Color(0xFF07090E),
                      ),
                    ),

                    // Screen Body Content
                    Positioned.fill(
                      child: customScreen ??
                          (assetPath != null
                              ? _ScreenshotViewer(
                                  assetPath: assetPath!,
                                  title: title,
                                  glowColor: glowColor,
                                  fallbackIcon: fallbackIcon,
                                  showHeaderBar: showHeaderBar,
                                )
                              : (title.toLowerCase().contains('logistics')
                                  ? const _CaptainLogisticsScreen()
                                  : _ModernFallbackScreen(
                                      title: title,
                                      icon: fallbackIcon,
                                      glowColor: glowColor,
                                    ))),
                    ),

                    // Modern Dynamic Island and Status Bar
                    if (showHeaderBar) ...[
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.65),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                '9:41',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              // Dynamic Island pill
                              Container(
                                width: 52,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 5,
                                      margin: const EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(alpha: 0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Row(
                                children: [
                                  Icon(Icons.wifi_rounded, size: 11, color: Colors.white),
                                  SizedBox(width: 4),
                                  Icon(Icons.battery_full_rounded, size: 12, color: Colors.white),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Glass Sheen Reflection
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: const Alignment(0.5, 0.5),
                              colors: [
                                Colors.white.withValues(alpha: 0.08),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom Home Indicator gesture bar
                    Positioned(
                      bottom: 6,
                      left: width * 0.32,
                      right: width * 0.32,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenshotViewer extends StatelessWidget {
  final String assetPath;
  final String title;
  final Color glowColor;
  final IconData fallbackIcon;
  final bool showHeaderBar;

  const _ScreenshotViewer({
    required this.assetPath,
    required this.title,
    required this.glowColor,
    required this.fallbackIcon,
    required this.showHeaderBar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: showHeaderBar ? 28 : 0,
        bottom: 14,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred background fill
          Image.asset(
            assetPath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.black.withValues(alpha: 0.4),
            ),
          ),
          // Crisp center image
          Center(
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) => _ModernFallbackScreen(
                title: title,
                icon: fallbackIcon,
                glowColor: glowColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CaptainLogisticsScreen extends StatelessWidget {
  const _CaptainLogisticsScreen();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 300,
        height: 560,
        child: Container(
          color: const Color(0xFF0B101E),
          padding: const EdgeInsets.fromLTRB(16, 38, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Header
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.local_shipping_rounded, size: 12, color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'CAPTAIN GPS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.emerald.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.emerald.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 3, backgroundColor: AppColors.emerald),
                        SizedBox(width: 4),
                        Text(
                          'ONLINE',
                          style: TextStyle(
                            color: AppColors.emerald,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Route Status Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF161E31),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'ROUTE #TR-8820',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w800,
                              fontSize: 9,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'ETA 38m',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.radio_button_checked, size: 11, color: AppColors.primary),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Kolkata Freight Hub',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      height: 10,
                      width: 1.5,
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 11, color: AppColors.emerald),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Durgapur Distribution Center',
                            style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Real-time Map Simulation Graphic
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E1626),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _MapGridPainter(),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.navigation_rounded, size: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Speed: 62 km/h', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700)),
                              Text('Signal: 5G', style: TextStyle(color: AppColors.emerald, fontSize: 8, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Action Button
              Container(
                width: double.infinity,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppColors.primaryGradient),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'LOG DISPATCH EVENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      letterSpacing: 1.2,
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

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 22) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double j = 0; j < size.height; j += 22) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
    }

    final routePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.5)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(20, size.height - 20)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.6, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.65, size.height * 0.35, size.width - 20, 20);

    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModernFallbackScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color glowColor;

  const _ModernFallbackScreen({
    required this.title,
    required this.icon,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF090D16),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: glowColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: glowColor.withValues(alpha: 0.35), width: 2),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.2),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Icon(icon, size: 34, color: glowColor),
          ),
          const SizedBox(height: 20),
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'PRODUCTION APPLICATION',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
