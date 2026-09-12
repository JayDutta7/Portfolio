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
    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _RichSectionHeader(title: 'MOBILE APPLICATIONS & PRODUCTS', index: '01'),
          const SizedBox(height: 56),
          for (final project in profile.projects)
            _ProductShowcaseCard(project: project),
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
    final isDesktop = Responsive.isDesktopOrWider(context);
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
        Flexible(
          child: Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: isDesktop ? 3 : 1.5,
              fontSize: isDesktop ? 16 : 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isDesktop) ...[
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
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _TechTagRich(
                          label: widget.project.platforms.join(' • '),
                          color: accentColor,
                        ),
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
                    const SizedBox(height: 28),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TECHNOLOGIES & LIBRARIES',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                            fontSize: 10,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _ProjectTechTags(
                          techStack: widget.project.techStack,
                          primaryColor: accentColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _InfoItemRich(label: 'MY ROLE', content: widget.project.myRole),
                    const SizedBox(height: 36),
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
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 240),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 300),
                        scale: _isHovered ? 1.03 : 1.0,
                        child: DeviceMockup(
                          title: widget.project.title,
                          assetPath: widget.project.screenshotUrl,
                          fallbackIcon: isFlutter ? Icons.flutter_dash_rounded : Icons.android_rounded,
                          glowColor: accentColor,
                          width: 220,
                          height: 460,
                        ),
                      ),
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
          constraints: const BoxConstraints(minHeight: 44),
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

class _ProjectTechTags extends StatelessWidget {
  final List<String> techStack;
  final Color primaryColor;

  const _ProjectTechTags({
    required this.techStack,
    required this.primaryColor,
  });

  Color _getTagColor(String tech) {
    final lower = tech.toLowerCase();
    if (lower.contains('kotlin') || lower.contains('android') || lower.contains('compose')) {
      return AppColors.androidGreen;
    }
    if (lower.contains('flutter') || lower.contains('dart') || lower.contains('riverpod')) {
      return AppColors.flutterBlue;
    }
    if (lower.contains('retrofit') || lower.contains('rest') || lower.contains('dio')) {
      return AppColors.emerald;
    }
    if (lower.contains('room') || lower.contains('sqlite') || lower.contains('objectbox')) {
      return AppColors.amber;
    }
    if (lower.contains('rxjava') || lower.contains('coroutine') || lower.contains('flow')) {
      return AppColors.secondary;
    }
    if (lower.contains('clean') || lower.contains('mvvm') || lower.contains('architecture')) {
      return AppColors.accent;
    }
    return primaryColor;
  }

  IconData _getTagIcon(String tech) {
    final lower = tech.toLowerCase();
    if (lower.contains('compose')) return Icons.widgets_rounded;
    if (lower.contains('kotlin') || lower.contains('android')) return Icons.android_rounded;
    if (lower.contains('flutter') || lower.contains('dart') || lower.contains('riverpod')) return Icons.flutter_dash_rounded;
    if (lower.contains('retrofit') || lower.contains('rest') || lower.contains('dio')) return Icons.cloud_sync_rounded;
    if (lower.contains('room') || lower.contains('sqlite')) return Icons.storage_rounded;
    if (lower.contains('rxjava') || lower.contains('coroutine') || lower.contains('flow')) return Icons.stream_rounded;
    if (lower.contains('clean') || lower.contains('mvvm')) return Icons.layers_rounded;
    if (lower.contains('gps') || lower.contains('location')) return Icons.location_on_rounded;
    if (lower.contains('firebase')) return Icons.local_fire_department_rounded;
    return Icons.code_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tech in techStack)
          Builder(
            builder: (context) {
              final color = _getTagColor(tech);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.12 : 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: color.withValues(alpha: isDark ? 0.35 : 0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getTagIcon(tech), size: 12, color: color),
                    const SizedBox(width: 6),
                    Text(
                      tech,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark ? Colors.white.withValues(alpha: 0.9) : color,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
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
