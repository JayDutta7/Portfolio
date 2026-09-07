import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
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
    final columns = Responsive.gridColumns(context, max: 4);

    return SectionWrapper(
      sectionKey: sectionKey,
      background: theme.brightness == Brightness.dark
          ? theme.colorScheme.surface.withValues(alpha: 0.4)
          : theme.colorScheme.primary.withValues(alpha: 0.04),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 20.0;
          final cardWidth =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final stat in profile.stats)
                SizedBox(
                  width: cardWidth,
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (rect) => const LinearGradient(
                          colors: AppColors.accentGradient,
                        ).createShader(rect),
                        child: Text(
                          stat.value,
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stat.label,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
