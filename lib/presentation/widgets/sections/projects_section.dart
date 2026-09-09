import 'package:flutter/material.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/section_wrapper.dart';
import '../../pages/project_details_page.dart';
import '../../../core/utils/asset_utils.dart';

class ProjectsSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ProjectsSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '01 / SELECTED WORK',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Products I\'ve helped\nbring to life.',
            style: theme.textTheme.displayMedium?.copyWith(
              height: 1.0,
            ),
          ),
          const SizedBox(height: 80),
          for (int i = 0; i < profile.projects.length; i++)
            _ProductProjectPage(
              project: profile.projects[i],
              index: i + 1,
            ),
        ],
      ),
    );
  }
}

class _ProductProjectPage extends StatelessWidget {
  final Project project;
  final int index;

  const _ProductProjectPage({required this.project, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                project.title.toUpperCase(),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2.0,
                ),
              ),
              const Spacer(),
              Text(
                project.platforms.join(' • '),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          _ProjectHeroVisual(project: project),
          const SizedBox(height: 64),
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _maybeExpanded(
                expand: isDesktop,
                flex: 1,
                child: _ProjectInfoItem(
                  label: 'What I built',
                  content: project.overview,
                ),
              ),
              if (isDesktop) const SizedBox(width: 40),
              if (!isDesktop) const SizedBox(height: 32),
              _maybeExpanded(
                expand: isDesktop,
                flex: 1,
                child: _ProjectInfoItem(
                  label: 'Engineering',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final tech in project.techStack.take(5))
                        _TechTag(label: tech),
                    ],
                  ),
                ),
              ),
              if (isDesktop) const SizedBox(width: 40),
              if (!isDesktop) const SizedBox(height: 32),
              _maybeExpanded(
                expand: isDesktop,
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProjectInfoItem(
                      label: 'My role',
                      content: project.myRole,
                    ),
                    if (project.links.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      _ProjectLinksRow(links: project.links),
                    ],
                    const SizedBox(height: 32),
                    _ViewCaseStudyAction(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                ProjectDetailsPage(project: project),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                          ),
                        );
                      },
                    ),
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

class _ProjectHeroVisual extends StatelessWidget {
  final Project project;
  const _ProjectHeroVisual({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = project.platforms.contains('Android') || project.platforms.contains('iOS');

    return Container(
      width: double.infinity,
      height: 500,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: theme.dividerColor, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.03,
            child: Icon(
              isMobile ? Icons.smartphone_rounded : Icons.laptop_rounded,
              size: 400,
            ),
          ),
          Center(
            child: _ProductMockup(isMobile: isMobile, color: theme.colorScheme.primary, projectTitle: project.title),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    theme.colorScheme.surface.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductMockup extends StatelessWidget {
  final bool isMobile;
  final Color color;
  final String projectTitle;

  const _ProductMockup({required this.isMobile, required this.color, required this.projectTitle});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      final asset = screenshotAsset(projectTitle, 'android');
      return Container(
        width: 260,
        height: 520,
        decoration: BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: const Color(0xFF1F1F21), width: 8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 48,
              offset: const Offset(0, 22),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.asset(
            asset,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Center(
              child: Opacity(
                opacity: 0.08,
                child: Icon(Icons.flutter_dash_rounded, size: 72, color: color),
              ),
            ),
          ),
        ),
      );
    }

    final asset = screenshotAsset(projectTitle, 'tablet');
    return Container(
      width: 720,
      height: 420,
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F1F21), width: 6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.42),
            blurRadius: 44,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Center(
            child: Opacity(
              opacity: 0.08,
              child: Icon(Icons.language_rounded, size: 96, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectInfoItem extends StatelessWidget {
  final String label;
  final String? content;
  final Widget? child;

  const _ProjectInfoItem({required this.label, this.content, this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        if (content != null)
          Text(
            content!,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        if (child != null) child!,
      ],
    );
  }
}

class _TechTag extends StatelessWidget {
  final String label;
  const _TechTag({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: theme.dividerColor, width: 0.5),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
      ),
    );
  }
}

class _ProjectLinksRow extends StatelessWidget {
  final List<ProjectLink> links;
  const _ProjectLinksRow({required this.links});

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
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: [
        for (final link in links)
          InkWell(
            onTap: () => LaunchHelper.openUrl(link.url),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_linkIcon(link.type), size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  link.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ViewCaseStudyAction extends StatelessWidget {
  final VoidCallback onTap;
  const _ViewCaseStudyAction({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'VIEW CASE STUDY',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.arrow_forward_rounded, size: 14),
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
