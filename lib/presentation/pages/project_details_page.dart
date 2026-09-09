import 'package:flutter/material.dart';
import '../../core/utils/launch_helper.dart';
import '../../domain/models/profile_models.dart';
import '../widgets/common/section_wrapper.dart';

class ProjectDetailsPage extends StatelessWidget {
  final Project project;

  const ProjectDetailsPage({required this.project, super.key});

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                project.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.8),
                          theme.colorScheme.surface,
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(
                      project.platforms.contains('Android') || project.platforms.contains('iOS')
                          ? Icons.smartphone_rounded
                          : Icons.laptop_rounded,
                      size: 200,
                      color: Colors.white10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SectionWrapper(
              verticalPadding: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Section(title: '01 — Overview', content: project.overview),
                  _Section(title: '02 — The Challenge', content: project.technicalChallenge ?? 'Ensuring high performance and reliability in enterprise environments.'),
                  _Section(title: '03 — My Role', content: project.myRole),
                  if (project.architecture != null)
                    _Section(title: '04 — Architecture', content: project.architecture!),
                  _Section(
                    title: '05 — Technology',
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final tech in project.techStack)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
                            ),
                            child: Text(tech, style: theme.textTheme.labelLarge),
                          ),
                      ],
                    ),
                  ),
                  if (project.keyFeatures.isNotEmpty)
                    _Section(
                      title: '06 — Key Features',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final feature in project.keyFeatures)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check_circle_rounded, size: 20, color: theme.colorScheme.primary),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(feature, style: theme.textTheme.bodyLarge)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  _Section(title: '07 — Result', content: project.solution ?? 'Successfully deployed to production with high user engagement and stability.'),
                  if (project.links.isNotEmpty)
                    _Section(
                      title: '08 — Project Links',
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          for (final link in project.links)
                            ElevatedButton.icon(
                              onPressed: () => LaunchHelper.openUrl(link.url),
                              icon: Icon(_linkIcon(link.type), size: 18),
                              label: Text(link.label),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? child;

  const _Section({required this.title, this.content, this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),
          if (content != null)
            Text(
              content!,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                height: 1.6,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
