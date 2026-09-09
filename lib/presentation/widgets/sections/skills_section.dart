import 'package:flutter/material.dart';
import '../../../domain/models/profile_models.dart';
import '../common/section_wrapper.dart';

class SkillsSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const SkillsSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '04 / TOOLKIT',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'My engineering\ntoolkit.',
            style: theme.textTheme.displayMedium?.copyWith(
              height: 1.0,
            ),
          ),
          const SizedBox(height: 80),
          const _CommandPaletteToolkit(),
        ],
      ),
    );
  }
}

class _CommandPaletteToolkit extends StatelessWidget {
  const _CommandPaletteToolkit();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = [
      {
        'title': 'MOBILE',
        'items': ['Android', 'Flutter', 'Jetpack Compose', 'Kotlin', 'Dart'],
      },
      {
        'title': 'ARCHITECTURE',
        'items': ['MVVM', 'Clean Architecture', 'Repository Pattern', 'Dependency Injection'],
      },
      {
        'title': 'STATE',
        'items': ['Riverpod', 'Provider', 'StateFlow', 'SharedFlow'],
      },
      {
        'title': 'DATA',
        'items': ['REST API', 'Dio', 'Retrofit', 'ObjectBox', 'SQLite'],
      },
      {
        'title': 'DEVICE',
        'items': ['CameraX', 'OpenCV', 'ML Kit', 'ArUco'],
      },
      {
        'title': 'CLOUD',
        'items': ['Firebase', 'CI/CD', 'Git', 'Postman'],
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                const SizedBox(width: 16),
                Text(
                  'Search engineering capabilities...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 600;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 2 : 1,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 40,
                    childAspectRatio: isDesktop ? 2.5 : 3.0,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (cat['title'] as String),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.primary,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final item in (cat['items'] as List<String>))
                              _ToolkitChip(label: item),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolkitChip extends StatelessWidget {
  final String label;
  const _ToolkitChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
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
