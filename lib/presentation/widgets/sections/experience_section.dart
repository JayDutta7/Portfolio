import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/glass_container.dart';
import '../common/gradient_text.dart';
import '../common/pulse_badge.dart';
import '../common/section_wrapper.dart';

class ExperienceSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ExperienceSection({required this.profile, this.sectionKey, super.key});

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
                  '04 / CAREER',
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
            '9 years of evolution.',
            colors: isDark
                ? [Colors.white, AppColors.primary, AppColors.secondary]
                : [AppColors.lightTextPrimary, AppColors.primary],
            style: theme.textTheme.displayMedium?.copyWith(
              height: 1.05,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 64),
          for (int i = 0; i < profile.experience.length; i++)
            _TimelineExperienceCard(
              item: profile.experience[i],
              isLast: i == profile.experience.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineExperienceCard extends StatelessWidget {
  final ExperienceItem item;
  final bool isLast;

  const _TimelineExperienceCard({
    required this.item,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical Timeline Line & Dot
          if (isDesktop) ...[
            SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.period.split(' – ').first.toUpperCase(),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.period,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
          ],
          // Card Content
          Expanded(
            child: GlassContainer(
              padding: const EdgeInsets.all(32),
              glowColor: item.isCurrent ? AppColors.primary : AppColors.secondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.role.toUpperCase(),
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                letterSpacing: 1.5,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.company,
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item.isCurrent) ...[
                        const PulseBadge(
                          label: 'ACTIVE ROLE',
                          dotColor: AppColors.emerald,
                        ),
                      ],
                    ],
                  ),
                  if (!isDesktop) ...[
                    const SizedBox(height: 12),
                    Text(
                      item.period,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  for (final highlight in item.highlights)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.emerald.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: AppColors.emerald,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              highlight,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                                fontSize: 15,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                              ),
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
