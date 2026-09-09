import 'package:flutter/material.dart';
import '../../../domain/models/profile_models.dart';
import '../common/section_wrapper.dart';

class ExperienceSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ExperienceSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '05 / EXPERIENCE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '9 years of building.',
            style: theme.textTheme.displayMedium?.copyWith(
              height: 1.0,
            ),
          ),
          const SizedBox(height: 80),
          const _HorizontalTimeline(),
          const SizedBox(height: 100),
          _CurrentExperienceCard(item: profile.experience.first),
        ],
      ),
    );
  }
}

class _HorizontalTimeline extends StatelessWidget {
  const _HorizontalTimeline();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final milestones = [
      {'year': '2017', 'title': 'ANDROID'},
      {'year': '2019', 'title': 'PRODUCT'},
      {'year': '2020', 'title': 'FLUTTER'},
      {'year': '2022', 'title': 'ARCHITECTURE'},
      {'year': '2024', 'title': 'JETPACK COMPOSE'},
      {'year': '2026', 'title': 'SENIOR EXPERT'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < milestones.length; i++) ...[
            _TimelineMilestone(
              year: milestones[i]['year']!,
              title: milestones[i]['title']!,
            ),
            if (i < milestones.length - 1)
              Container(
                width: 100,
                height: 1,
                color: theme.dividerColor,
              ),
          ],
        ],
      ),
    );
  }
}

class _TimelineMilestone extends StatelessWidget {
  final String year;
  final String title;

  const _TimelineMilestone({required this.year, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          year,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }
}

class _CurrentExperienceCard extends StatelessWidget {
  final ExperienceItem item;
  const _CurrentExperienceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'CURRENT',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                item.period.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            item.role,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.company,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 48),
          for (final h in item.highlights)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Icon(Icons.arrow_forward_rounded, size: 14),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      h,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
