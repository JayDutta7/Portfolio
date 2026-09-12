import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/device_mockup.dart';
import '../common/glass_container.dart';
import '../common/gradient_text.dart';
import '../common/section_wrapper.dart';
import '../../pages/project_details_page.dart';

class ProjectsSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ProjectsSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    // Grouping projects: Open Source vs Company Apps
    final openSource = profile.projects.where((p) => p.links.any((l) => l.type == ProjectLinkType.github)).toList();
    final companyApps = profile.projects.where((p) => !openSource.contains(p)).toList();

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _RichSectionHeader(title: 'FEATURED PRODUCTS', index: '01'),
          const SizedBox(height: 56),
          for (final project in companyApps)
            _ProductShowcaseCard(project: project),

          if (openSource.isNotEmpty) ...[
            const SizedBox(height: 120),
            const _RichSectionHeader(title: 'OPEN SOURCE & LABS', index: '02'),
            const SizedBox(height: 56),
            _TechnicalProjectGrid(projects: openSource),
          ],
        ],
      ),
    );
  }
}

class _RichSectionHeader extends StatelessWidget {
  final String title;
  final String index;
  const _RichSectionHeader({required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Text(
            index,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.dividerColor,
                  theme.dividerColor.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductShowcaseCard extends StatefulWidget {
  final Project project;
  const _ProductShowcaseCard({required this.project});

  @override
  State<_ProductShowcaseCard> createState() => _ProductShowcaseCardState();
}

class _ProductShowcaseCardState extends State<_ProductShowcaseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    // Pick brand color based on platform/project
    final isFlutter = widget.project.stackSummary.contains('Flutter');
    final accentColor = isFlutter ? AppColors.flutterBlue : AppColors.androidGreen;

    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GlassContainer(
          padding: EdgeInsets.all(isDesktop ? 48 : 28),
          borderColor: _isHovered ? accentColor.withValues(alpha: 0.5) : null,
          glowColor: accentColor,
          child: Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            children: [
              _maybeExpanded(
                expand: isDesktop,
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _TechTagRich(
                          label: widget.project.platforms.join(' • '),
                          color: accentColor,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.project.period,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GradientText(
                      widget.project.title,
                      colors: isFlutter
                          ? [Colors.white, AppColors.flutterBlue]
                          : [Colors.white, AppColors.androidGreen],
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: isDesktop ? 38 : 28,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.project.overview,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                        height: 1.65,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _InfoItemRich(label: 'ENGINEERING STACK', content: widget.project.stackSummary),
                    const SizedBox(height: 16),
                    _InfoItemRich(label: 'MY ROLE', content: widget.project.myRole),
                    const SizedBox(height: 40),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _PrimaryAction(
                          label: 'VIEW CASE STUDY',
                          color: accentColor,
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    ProjectDetailsPage(project: widget.project),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(opacity: animation, child: child);
                                },
                              ),
                            );
                          },
                        ),
                        if (widget.project.links.isNotEmpty) ...[
                          for (final link in widget.project.links)
                            _LinkPill(link: link),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (isDesktop) const SizedBox(width: 60),
              if (!isDesktop) const SizedBox(height: 48),
              _maybeExpanded(
                expand: isDesktop,
                flex: 4,
                child: Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: _isHovered ? 1.04 : 1.0,
                    child: DeviceMockup(
                      title: widget.project.title,
                      assetPath: widget.project.screenshotUrl,
                      fallbackIcon: isFlutter ? Icons.flutter_dash_rounded : Icons.android_rounded,
                      glowColor: accentColor,
                      width: 220,
                      height: 450,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkPill extends StatelessWidget {
  final ProjectLink link;
  const _LinkPill({required this.link});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: link.label,
      child: InkWell(
        onTap: () => LaunchHelper.openUrl(link.url),
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_linkIcon(link.type), size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                link.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _linkIcon(ProjectLinkType type) {
    switch (type) {
      case ProjectLinkType.playStore: return Icons.shop_outlined;
      case ProjectLinkType.appStore: return Icons.apple;
      case ProjectLinkType.web: return Icons.language_rounded;
      case ProjectLinkType.github: return Icons.code_rounded;
    }
  }
}

class _TechnicalProjectGrid extends StatelessWidget {
  final List<Project> projects;
  const _TechnicalProjectGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktopOrWider(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 3 : 1,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: isDesktop ? 1.2 : 1.4,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) => _TechnicalCardRich(project: projects[index]),
    );
  }
}

class _TechnicalCardRich extends StatelessWidget {
  final Project project;
  const _TechnicalCardRich({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      padding: const EdgeInsets.all(28),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProjectDetailsPage(project: project),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.code_rounded, size: 20, color: AppColors.primary),
              ),
              const Icon(Icons.arrow_outward_rounded, size: 20, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            project.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              project.overview,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              for (final tech in project.techStack.take(3))
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Text(
                    tech,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TechTagRich extends StatelessWidget {
  final String label;
  final Color color;
  const _TechTagRich({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          color: color,
          letterSpacing: 1,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _InfoItemRich extends StatelessWidget {
  final String label;
  final String content;
  const _InfoItemRich({required this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PrimaryAction({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.2,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
            ],
          ),
        ),
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
