import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/glass_container.dart';
import '../common/gradient_text.dart';
import '../common/section_wrapper.dart';

class AboutSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const AboutSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);
    final isDark = theme.brightness == Brightness.dark;

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '06 / ABOUT ME',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GradientText(
            'More than a developer.',
            colors: isDark
                ? [Colors.white, AppColors.secondary, AppColors.primary]
                : [AppColors.lightTextPrimary, AppColors.primary],
            style: theme.textTheme.displayMedium?.copyWith(
              height: 1.05,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 64),
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop) ...[
                _AboutPortrait(imagePath: profile.profilePicture),
                const SizedBox(width: 60),
              ],
              _maybeExpanded(
                expand: isDesktop,
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isDesktop) ...[
                      Center(child: _AboutPortrait(imagePath: profile.profilePicture)),
                      const SizedBox(height: 40),
                    ],
                    Text(
                      profile.aboutMe,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        height: 1.8,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              if (isDesktop) const SizedBox(width: 40),
              if (!isDesktop) const SizedBox(height: 40),
              _maybeExpanded(
                expand: isDesktop,
                flex: 4,
                child: GlassContainer(
                  padding: const EdgeInsets.all(36),
                  glowColor: AppColors.primary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _AboutFactRich(label: 'EXPERIENCE', value: '9+ Years', sub: 'Native Android & Flutter'),
                      const SizedBox(height: 24),
                      Divider(color: theme.dividerColor.withValues(alpha: 0.3)),
                      const SizedBox(height: 24),
                      _AboutFactRich(label: 'LOCATION', value: profile.location, sub: 'West Bengal, India'),
                      const SizedBox(height: 24),
                      Divider(color: theme.dividerColor.withValues(alpha: 0.3)),
                      const SizedBox(height: 24),
                      const _AboutFactRich(label: 'EXPERTISE', value: 'Android · Kotlin · Flutter', sub: 'Clean Architecture & MVVM'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutPortrait extends StatelessWidget {
  final String imagePath;
  const _AboutPortrait({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 280,
      height: 380,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 40,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.person_rounded, size: 80, color: AppColors.primary),
        ),
      ),
    );
  }
}

class _AboutFactRich extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  const _AboutFactRich({required this.label, required this.value, required this.sub});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: 1.5,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          sub,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
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
