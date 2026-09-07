import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/resume_download/resume_download.dart';
import '../../../domain/models/profile_models.dart';
import '../common/app_buttons.dart';
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
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      verticalPadding: 140,
      background: null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? AppColors.heroGradientDark
                        : AppColors.heroGradientLight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 56,
                vertical: isMobile ? 48 : 72,
              ),
              child: Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _maybeExpanded(
                    flex: 3,
                    expand: !isMobile,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AvailabilityBadge(location: profile.location),
                        const SizedBox(height: 28),
                        Text(
                          'Hi, I\'m ${profile.name}',
                          style: (isMobile
                                  ? theme.textTheme.displayMedium
                                  : theme.textTheme.displayLarge)
                              ?.copyWith(height: 1.05),
                        ),
                        const SizedBox(height: 16),
                        ShaderMask(
                          shaderCallback: (rect) => const LinearGradient(
                            colors: AppColors.accentGradient,
                          ).createShader(rect),
                          child: Text(
                            profile.title,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${profile.subtitle} · ${profile.experienceBadge}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 620),
                          child: Text(
                            profile.heroIntro,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            GradientButton(
                              label: 'View My Work',
                              icon: Icons.grid_view_rounded,
                              onPressed: onViewWork,
                            ),
                            OutlineButton(
                              label: 'Download Resume',
                              icon: Icons.download_rounded,
                              onPressed: () => downloadResume(
                                profile.resumeAssetPath,
                                profile.resumeDownloadFileName,
                              ),
                            ),
                            OutlineButton(
                              label: 'Contact Me',
                              icon: Icons.mail_outline_rounded,
                              onPressed: () =>
                                  LaunchHelper.sendEmail(profile.email),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SocialIconButton(
                              icon: Icons.link_rounded,
                              tooltip: 'GitHub',
                              onPressed: () =>
                                  LaunchHelper.openUrl(profile.githubUrl),
                            ),
                            const SizedBox(width: 12),
                            SocialIconButton(
                              icon: Icons.business_center_outlined,
                              tooltip: 'LinkedIn',
                              onPressed: () =>
                                  LaunchHelper.openUrl(profile.linkedInUrl),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isMobile) const SizedBox(width: 48),
                  if (isMobile) const SizedBox(height: 48),
                  Center(
                    child: Container(
                      width: isMobile ? 200 : 300,
                      height: isMobile ? 200 : 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.surface,
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.2),
                          width: 8,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          profile.profilePicture,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('Image load error: $error');
                            return Container(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              child: Center(
                                child: Icon(
                                  Icons.person_rounded,
                                  size: isMobile ? 80 : 120,
                                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
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
