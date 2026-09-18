import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/device_mockup.dart';
import '../common/glass_container.dart';
import '../common/gradient_text.dart';
import '../common/section_wrapper.dart';
import '../../pages/project_details_page.dart';

enum ProjectFilterType { all, shyamSteel, clientSolutions }

class ProjectsSection extends StatefulWidget {
  final Profile profile;
  final GlobalKey? sectionKey;

  const ProjectsSection({required this.profile, this.sectionKey, super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  ProjectFilterType _activeFilter = ProjectFilterType.all;

  List<Project> get _filteredProjects {
    switch (_activeFilter) {
      case ProjectFilterType.all:
        return widget.profile.projects;
      case ProjectFilterType.shyamSteel:
        return widget.profile.projects
            .where((p) => p.category == ProjectCategory.shyamSteel)
            .toList();
      case ProjectFilterType.clientSolutions:
        return widget.profile.projects
            .where((p) => p.category == ProjectCategory.clientSolutions)
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shyamCount = widget.profile.projects
        .where((p) => p.category == ProjectCategory.shyamSteel)
        .length;
    final clientCount = widget.profile.projects
        .where((p) => p.category == ProjectCategory.clientSolutions)
        .length;
    final totalCount = widget.profile.projects.length;

    return SelectionArea(
      child: SectionWrapper(
        sectionKey: widget.sectionKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _RichSectionHeader(
              title: 'VERIFIED ENTERPRISE & CLIENT CASE STUDIES',
              index: '01',
            ),
            const SizedBox(height: 28),

            // Interactive Filter Bar
            _FilterTabsBar(
              activeFilter: _activeFilter,
              totalCount: totalCount,
              shyamCount: shyamCount,
              clientCount: clientCount,
              onFilterChanged: (filter) {
                setState(() => _activeFilter = filter);
              },
            ),

            const SizedBox(height: 48),

            // Filtered Projects List
            for (final project in _filteredProjects)
              _ProductShowcaseCard(
                key: ValueKey(project.title),
                project: project,
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterTabsBar extends StatelessWidget {
  final ProjectFilterType activeFilter;
  final int totalCount;
  final int shyamCount;
  final int clientCount;
  final ValueChanged<ProjectFilterType> onFilterChanged;

  const _FilterTabsBar({
    required this.activeFilter,
    required this.totalCount,
    required this.shyamCount,
    required this.clientCount,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _FilterTabButton(
            label: 'ALL CASE STUDIES ($totalCount)',
            isSelected: activeFilter == ProjectFilterType.all,
            accentColor: AppColors.primary,
            onTap: () => onFilterChanged(ProjectFilterType.all),
          ),
          _FilterTabButton(
            label: 'SHYAM STEEL PRODUCTS ($shyamCount)',
            isSelected: activeFilter == ProjectFilterType.shyamSteel,
            accentColor: AppColors.androidGreen,
            onTap: () => onFilterChanged(ProjectFilterType.shyamSteel),
          ),
          _FilterTabButton(
            label: 'CLIENT SOLUTIONS ($clientCount)',
            isSelected: activeFilter == ProjectFilterType.clientSolutions,
            accentColor: AppColors.flutterBlue,
            onTap: () => onFilterChanged(ProjectFilterType.clientSolutions),
          ),
        ],
      ),
    );
  }
}

class _FilterTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _FilterTabButton({
    required this.label,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? accentColor.withValues(alpha: 0.6)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? accentColor : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            letterSpacing: 0.5,
          ),
        ),
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
              letterSpacing: isDesktop ? 2.5 : 1.2,
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
  const _ProductShowcaseCard({required this.project, super.key});

  @override
  State<_ProductShowcaseCard> createState() => _ProductShowcaseCardState();
}

class _ProductShowcaseCardState extends State<_ProductShowcaseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    final isFlutter = widget.project.stackSummary.contains('Flutter');
    final accentColor = isFlutter ? AppColors.flutterBlue : AppColors.androidGreen;

    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 640;

    final hasMockup = widget.project.screenshotUrl != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 56),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GlassContainer(
          padding: EdgeInsets.all(isDesktop ? 40 : (isMobile ? 18 : 26)),
          borderColor: _isHovered ? accentColor.withValues(alpha: 0.55) : null,
          glowColor: accentColor,
          child: Flex(
            direction: (isDesktop && hasMockup) ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _maybeExpanded(
                expand: isDesktop && hasMockup,
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Metadata Badges Row
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _TechTagRich(
                          label: widget.project.company.toUpperCase(),
                          color: AppColors.primary,
                        ),
                        _TechTagRich(
                          label: widget.project.platforms.join(' • '),
                          color: accentColor,
                        ),
                        Text(
                          widget.project.period,
                          style: GoogleFonts.jetBrainsMono(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Title
                    GradientText(
                      widget.project.title,
                      colors: isFlutter
                          ? [Colors.white, AppColors.flutterBlue]
                          : [Colors.white, AppColors.androidGreen],
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: isDesktop ? 34 : 26,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // High-level Overview
                    Text(
                      widget.project.overview,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        height: 1.6,
                        fontSize: 15,
                      ),
                    ),

                    // Prominent Mobile & Tablet Device Showcase
                    if (!isDesktop && hasMockup) ...[
                      const SizedBox(height: 24),
                      _buildDeviceMockup(
                        accentColor: accentColor,
                        isFlutter: isFlutter,
                        width: width,
                        isMobile: isMobile,
                        isDesktop: false,
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Structured Case Study Breakdown
                    _CaseStudySectionBox(
                      number: '01',
                      title: 'PROBLEM & SCOPE',
                      content: widget.project.effectiveProblemScope,
                      accentColor: accentColor,
                    ),

                    const SizedBox(height: 14),

                    _CaseStudySectionBox(
                      number: '02',
                      title: 'TECHNICAL ARCHITECTURE',
                      content: widget.project.effectiveTechnicalArchitecture,
                      accentColor: accentColor,
                    ),

                    if (widget.project.effectiveHardChallenges.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      _CaseStudySectionBox(
                        number: '03',
                        title: 'HARD ENGINEERING CHALLENGES',
                        content: widget.project.effectiveHardChallenges,
                        accentColor: AppColors.amber,
                      ),
                    ],

                    if (widget.project.effectiveQuantifiableImpact.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      _CaseStudySectionBox(
                        number: '04',
                        title: 'QUANTIFIABLE IMPACT & RESULTS',
                        content: widget.project.effectiveQuantifiableImpact,
                        accentColor: AppColors.emerald,
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Stack Badges rendered in JetBrains Mono
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ENGINEERING STACK BADGES',
                          style: GoogleFonts.jetBrainsMono(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                            fontSize: 10.5,
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

                    const SizedBox(height: 18),
                    _InfoItemRich(label: 'MY ARCHITECTURAL ROLE', content: widget.project.myRole),

                    const SizedBox(height: 32),

                    // Actions Row
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _PrimaryAction(
                          label: 'VIEW FULL CASE STUDY',
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

              // Desktop Side Showcase
              if (isDesktop && hasMockup) ...[
                const SizedBox(width: 50),
                Expanded(
                  flex: 4,
                  child: _buildDeviceMockup(
                    accentColor: accentColor,
                    isFlutter: isFlutter,
                    width: width,
                    isMobile: false,
                    isDesktop: true,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceMockup({
    required Color accentColor,
    required bool isFlutter,
    required double width,
    required bool isMobile,
    required bool isDesktop,
  }) {
    final mockupWidth = isDesktop
        ? 230.0
        : (width - (isMobile ? 64 : 140)).clamp(220.0, 260.0);
    final mockupHeight = isDesktop ? 470.0 : (mockupWidth * 2.05);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isDesktop ? 260 : 280),
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
              width: mockupWidth,
              height: mockupHeight,
            ),
          ),
        ),
      ),
    );
  }
}

class _CaseStudySectionBox extends StatelessWidget {
  final String number;
  final String title;
  final String content;
  final Color accentColor;

  const _CaseStudySectionBox({
    required this.number,
    required this.title,
    required this.content,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: isDark ? 0.06 : 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.2 : 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                number,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              height: 1.55,
              fontSize: 13.5,
            ),
          ),
        ],
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
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_linkIcon(link.type), size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  link.label,
                  style: GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _linkIcon(ProjectLinkType type) {
    switch (type) {
      case ProjectLinkType.playStore:
        return Icons.shop_outlined;
      case ProjectLinkType.appStore:
        return Icons.apple;
      case ProjectLinkType.web:
        return Icons.language_rounded;
      case ProjectLinkType.github:
        return Icons.code_rounded;
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
    if (lower.contains('flutter') || lower.contains('dart') || lower.contains('riverpod') || lower.contains('bloc')) {
      return AppColors.flutterBlue;
    }
    if (lower.contains('retrofit') || lower.contains('rest') || lower.contains('dio') || lower.contains('webrtc')) {
      return AppColors.emerald;
    }
    if (lower.contains('room') || lower.contains('sqlite') || lower.contains('sqlcipher')) {
      return AppColors.amber;
    }
    if (lower.contains('clean') || lower.contains('mvvm') || lower.contains('architecture') || lower.contains('livedata')) {
      return AppColors.accent;
    }
    return primaryColor;
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
                child: Text(
                  tech,
                  style: GoogleFonts.jetBrainsMono(
                    color: isDark ? Colors.white.withValues(alpha: 0.9) : color,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 0.2,
                  ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.8,
          fontSize: 10.5,
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
          style: GoogleFonts.jetBrainsMono(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _PrimaryAction extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PrimaryAction({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_PrimaryAction> createState() => _PrimaryActionState();
}

class _PrimaryActionState extends State<_PrimaryAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 360;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 44),
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16 : 22,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color,
                widget.color.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _hovered ? 0.45 : 0.25),
                blurRadius: _hovered ? 16 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w900,
                    letterSpacing: isCompact ? 0.8 : 1.2,
                    fontSize: isCompact ? 11 : 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _maybeExpanded({
  required bool expand,
  required Widget child,
  int flex = 1,
}) {
  if (expand) {
    return Expanded(flex: flex, child: child);
  }
  return child;
}
