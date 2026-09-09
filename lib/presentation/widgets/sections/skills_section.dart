import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/hover_card.dart';
import '../common/section_wrapper.dart';

class SkillsSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const SkillsSection({required this.profile, this.sectionKey, super.key});

  IconData _iconFor(String key) {
    switch (key) {
      case 'mobile':
        return Icons.smartphone_rounded;
      case 'architecture':
        return Icons.account_tree_rounded;
      case 'state':
        return Icons.dynamic_feed_rounded;
      case 'networking':
        return Icons.wifi_tethering_rounded;
      case 'storage':
        return Icons.storage_rounded;
      default:
        return Icons.bolt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktopOrWider(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Ecosystem',
            title: 'Engineering Stack',
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : 1,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: isDesktop ? 1.2 : 1.4,
            ),
            itemCount: profile.skillCategories.length,
            itemBuilder: (context, index) {
              final category = profile.skillCategories[index];
              return _SkillCard(
                category: category,
                icon: _iconFor(category.iconAsset),
              );
            },
          ),
          const SizedBox(height: 100),
          const _TechnologyWall(),
        ],
      ),
    );
  }
}

class _TechnologyWall extends StatelessWidget {
  const _TechnologyWall();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tech = [
      'Kotlin', 'Flutter', 'Android', 'Dart', 'Jetpack Compose',
      'Coroutines', 'Flow', 'Riverpod', 'Hilt', 'Koin', 'Room',
      'Retrofit', 'Dio', 'Firebase', 'Clean Architecture', 'MVVM'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'PRODUCTION TESTED',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 4,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 48),
        Wrap(
          spacing: 48,
          runSpacing: 32,
          alignment: WrapAlignment.center,
          children: [
            for (final item in tech)
              Opacity(
                opacity: 0.4,
                child: Text(
                  item,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SkillCard extends StatelessWidget {
  final SkillCategory category;
  final IconData icon;

  const _SkillCard({required this.category, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HoverCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                category.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final skill in category.skills)
                Text(
                  skill,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
