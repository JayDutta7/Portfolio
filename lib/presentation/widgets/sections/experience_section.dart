import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/hover_card.dart';
import '../common/section_wrapper.dart';

class ExperienceSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ExperienceSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Experience',
            title: '9+ years across four engineering teams',
          ),
          for (int i = 0; i < profile.experience.length; i++)
            _TimelineTile(
              item: profile.experience[i],
              isLast: i == profile.experience.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final ExperienceItem item;
  final bool isLast;

  const _TimelineTile({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);
    const double dotSize = 16.0;
    const double linePadding = 4.0;
    final double bottomSpace = isLast ? 0 : 28;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpace),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (!isLast)
            Positioned(
              left: (dotSize / 2) - 1, // Center the 2px line under the 16px dot
              top: dotSize + linePadding,
              bottom: -bottomSpace,
              child: Container(
                width: 2,
                color: theme.dividerColor,
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dot
              Container(
                width: dotSize,
                height: dotSize,
                margin: const EdgeInsets.only(top: 6), // Align with first line of text
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.isCurrent ? AppColors.primary : Colors.transparent,
                  border: Border.all(color: AppColors.primary, width: 2.5),
                ),
              ),
              // Card
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: isMobile ? 16 : 24),
                  child: HoverCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            Text(item.role, style: theme.textTheme.titleLarge),
                            if (item.isCurrent)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'Current',
                                  style: theme.textTheme.labelLarge
                                      ?.copyWith(color: AppColors.success),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.company} · ${item.period}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        for (final h in item.highlights)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 7),
                                  child: Icon(Icons.circle, size: 5),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(h, style: theme.textTheme.bodyMedium),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
