import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/glass_container.dart';
import '../common/gradient_text.dart';
import '../common/section_wrapper.dart';

class StatsSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const StatsSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktopOrWider(context);

    // High impact metrics mapped from localized profile data
    final statsData = [
      {
        'value': profile.stats.isNotEmpty ? profile.stats[0].value : '9+',
        'label': profile.stats.isNotEmpty ? profile.stats[0].label.toUpperCase() : 'YEARS EXPERIENCE',
        'sub': 'Android & Flutter Development',
        'colors': [AppColors.primary, AppColors.secondary],
        'icon': Icons.workspace_premium_rounded,
      },
      {
        'value': profile.stats.length > 1 ? profile.stats[1].value : '2',
        'label': profile.stats.length > 1 ? profile.stats[1].label.toUpperCase() : 'PLATFORMS — ANDROID + FLUTTER',
        'sub': 'Deployed to Play & App Store',
        'colors': [AppColors.secondary, AppColors.flutterBlue],
        'icon': Icons.rocket_launch_rounded,
      },
      {
        'value': profile.stats.length > 2 ? profile.stats[2].value : '10',
        'label': profile.stats.length > 2 ? profile.stats[2].label.toUpperCase() : 'ENTERPRISE APPLICATIONS',
        'sub': 'Optimized Mobile Apps Runtime',
        'colors': [AppColors.androidGreen, AppColors.emerald],
        'icon': Icons.speed_rounded,
      },
      {
        'value': profile.stats.length > 3 ? profile.stats[3].value : '4',
        'label': profile.stats.length > 3 ? profile.stats[3].label.toUpperCase() : 'COMPANIES',
        'sub': 'Clean Architecture & Kotlin',
        'colors': [AppColors.accent, const Color(0xFFEC4899)],
        'icon': Icons.bug_report_rounded,
      },
    ];

    return SectionWrapper(
      sectionKey: sectionKey,
      verticalPadding: 40,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = isDesktop ? 4 : (constraints.maxWidth > 600 ? 2 : 1);

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isDesktop ? 1.15 : (constraints.maxWidth > 600 ? 1.25 : 1.45),
            ),
            itemCount: statsData.length,
            itemBuilder: (context, index) {
              final item = statsData[index];
              return _StatBentoCard(
                value: item['value'] as String,
                label: item['label'] as String,
                sub: item['sub'] as String,
                colors: item['colors'] as List<Color>,
                icon: item['icon'] as IconData,
              );
            },
          );
        },
      ),
    );
  }
}

class _StatBentoCard extends StatelessWidget {
  final String value;
  final String label;
  final String sub;
  final List<Color> colors;
  final IconData icon;

  const _StatBentoCard({
    required this.value,
    required this.label,
    required this.sub,
    required this.colors,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GlassContainer(
      padding: const EdgeInsets.all(18),
      glowColor: colors.first,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.first.withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colors.first.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: colors.first, size: 18),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.first,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GradientText(
                  value,
                  colors: colors,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 38,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
