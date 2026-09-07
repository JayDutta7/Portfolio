import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/hover_card.dart';
import '../common/section_wrapper.dart';

class SkillsSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const SkillsSection({required this.profile, this.sectionKey, super.key});

  IconData _iconFor(String key) {
    switch (key) {
      case 'android':
        return Icons.android;
      case 'flutter':
        return Icons.flutter_dash;
      case 'database':
        return Icons.storage_rounded;
      case 'tools':
        return Icons.build_circle_outlined;
      default:
        return Icons.hub_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.gridColumns(context, max: 3);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Technical Skills',
            title: 'A senior-level, production-tested toolkit',
            description:
                'Native Android and Flutter, backed by solid architecture, '
                'data and tooling fundamentals.',
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 20.0;
              final cardWidth =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final category in profile.skillCategories)
                    SizedBox(
                      width: cardWidth,
                      child: _SkillCard(
                        category: category,
                        icon: _iconFor(category.iconAsset),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final SkillCategory category;
  final IconData icon;

  const _SkillCard({required this.category, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HoverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 18),
          Text(category.title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final skill in category.skills)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(skill, style: theme.textTheme.bodyMedium),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
