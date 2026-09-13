import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/distribution_helper.dart';
import '../../../core/utils/responsive.dart';
import 'glass_container.dart';

class DistributionBar extends StatefulWidget {
  const DistributionBar({super.key});

  @override
  State<DistributionBar> createState() => _DistributionBarState();
}

class _DistributionBarState extends State<DistributionBar> {
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    DistributionHelper.init();
  }

  void _handleApkDownload() {
    DistributionHelper.downloadReleaseApk();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.download_done_rounded, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  kIsWeb
                      ? 'Release APK download triggered silently in your browser!'
                      : 'Opening official portfolio release download...',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.androidGreen.withValues(alpha: 0.95),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _handlePwaInstall() async {
    final installed = await DistributionHelper.installPwa();
    if (installed && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                'Portfolio PWA installation confirmed!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = Responsive.isDesktopOrWider(context);
    final isMobile = width < 768;
    final hPad = Responsive.pagePadding(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 16),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
          child: GlassContainer(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 28 : 16,
              vertical: isDesktop ? 20 : 16,
            ),
            borderColor: _isHovered ? AppColors.primary.withValues(alpha: 0.6) : null,
            glowColor: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Platform Indicators Row
                Wrap(
                  spacing: 16,
                  runSpacing: 14,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Platform Badges Group
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const _PlatformBadge(
                          icon: Icons.language_rounded,
                          label: 'WEB (LIVE 60 FPS)',
                          accentColor: AppColors.flutterBlue,
                          isLive: true,
                        ),
                        const _PlatformBadge(
                          icon: Icons.android_rounded,
                          label: 'ANDROID (APK READY)',
                          accentColor: AppColors.androidGreen,
                        ),
                        _PlatformBadge(
                          icon: Icons.apple_rounded,
                          label: 'PWA / DESKTOP READY',
                          accentColor: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ],
                    ),

                    // Direct Actions Row
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Direct APK Download Button
                        _ActionButton(
                          icon: Icons.download_rounded,
                          label: 'DOWNLOAD RELEASE APK',
                          accentColor: AppColors.androidGreen,
                          onTap: _handleApkDownload,
                          isFilled: true,
                        ),

                        // PWA Install Prompt Button (Conditional via JS-interop)
                        ValueListenableBuilder<bool>(
                          valueListenable: DistributionHelper.isPwaInstallable,
                          builder: (context, canInstall, _) {
                            if (canInstall) {
                              return _ActionButton(
                                icon: Icons.install_mobile_rounded,
                                label: 'INSTALL PWA APP',
                                accentColor: AppColors.primary,
                                onTap: _handlePwaInstall,
                                isFilled: false,
                              );
                            }
                            return _PwaStatusPill(isDesktop: isDesktop);
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Subtitle description & specs
                Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Multi-Platform Deployment: Standalone Web, Progressive Web App (PWA), and Production Release Android APK.',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: isMobile ? 10.5 : 11.5,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final bool isLive;

  const _PlatformBadge({
    required this.icon,
    required this.label,
    required this.accentColor,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLive) ...[
              Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: AppColors.emerald,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emerald.withValues(alpha: 0.8),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Icon(icon, size: 13, color: accentColor),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final VoidCallback onTap;
  final bool isFilled;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
    this.isFilled = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isFilled
                ? widget.accentColor.withValues(alpha: _isHovered ? 0.95 : 0.85)
                : widget.accentColor.withValues(alpha: _isHovered ? 0.2 : 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.isFilled
                  ? Colors.white.withValues(alpha: 0.25)
                  : widget.accentColor.withValues(alpha: _isHovered ? 0.8 : 0.4),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 15,
                  color: widget.isFilled ? Colors.white : widget.accentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: widget.isFilled ? Colors.white : widget.accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PwaStatusPill extends StatelessWidget {
  final bool isDesktop;
  const _PwaStatusPill({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.12)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.offline_bolt_outlined,
              size: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
            Text(
              'PWA READY',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
