import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/launch_helper.dart';
import '../../domain/models/profile_models.dart';
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
    final isMobile = width < 640;
    final isCompact = width < 380;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: isMobile ? 240 : 380,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
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
              titlePadding: EdgeInsets.symmetric(horizontal: isMobile ? 56 : 32, vertical: 16),
              title: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomLeft,
                child: Text(
                  project.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: isMobile ? (isCompact ? 16 : 18) : 24,
                  ),
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
                          accentColor.withValues(alpha: 0.8),
                          isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(
                        isFlutter ? Icons.flutter_dash_rounded : Icons.android_rounded,
                        size: 180,
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
              verticalPadding: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Section(title: '01 — OVERVIEW', content: project.overview),
                  _Section(
                    title: '02 — THE CHALLENGE',
                    content: project.technicalChallenge ??
                        'Architecting a robust, scalable mobile solution engineered for seamless offline operation, high data throughput, and low battery consumption.',
                  ),
                  _Section(title: '03 — MY ROLE & RESPONSIBILITIES', content: project.myRole),
                  if (project.architecture != null)
                    _Section(title: '04 — ARCHITECTURE & PATTERNS', content: project.architecture!),
                  _Section(
                    title: '05 — TECHNOLOGY STACK',
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final tech in project.techStack)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              tech,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (project.keyFeatures.isNotEmpty)
                    _Section(
                      title: '06 — KEY FEATURES',
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
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: AppColors.emerald.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check_rounded, size: 14, color: AppColors.emerald),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  _Section(
                    title: '07 — SOLUTION & RESULT',
                    content: project.solution ??
                        'Successfully deployed to production with high user retention, excellent stability metrics, and zero-downtime performance.',
                  ),
                  if (project.links.isNotEmpty)
                    _Section(
                      title: '08 — LIVE APPLICATIONS & LINKS',
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          for (final link in project.links)
                            ElevatedButton.icon(
                              onPressed: () => LaunchHelper.openUrl(link.url),
                              icon: Icon(_linkIcon(link.type), size: 18, color: Colors.white),
                              label: Text(
                                link.label.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontSize: 12,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
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
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 640;

    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 32 : 56),
      child: GlassContainer(
        padding: EdgeInsets.all(isMobile ? 20 : 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
                letterSpacing: 2,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            if (content != null)
              Text(
                content!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: isMobile ? 15 : 17,
                  height: 1.7,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                ),
              ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
