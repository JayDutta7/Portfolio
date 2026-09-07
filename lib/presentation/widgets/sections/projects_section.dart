import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/hover_card.dart';
import '../common/section_wrapper.dart';
import 'project_detail_dialog.dart';

class ProjectsSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ProjectsSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.gridColumns(context, max: 2);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Featured Projects',
            title: 'Enterprise apps shipped end-to-end',
            description:
                'A selection of production applications spanning native '
                'Android and Flutter. Tap a card for full project details.',
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 24.0;
              final cardWidth =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final project in profile.projects)
                    SizedBox(
                      width: cardWidth,
                      child: _ProjectCard(project: project),
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

class _ProjectCard extends StatelessWidget {
  final Project project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HoverCard(
      onTap: () => showProjectDetailDialog(context, project),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(project.title, style: theme.textTheme.titleLarge),
              ),
              Icon(Icons.north_east_rounded,
                  size: 18, color: theme.colorScheme.primary),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            project.period,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 12),
          Text(
            project.overview,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tech in project.techStack.take(4))
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(tech, style: theme.textTheme.bodyMedium),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
