import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/section_wrapper.dart';

class AboutSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const AboutSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    final textBlock = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: Text(
        profile.aboutMe,
        style: theme.textTheme.bodyLarge?.copyWith(height: 1.75),
      ),
    );

    final quickFacts = _QuickFacts(profile: profile);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'About Me',
            title: 'Building reliable mobile products for 9+ years',
          ),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: textBlock),
                    const SizedBox(width: 48),
                    Expanded(flex: 2, child: quickFacts),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textBlock,
                    const SizedBox(height: 32),
                    quickFacts,
                  ],
                ),
        ],
      ),
    );
  }
}

class _QuickFacts extends StatelessWidget {
  final Profile profile;
  const _QuickFacts({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final facts = <_Fact>[
      const _Fact(Icons.badge_outlined, 'Role', 'Senior Mobile App Developer'),
      const _Fact(Icons.timeline_outlined, 'Experience', '9+ years'),
      const _Fact(Icons.architecture_outlined, 'Architecture', 'Clean Architecture · MVVM'),
      _Fact(Icons.location_on_outlined, 'Location', profile.location),
    ];

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < facts.length; i++) ...[
            _factRow(theme, facts[i]),
            if (i != facts.length - 1) ...[
              const SizedBox(height: 18),
              Divider(color: theme.dividerColor, height: 1),
              const SizedBox(height: 18),
            ],
          ],
        ],
      ),
    );
  }

  Widget _factRow(ThemeData theme, _Fact fact) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(fact.icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fact.label, style: theme.textTheme.labelLarge),
              const SizedBox(height: 3),
              Text(fact.value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _Fact {
  final IconData icon;
  final String label;
  final String value;
  const _Fact(this.icon, this.label, this.value);
}
