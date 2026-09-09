import 'package:flutter/material.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/hover_card.dart';
import '../common/section_wrapper.dart';
import '../../pages/project_details_page.dart';

class ProjectsSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ProjectsSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Portfolio',
            title: 'Selected Projects',
          ),
          const SizedBox(height: 24),
          for (int i = 0; i < profile.projects.length; i++)
            _LargeProjectCard(
              project: profile.projects[i],
              isReversed: i % 2 != 0,
            ),
        ],
      ),
    );
  }
}

class _LargeProjectCard extends StatelessWidget {
  final Project project;
  final bool isReversed;

  const _LargeProjectCard({
    required this.project,
    required this.isReversed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 80),
      child: Flex(
        direction: isDesktop ? Axis.horizontal : Axis.vertical,
        textDirection: isReversed && isDesktop ? TextDirection.rtl : TextDirection.ltr,
        children: [
          _maybeExpanded(
            expand: isDesktop,
            flex: 6,
            child: _ProjectVisual(project: project),
          ),
          if (isDesktop) const SizedBox(width: 80),
          if (!isDesktop) const SizedBox(height: 32),
          _maybeExpanded(
            expand: isDesktop,
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TechChips(techStack: project.techStack.take(3).toList()),
                const SizedBox(height: 24),
                Text(
                  project.title,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  project.overview,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 32),
                _ProjectDetailRow(label: 'Platform', value: project.platforms.join(' • ')),
                const SizedBox(height: 12),
                _ProjectDetailRow(label: 'My Role', value: project.myRole),
                if (project.links.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _ProjectLinksRow(links: project.links),
                ],
                const SizedBox(height: 48),
                _CaseStudyButton(
                  onPressed: () {
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

class _ProjectVisual extends StatelessWidget {
  final Project project;
  const _ProjectVisual({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = project.platforms.contains('Android') || project.platforms.contains('iOS');

    return HoverCard(
      borderRadius: 24,
      padding: EdgeInsets.zero,
      child: Container(
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background pattern or glow
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Icon(
                  isMobile ? Icons.smartphone_rounded : Icons.laptop_rounded,
                  size: 200,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            // Generic Device Mockup
            if (isMobile)
              _PhoneMockup(color: theme.colorScheme.primary)
            else
              _BrowserMockup(color: theme.colorScheme.primary),
            
            // Text indicator for missing screenshot
            Positioned(
              bottom: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  project.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneMockup extends StatelessWidget {
  final Color color;
  const _PhoneMockup({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white24, width: 6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Icon(Icons.flutter_dash_rounded, color: color.withValues(alpha: 0.3), size: 48),
      ),
    );
  }
}

class _BrowserMockup extends StatelessWidget {
  final Color color;
  const _BrowserMockup({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                for (int i = 0; i < 3; i++)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Icon(Icons.web_rounded, color: color.withValues(alpha: 0.3), size: 48),
            ),
          ),
        ],
      ),
    );
  }
}

class _TechChips extends StatelessWidget {
  final List<String> techStack;
  const _TechChips({required this.techStack});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tech in techStack)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
            ),
            child: Text(
              tech,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _ProjectDetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _ProjectDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          '$label: ',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
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
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CaseStudyButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _CaseStudyButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'View Case Study',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward_rounded, size: 20, color: theme.colorScheme.primary),
        ],
      ),
    );
  }
}
