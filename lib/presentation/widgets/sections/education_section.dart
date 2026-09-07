import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/hover_card.dart';
import '../common/section_wrapper.dart';

class EducationSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const EducationSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.gridColumns(context, max: 3);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Education',
            title: 'Academic background & certification',
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
                  for (final item in profile.education)
                    SizedBox(width: cardWidth, child: _EducationCard(item: item)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  final EducationItem item;
  const _EducationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HoverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.isCertification
                ? Icons.workspace_premium_outlined
                : Icons.school_outlined,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 14),
          Text(item.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(item.institution, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 10),
          Text(
            item.period,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.primary),
          ),
          if (item.detail != null) ...[
            const SizedBox(height: 4),
            Text(item.detail!, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
