import 'package:flutter/material.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';

IconData _linkIcon(ProjectLinkType type) {
  switch (type) {
    case ProjectLinkType.playStore:
      return Icons.shop_outlined;
    case ProjectLinkType.appStore:
      return Icons.apple;
    case ProjectLinkType.web:
      return Icons.public;
    case ProjectLinkType.github:
      return Icons.code_rounded;
  }
}

Future<void> showProjectDetailDialog(BuildContext context, Project project) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => _ProjectDetailDialog(project: project),
  );
}

class _ProjectDetailDialog extends StatelessWidget {
  final Project project;
  const _ProjectDetailDialog({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);
    final width = isMobile ? MediaQuery.sizeOf(context).width * 0.94 : 640.0;

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width, maxHeight: 640),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(project.title, style: theme.textTheme.headlineMedium),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                Text(
                  project.period,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tech in project.techStack) _Chip(tech),
                  ],
                ),
                const SizedBox(height: 24),
                _DetailBlock(title: 'Overview', body: project.overview),
                _DetailBlock(title: 'My Role', body: project.myRole),
                if (project.architecture != null)
                  _DetailBlock(title: 'Architecture', body: project.architecture!)
                else
                  const _PlaceholderBlock(title: 'Architecture'),
                if (project.keyFeatures.isNotEmpty)
                  _BulletBlock(title: 'Key Features', items: project.keyFeatures),
                if (project.technicalChallenge != null)
                  _DetailBlock(
                    title: 'Technical Challenge',
                    body: project.technicalChallenge!,
                  ),
                if (project.solution != null)
                  _DetailBlock(title: 'Solution', body: project.solution!),
                if (project.technicalChallenge == null && project.solution == null)
                  const _PlaceholderBlock(title: 'Technical Challenges & Solutions'),
                if (project.platforms.isNotEmpty)
                  _BulletBlock(
                    title: 'Platform Availability',
                    items: project.platforms,
                    inline: true,
                  )
                else
                  const _PlaceholderBlock(title: 'Platform Availability'),
                if (project.links.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Links', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final link in project.links)
                        OutlinedButton.icon(
                          onPressed: () => LaunchHelper.openUrl(link.url),
                          icon: Icon(_linkIcon(link.type), size: 16),
                          label: Text(link.label),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  final String title;
  final String body;
  const _DetailBlock({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _BulletBlock extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool inline;
  const _BulletBlock({required this.title, required this.items, this.inline = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          inline
              ? Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [for (final i in items) _Chip(i)],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final i in items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 7),
                              child: Icon(Icons.circle, size: 5),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child:
                                    Text(i, style: theme.textTheme.bodyMedium)),
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

class _PlaceholderBlock extends StatelessWidget {
  final String title;
  const _PlaceholderBlock({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.dividerColor,
                style: BorderStyle.solid,
              ),
            ),
            child: Text(
              'TODO: add details for "$title" — not present in the resume.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
