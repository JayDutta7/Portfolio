import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/profile_models.dart';
import '../common/glass_container.dart';
import '../common/gradient_text.dart';
import '../common/section_wrapper.dart';

class SkillsSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const SkillsSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '05 / TOOLKIT',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GradientText(
            'High-end engineering\ncapabilities.',
            colors: isDark
                ? [Colors.white, AppColors.accent, AppColors.secondary]
                : [AppColors.lightTextPrimary, AppColors.primary],
            style: theme.textTheme.displayMedium?.copyWith(
              height: 1.05,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 64),
          const _ModernToolkitPalette(),
        ],
      ),
    );
  }
}

class _ModernToolkitPalette extends StatelessWidget {
  const _ModernToolkitPalette();

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'title': 'MOBILE DEVELOPMENT',
        'items': ['Android SDK', 'Flutter', 'Jetpack Compose', 'Kotlin', 'Dart'],
        'color': AppColors.primary,
        'icon': Icons.smartphone_rounded,
      },
      {
        'title': 'ARCHITECTURE & DESIGN',
        'items': ['MVVM', 'Clean Architecture', 'Repository Pattern', 'Dependency Injection'],
        'color': AppColors.secondary,
        'icon': Icons.account_tree_rounded,
      },
      {
        'title': 'STATE MANAGEMENT',
        'items': ['Riverpod', 'Provider', 'StateFlow', 'SharedFlow'],
        'color': AppColors.accent,
        'icon': Icons.sync_rounded,
      },
      {
        'title': 'DATA & NETWORKING',
        'items': ['REST APIs', 'Dio', 'Retrofit', 'Room DB', 'SQLite', 'ObjectBox'],
        'color': AppColors.emerald,
        'icon': Icons.storage_rounded,
      },
      {
        'title': 'DEVICE & HARDWARE',
        'items': ['CameraX', 'OpenCV', 'ML Kit', 'ArUco', 'GPS & Location'],
        'color': AppColors.amber,
        'icon': Icons.sensors_rounded,
      },
      {
        'title': 'CLOUD & DEVOPS',
        'items': ['Firebase', 'CI/CD Pipelines', 'Git / GitHub', 'Postman'],
        'color': const Color(0xFFEC4899),
        'icon': Icons.cloud_done_rounded,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int columns;
        final double aspect;
        if (width >= 1150) {
          columns = 3;
          aspect = 1.35;
        } else if (width >= 640) {
          columns = 2;
          aspect = 1.45;
        } else {
          columns = 1;
          aspect = 1.6;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: aspect,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return _ToolkitCardRich(
              title: cat['title'] as String,
              items: cat['items'] as List<String>,
              color: cat['color'] as Color,
              icon: cat['icon'] as IconData,
            );
          },
        );
      },
    );
  }
}

class _ToolkitCardRich extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color color;
  final IconData icon;

  const _ToolkitCardRich({
    required this.title,
    required this.items,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 640;

    return GlassContainer(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      glowColor: color,
      borderColor: color.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: color,
                    letterSpacing: 1.1,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final item in items)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Text(
                        item,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: theme.colorScheme.onSurface,
                        ),
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
