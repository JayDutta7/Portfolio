import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/hover_card.dart';
import '../common/section_wrapper.dart';

class EducationSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const EducationSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktopOrWider(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Background',
            title: 'Education & Certifications',
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : 1,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: isDesktop ? 1.6 : 2.0,
            ),
            itemCount: profile.education.length,
            itemBuilder: (context, index) {
              return _EducationCard(item: profile.education[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  final EducationItem item;
  const _EducationCard({required this.item});

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
              Icon(
                item.isCertification
                    ? Icons.workspace_premium_rounded
                    : Icons.school_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                item.period,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            item.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.institution,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          if (item.detail != null) ...[
            const SizedBox(height: 12),
            Text(
              item.detail!,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
