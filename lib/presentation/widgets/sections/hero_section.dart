import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/resume_download/resume_download.dart';
import '../../../domain/models/profile_models.dart';
import '../../viewmodels/locale_viewmodel.dart';
import '../common/device_mockup.dart';
import '../common/glass_container.dart';
import '../common/gradient_text.dart';
import '../common/pulse_badge.dart';
import '../common/section_wrapper.dart';

class HeroSection extends ConsumerWidget {
  final Profile profile;
  final VoidCallback onViewWork;
  final GlobalKey? sectionKey;

  const HeroSection({
    required this.profile,
    required this.onViewWork,
    this.sectionKey,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentLanguage = ref.watch(localeProvider);

    return SizedBox(
      key: sectionKey,
      width: double.infinity,
      child: SectionWrapper(
        verticalPadding: isDesktop ? 120 : 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _maybeExpanded(
                  expand: isDesktop,
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                    children: [
                      PulseBadge(
                        label: currentLanguage.heroBadge,
                        dotColor: AppColors.primary,
                      ),
                      const SizedBox(height: 28),
                      GradientText(
                        currentLanguage.heroHeadline,
                        colors: isDark
                            ? AppColors.heroTitleGradient
                            : AppColors.heroTitleGradientLight,
                        textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: isDesktop ? 68 : 42,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                          letterSpacing: -2.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 580),
                        child: Text(
                          profile.heroIntro,
                          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            height: 1.65,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
                        children: [
                          _PrimaryCTAButton(
                            label: currentLanguage.downloadCv,
                            icon: Icons.download_rounded,
                            onPressed: () async {
                              try {
                                await downloadResume(profile.resumeAssetPath, profile.resumeDownloadFileName);
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Download failed: $e')),
                                  );
                                }
                              }
                            },
                          ),
                          _SecondaryCTAButton(
                            label: currentLanguage.exploreWork,
                            icon: Icons.arrow_downward_rounded,
                            onPressed: onViewWork,
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
                        children: [
                          _SocialPill(
                            icon: Icons.code_rounded,
                            label: 'GitHub',
                            onTap: () => LaunchHelper.openUrl(profile.githubUrl),
                          ),
                          _SocialPill(
                            icon: Icons.work_rounded,
                            label: 'LinkedIn',
                            onTap: () => LaunchHelper.openUrl(profile.linkedInUrl),
                          ),
                          _SocialPill(
                            icon: Icons.email_rounded,
                            label: 'Email',
                            onTap: () => LaunchHelper.sendEmail(profile.email),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isDesktop) const SizedBox(width: 60),
                if (!isDesktop) const SizedBox(height: 48),
                _maybeExpanded(
                  expand: isDesktop,
                  flex: 5,
                  child: const Center(
                    child: _VisualShowcase(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VisualShowcase extends StatelessWidget {
  const _VisualShowcase();

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        height: 500,
        width: 480,
        child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background Phone (Ghareka PMT)
          Positioned(
            top: 20,
            right: 20,
            child: _FloatingWidget(
              delay: 400,
              child: DeviceMockup(
                title: 'Ghareka PMT',
                assetPath: 'assets/images/ghareka_pmt.jpeg',
                fallbackIcon: Icons.home_work_rounded,
                glowColor: AppColors.secondary,
                width: 210,
                height: 430,
              ),
            ),
          ),
          // Foreground Phone (Retail CRM)
          Positioned(
            top: 40,
            left: 20,
            child: _FloatingWidget(
              delay: 0,
              child: DeviceMockup(
                title: 'Retail CRM',
                assetPath: 'assets/images/crm.jpeg',
                fallbackIcon: Icons.dashboard_rounded,
                glowColor: AppColors.primary,
                width: 220,
                height: 440,
              ),
            ),
          ),

          // Floating Tech Pills with top positioning ONLY to prevent bottom-calculation relayout on Web
          Positioned(
            top: 0,
            left: 0,
            child: _FloatingTechPill(
              label: 'Kotlin • Compose',
              delay: 600,
              color: AppColors.androidGreen,
            ),
          ),
          Positioned(
            top: 410,
            right: 0,
            child: _FloatingTechPill(
              label: 'Flutter • Riverpod',
              delay: 800,
              color: AppColors.flutterBlue,
            ),
          ),
          Positioned(
            top: 440,
            left: 10,
            child: _FloatingTechPill(
              label: 'Clean Architecture',
              delay: 1000,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    ),
  );
}
}

class _PrimaryCTAButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _PrimaryCTAButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_PrimaryCTAButton> createState() => _PrimaryCTAButtonState();
}

class _PrimaryCTAButtonState extends State<_PrimaryCTAButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _isHovered ? 1.04 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _isHovered ? 0.45 : 0.25),
                blurRadius: _isHovered ? 28 : 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: widget.onPressed,
            icon: Icon(widget.icon, size: 18, color: Colors.white),
            label: Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryCTAButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _SecondaryCTAButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_SecondaryCTAButton> createState() => _SecondaryCTAButtonState();
}

class _SecondaryCTAButtonState extends State<_SecondaryCTAButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _isHovered ? 1.04 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: _isHovered ? 0.1 : 0.04)
                : Colors.black.withValues(alpha: _isHovered ? 0.06 : 0.02),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? theme.colorScheme.primary : theme.dividerColor,
              width: 1.5,
            ),
          ),
          child: OutlinedButton.icon(
            onPressed: widget.onPressed,
            icon: Icon(widget.icon, size: 18, color: theme.colorScheme.onSurface),
            label: Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
                fontSize: 13,
                color: theme.colorScheme.onSurface,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialPill extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SocialPill> createState() => _SocialPillState();
}

class _SocialPillState extends State<_SocialPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _isHovered
                ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.1)
                : (isDark ? AppColors.darkSurface : AppColors.lightSurfaceAlt),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _isHovered ? theme.colorScheme.primary : theme.dividerColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 14,
                color: _isHovered ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: _isHovered ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingTechPill extends StatelessWidget {
  final String label;
  final int delay;
  final Color color;

  const _FloatingTechPill({
    required this.label,
    required this.delay,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return _FloatingWidget(
      delay: delay,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        borderRadius: 100,
        borderColor: color.withValues(alpha: 0.4),
        glowColor: color,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingWidget extends StatefulWidget {
  final Widget child;
  final int delay;

  const _FloatingWidget({
    required this.child,
    required this.delay,
  });

  @override
  State<_FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<_FloatingWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _timer = Timer(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _animation.value),
        child: child,
      ),
      child: widget.child,
    );
  }
}

Widget _maybeExpanded({
  required bool expand,
  required int flex,
  required Widget child,
}) {
  if (expand) {
    return Expanded(flex: flex, child: child);
  }
  return child;
}
