import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/launch_helper.dart';
import '../../domain/models/profile_models.dart';
import '../widgets/common/device_mockup.dart';
import '../widgets/common/glass_container.dart';
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
        return Icons.language_rounded;
      case ProjectLinkType.github:
        return Icons.code_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isFlutter = project.stackSummary.contains('Flutter');
    final accentColor = isFlutter ? AppColors.flutterBlue : AppColors.androidGreen;

    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1024;
    final isMobile = width < 640;
    final isCompact = width < 380;

    final isShyamSteel = project.category == ProjectCategory.shyamSteel ||
        project.company.toLowerCase().contains('shyam steel');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: isMobile ? 260 : 360,
              pinned: true,
              backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Back to Case Studies',
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: const Icon(Icons.arrow_back_rounded, size: 18),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 48 : 32,
                  vertical: 16,
                ),
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isShyamSteel
                                  ? const Color(0xFFF59E0B).withValues(alpha: 0.25)
                                  : accentColor.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isShyamSteel
                                    ? const Color(0xFFF59E0B)
                                    : accentColor,
                              ),
                            ),
                            child: Text(
                              isShyamSteel ? 'SHYAM STEEL ENTERPRISE' : 'CLIENT SOLUTION',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: isShyamSteel ? const Color(0xFFF59E0B) : accentColor,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            project.company,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        project.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: isMobile ? (isCompact ? 16 : 18) : 24,
                        ),
                      ),
                    ],
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
                            accentColor.withValues(alpha: 0.85),
                            isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          ],
                        ),
                      ),
                    ),
                    if (project.screenshotUrl != null)
                      Positioned(
                        right: isMobile ? 12 : 36,
                        top: isMobile ? 36 : 24,
                        bottom: isMobile ? 24 : 16,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              project.screenshotUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      )
                    else
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: Opacity(
                          opacity: 0.12,
                          child: Icon(
                            isFlutter ? Icons.flutter_dash_rounded : Icons.android_rounded,
                            size: isMobile ? 140 : 220,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SectionWrapper(
                verticalPadding: isMobile ? 32 : 56,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top summary & device mockup showcase
                    GlassContainer(
                      padding: EdgeInsets.all(isMobile ? 18 : 28),
                      child: Flex(
                        direction: (isDesktop && project.screenshotUrl != null)
                            ? Axis.horizontal
                            : Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _maybeExpanded(
                            expand: isDesktop && project.screenshotUrl != null,
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: accentColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        isFlutter ? Icons.flutter_dash_rounded : Icons.android_rounded,
                                        color: accentColor,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            project.myRole,
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${project.company} • ${project.stackSummary}',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  project.overview,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    height: 1.6,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                                  ),
                                ),
                                if (project.links.isNotEmpty) ...[
                                  const SizedBox(height: 20),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      for (final link in project.links)
                                        OutlinedButton.icon(
                                          onPressed: () => LaunchHelper.openUrl(link.url),
                                          icon: Icon(_linkIcon(link.type), size: 14),
                                          label: Text(
                                            link.label,
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: accentColor,
                                            side: BorderSide(color: accentColor.withValues(alpha: 0.4)),
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (project.screenshotUrl != null) ...[
                            if (isDesktop) const SizedBox(width: 36),
                            if (!isDesktop) const SizedBox(height: 28),
                            Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: isMobile ? 200 : 240,
                                  maxHeight: isMobile ? 400 : 480,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: DeviceMockup(
                                    title: project.title,
                                    assetPath: project.screenshotUrl,
                                    fallbackIcon: isFlutter ? Icons.flutter_dash_rounded : Icons.android_rounded,
                                    glowColor: accentColor,
                                    width: 220,
                                    height: 460,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 01 Problem & Scope
                    _Section(
                      badge: '01',
                      title: 'PROBLEM & SCOPE',
                      accentColor: accentColor,
                      content: project.effectiveProblemScope,
                    ),

                    // 02 Technical Architecture
                    _Section(
                      badge: '02',
                      title: 'TECHNICAL ARCHITECTURE',
                      accentColor: accentColor,
                      content: project.effectiveTechnicalArchitecture,
                    ),

                    // 03 Hard Engineering Challenges & Solutions
                    _Section(
                      badge: '03',
                      title: 'HARD ENGINEERING CHALLENGES & SOLUTIONS',
                      accentColor: accentColor,
                      content: project.effectiveHardChallenges,
                    ),

                    // 04 Quantifiable Impact & Business Value
                    _Section(
                      badge: '04',
                      title: 'QUANTIFIABLE IMPACT & BUSINESS VALUE',
                      accentColor: const Color(0xFF10B981),
                      content: project.effectiveQuantifiableImpact,
                    ),

                    // 05 Technology Stack (JetBrains Mono Badges)
                    _Section(
                      badge: '05',
                      title: 'ENGINEERING STACK & ECOSYSTEM',
                      accentColor: accentColor,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final tech in project.techStack)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                tech,
                                style: GoogleFonts.jetBrainsMono(
                                  color: isDark ? Colors.white : AppColors.darkBackground,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // 06 Key Features & Architectural Capabilities
                    if (project.keyFeatures.isNotEmpty)
                      _Section(
                        badge: '06',
                        title: 'ARCHITECTURAL CAPABILITIES & HIGHLIGHTS',
                        accentColor: accentColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final feature in project.keyFeatures)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: AppColors.emerald.withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check_rounded, size: 12, color: AppColors.emerald),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        feature,
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          fontSize: 15,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                    // 07 Live Deployments & Internal Artifacts
                    _Section(
                      badge: '07',
                      title: 'PRODUCTION STATUS & VERIFICATION',
                      accentColor: accentColor,
                      child: project.links.isNotEmpty
                          ? Wrap(
                              spacing: 16,
                              runSpacing: 14,
                              children: [
                                for (final link in project.links)
                                  ElevatedButton.icon(
                                    onPressed: () => LaunchHelper.openUrl(link.url),
                                    icon: Icon(_linkIcon(link.type), size: 18, color: Colors.white),
                                    label: Text(
                                      link.label.toUpperCase(),
                                      style: GoogleFonts.jetBrainsMono(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 1.1,
                                        fontSize: 12,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      elevation: 0,
                                    ),
                                  ),
                              ],
                            )
                          : Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: theme.dividerColor),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified_user_rounded, color: AppColors.emerald, size: 22),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Enterprise Internal Production Application — Distributed securely to active enterprise field force, dealer network, and certified engineers via MDM and private internal releases.',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _maybeExpanded({required bool expand, required Widget child, int flex = 1}) {
    if (expand) {
      return Expanded(flex: flex, child: child);
    }
    return child;
  }
}

class _Section extends StatelessWidget {
  final String badge;
  final String title;
  final Color accentColor;
  final String? content;
  final Widget? child;

  const _Section({
    required this.badge,
    required this.title,
    required this.accentColor,
    this.content,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 640;

    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 24 : 36),
      child: GlassContainer(
        padding: EdgeInsets.all(isMobile ? 18 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.jetBrainsMono(
                      color: accentColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (content != null)
              Text(
                content!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: isMobile ? 14 : 16,
                  height: 1.7,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.88),
                ),
              ),
            if (child != null) ...[
              if (content != null) const SizedBox(height: 14),
              child!,
            ],
          ],
        ),
      ),
    );
  }
}
