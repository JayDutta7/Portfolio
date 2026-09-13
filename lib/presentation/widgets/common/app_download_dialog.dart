import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/distribution_helper.dart';
import 'glass_container.dart';

class AppDownloadDialog extends StatelessWidget {
  const AppDownloadDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (context) => const AppDownloadDialog(),
    );
  }

  void _downloadApk(BuildContext context) {
    DistributionHelper.downloadReleaseApk();
    Navigator.of(context).pop();
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

  Future<void> _installPwa(BuildContext context) async {
    final installed = await DistributionHelper.installPwa();
    if (context.mounted) {
      Navigator.of(context).pop();
      if (installed) {
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 24,
      ),
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: GlassContainer(
          padding: EdgeInsets.all(isMobile ? 22 : 30),
          borderRadius: 24,
          borderColor: AppColors.primary.withValues(alpha: 0.35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top header with Android Pill & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.androidGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.androidGreen.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.android_rounded, size: 14, color: AppColors.androidGreen),
                        const SizedBox(width: 6),
                        Text(
                          'ANDROID APP READY',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.androidGreen,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    splashRadius: 18,
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Android Logo Icon with radial aura
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.androidGreen.withValues(alpha: 0.22),
                      AppColors.primary.withValues(alpha: 0.12),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.androidGreen.withValues(alpha: 0.4), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.androidGreen.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.android_rounded,
                  size: 38,
                  color: AppColors.androidGreen,
                ),
              ),
              const SizedBox(height: 18),

              // Headline
              Text(
                'Experience Native Android App',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: isMobile ? 20 : 23,
                ),
              ),
              const SizedBox(height: 10),

              // Description
              Text(
                'Download the production Release APK to test real mobile performance, offline caching, and native Android architecture directly on your device.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  height: 1.5,
                  fontSize: isMobile ? 13 : 14,
                ),
              ),
              const SizedBox(height: 24),

              // Primary Action: Download APK Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _downloadApk(context),
                  icon: const Icon(Icons.download_rounded, size: 20, color: Colors.white),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'DOWNLOAD RELEASE APK',
                      style: GoogleFonts.jetBrainsMono(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.androidGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                    shadowColor: AppColors.androidGreen.withValues(alpha: 0.4),
                  ),
                ),
              ),

              // Conditional PWA Button
              ValueListenableBuilder<bool>(
                valueListenable: DistributionHelper.isPwaInstallable,
                builder: (context, canInstall, _) {
                  if (canInstall) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _installPwa(context),
                          icon: const Icon(Icons.install_mobile_rounded, size: 18),
                          label: Text(
                            'INSTALL PWA WEB APP',
                            style: GoogleFonts.jetBrainsMono(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 12),

              // Secondary Dismiss Action
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'CONTINUE IN BROWSER',
                  style: GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    fontSize: 11.5,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
