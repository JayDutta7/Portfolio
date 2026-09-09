import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/section_wrapper.dart';

class StatsSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const StatsSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      verticalPadding: 80,
      background: theme.colorScheme.surface,
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final stat in profile.stats)
                  _StatItem(stat: stat),
              ],
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.5,
              ),
              itemCount: profile.stats.length,
              itemBuilder: (context, index) {
                return _StatItem(stat: profile.stats[index]);
              },
            ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final StatItem stat;
  const _StatItem({required this.stat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          stat.value,
          style: theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.primary,
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
