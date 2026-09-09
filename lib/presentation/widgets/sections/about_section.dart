import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/section_wrapper.dart';

class AboutSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const AboutSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '06 / ABOUT',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'More than a developer.',
            style: theme.textTheme.displaySmall?.copyWith(
              height: 1.0,
            ),
          ),
          const SizedBox(height: 80),
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop) ...[
                _AboutPortrait(imagePath: profile.profilePicture),
                const SizedBox(width: 80),
              ],
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isDesktop) ...[
                      _AboutPortrait(imagePath: profile.profilePicture),
                      const SizedBox(height: 48),
                    ],
                    Text(
                      profile.aboutMe,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        height: 1.7,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 48),
                    const _AboutFact(label: '9+ Years', content: 'Application development & engineering.'),
                    const SizedBox(height: 24),
                    const _AboutFact(label: 'Expertise', content: 'Native Android depth + Flutter cross-platform speed.'),
                    const SizedBox(height: 24),
                    const _AboutFact(label: 'Product', content: 'End-to-end delivery from requirements to Play Store.'),
                  ],
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
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor, width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.person_rounded, size: 80, color: Colors.white10),
        ),
      ),
    );
  }
}

class _AboutFact extends StatelessWidget {
  final String label;
  final String content;

  const _AboutFact({required this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}
