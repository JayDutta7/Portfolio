import 'package:flutter/material.dart';
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
            eyebrow: 'Career Timeline',
            title: '9+ Years of Professional Engineering',
          ),
          const SizedBox(height: 24),
          for (int i = 0; i < profile.experience.length; i++)
            _ExperienceCard(
              item: profile.experience[i],
              isFirst: i == 0,
              isLast: i == profile.experience.length - 1,
            ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final ExperienceItem item;
  final bool isFirst;
  final bool isLast;

  const _ExperienceCard({
    required this.item,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isDesktop) ...[
            SizedBox(
              width: 140,
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  item.period,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
          ],
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 28),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.isCurrent ? theme.colorScheme.primary : Colors.transparent,
                  border: Border.all(
                    color: item.isCurrent
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                    width: 2,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: theme.dividerColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: HoverCard(
                borderRadius: 16,
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isDesktop) ...[
                      Text(
                        item.period,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.role,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        if (item.isCurrent)
                          const _StatusBadge(label: 'Present'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.company,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (final highlight in item.highlights)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: theme.colorScheme.primary.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                highlight,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.6,
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
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  const _StatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
