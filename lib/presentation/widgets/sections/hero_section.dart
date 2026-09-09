import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/resume_download/resume_download.dart';
import '../../../domain/models/profile_models.dart';
import '../common/section_wrapper.dart';

class HeroSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      verticalPadding: isDesktop ? 160 : 80,
      child: Column(
        children: [
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _maybeExpanded(
                expand: isDesktop,
                flex: 3,
                child: Column(
                  crossAxisAlignment:
                      isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: [
                    _ProfilePicture(imagePath: profile.profilePicture),
                    const SizedBox(height: 24),
                    _AvailabilityBadge(
                      location: '${profile.experienceBadge} • ${profile.location}',
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Building mobile\nexperiences that\npeople actually use.',
                      textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                      style: theme.textTheme.displayLarge?.copyWith(
                        height: 0.95,
                        letterSpacing: -3.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 540),
                      child: Text(
                        'Senior Mobile Application Developer specializing in Android, Kotlin, Flutter and modern application architecture.',
                        textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Android • Flutter • Kotlin • Jetpack Compose',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
                      children: [
                        _PrimaryButton(
                          label: 'View My Work',
                          onPressed: onViewWork,
                        ),
                        _SecondaryButton(
                          label: 'Download Resume',
                          onPressed: () async {
                            try {
                              await downloadResume(
                                profile.resumeAssetPath,
                                profile.resumeDownloadFileName,
                              );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Download failed: ${e.toString()}')),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _SocialLinks(
                      githubUrl: profile.githubUrl,
                      linkedInUrl: profile.linkedInUrl,
                      email: profile.email,
                    ),
                  ],
                ),
              ),
              if (isDesktop) const SizedBox(width: 40),
              if (!isDesktop) const SizedBox(height: 80),
              _maybeExpanded(
                expand: isDesktop,
                flex: 2,
                child: const _HeroVisual(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow
          Positioned(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          // Floating Device Frames
          const _FloatingDevice(
            offsetX: -100,
            offsetY: -80,
            delay: 0,
            child: _DeviceFrame(
              width: 140,
              height: 280,
              label: 'Android',
              icon: Icons.android_rounded,
              color: Color(0xFF3DDC84),
            ),
          ),
          const _FloatingDevice(
            offsetX: 80,
            offsetY: -120,
            delay: 400,
            child: _DeviceFrame(
              width: 130,
              height: 260,
              label: 'iOS',
              icon: Icons.apple_rounded,
              color: Colors.white,
            ),
          ),
          const _FloatingDevice(
            offsetX: -40,
            offsetY: 80,
            delay: 800,
            child: _DeviceFrame(
              width: 220,
              height: 140,
              label: 'Web',
              icon: Icons.language_rounded,
              color: Colors.blue,
            ),
          ),
          const _FloatingDevice(
            offsetX: 120,
            offsetY: 40,
            delay: 1200,
            child: _DeviceFrame(
              width: 180,
              height: 120,
              label: 'Desktop',
              icon: Icons.desktop_windows_rounded,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingDevice extends StatefulWidget {
  final double offsetX;
  final double offsetY;
  final int delay;
  final Widget child;

  const _FloatingDevice({
    required this.offsetX,
    required this.offsetY,
    required this.delay,
    required this.child,
  });

  @override
  State<_FloatingDevice> createState() => _FloatingDeviceState();
}

class _FloatingDeviceState extends State<_FloatingDevice>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(widget.offsetX, widget.offsetY + _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _DeviceFrame extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final IconData icon;
  final Color color;

  const _DeviceFrame({
    required this.width,
    required this.height,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(icon, color: color.withValues(alpha: 0.5), size: 32),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _SecondaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.onSurface,
        side: BorderSide(color: theme.dividerColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}

class _SocialLinks extends StatelessWidget {
  final String githubUrl;
  final String linkedInUrl;
  final String email;

  const _SocialLinks({
    required this.githubUrl,
    required this.linkedInUrl,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialIcon(
          icon: Icons.code_rounded,
          onTap: () => LaunchHelper.openUrl(githubUrl),
          label: 'GitHub',
        ),
        const SizedBox(width: 24),
        _SocialIcon(
          icon: Icons.person_add_alt_1_rounded,
          onTap: () => LaunchHelper.openUrl(linkedInUrl),
          label: 'LinkedIn',
        ),
        const SizedBox(width: 24),
        _SocialIcon(
          icon: Icons.alternate_email_rounded,
          onTap: () => LaunchHelper.sendEmail(email),
          label: 'Email',
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String label;

  const _SocialIcon({
    required this.icon,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
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

class _ProfilePicture extends StatelessWidget {
  final String imagePath;
  const _ProfilePicture({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.person_rounded,
                size: 40,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  final String location;
  const _AvailabilityBadge({required this.location});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            location,
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
