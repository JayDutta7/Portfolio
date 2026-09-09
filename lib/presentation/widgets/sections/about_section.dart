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
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isDesktop) ...[
                _AboutPicture(imagePath: profile.profilePicture),
                const SizedBox(height: 32),
              ],
              _maybeExpanded(
                expand: isDesktop,
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Engineer.\nBuilder.\nProblem Solver.',
                      style: theme.textTheme.displayMedium?.copyWith(
                        height: 1.1,
                        letterSpacing: -2.0,
                      ),
                    ),
                    if (isDesktop) ...[
                      const SizedBox(height: 48),
                      _AboutPicture(imagePath: profile.profilePicture),
                    ],
                  ],
                ),
              ),
              if (!isDesktop) const SizedBox(height: 32),
              _maybeExpanded(
                expand: isDesktop,
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.aboutMe,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          const _TechnicalTimeline(),
        ],
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

class _AboutPicture extends StatelessWidget {
  final String imagePath;
  const _AboutPicture({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 240,
      height: 300,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              Icons.person_rounded,
              size: 80,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          );
        },
      ),
    );
  }
}

class _TechnicalTimeline extends StatelessWidget {
  const _TechnicalTimeline();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final milestones = [
      {'year': '2017', 'title': 'Android Development'},
      {'year': '2019', 'title': 'Product Development'},
      {'year': '2020', 'title': 'Flutter'},
      {'year': '2022', 'title': 'Jetpack Compose'},
      {'year': '2024', 'title': 'Modern Architecture'},
      {'year': '2026', 'title': 'Senior Expert'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TECHNICAL EVOLUTION',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 32),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = milestones.length - 1; i >= 0; i--) ...[
                _TimelineItem(
                  year: milestones[i]['year']!,
                  title: milestones[i]['title']!,
                  isLast: i == 0,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String year;
  final String title;
  final bool isLast;

  const _TimelineItem({
    required this.year,
    required this.title,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              year,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (!isLast)
          Container(
            width: 60,
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            color: theme.dividerColor,
          ),
      ],
    );
  }
}
