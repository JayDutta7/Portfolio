import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/section_wrapper.dart';

class ArchitectureSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ArchitectureSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Architecture & Technical Expertise',
            title: 'How I structure production applications',
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PipelineCard(
                  title: 'Flutter Stack',
                  steps: profile.flutterArchitecturePipeline,
                  isMobile: isMobile,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PipelineCard(
                  title: 'Android Stack',
                  steps: profile.androidArchitecturePipeline,
                  isMobile: isMobile,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PipelineCard extends StatelessWidget {
  final String title;
  final List<String> steps;
  final bool isMobile;

  const _PipelineCard({
    required this.title,
    required this.steps,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 22),
          isMobile
              ? Column(
                  children: [
                    for (int i = 0; i < steps.length; i++)
                      _PipelineStep(
                        label: steps[i],
                        isLast: i == steps.length - 1,
                        vertical: true,
                      ),
                  ],
                )
              : Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (int i = 0; i < steps.length; i++)
                      _PipelineStep(
                        label: steps[i],
                        isLast: i == steps.length - 1,
                        vertical: false,
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _PipelineStep extends StatelessWidget {
  final String label;
  final bool isLast;
  final bool vertical;

  const _PipelineStep({
    required this.label,
    required this.isLast,
    required this.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    final arrow = Icon(
      vertical ? Icons.arrow_downward_rounded : Icons.arrow_forward_rounded,
      size: 18,
      color: theme.dividerColor,
    );

    if (vertical) {
      return Column(
        children: [
          chip,
          if (!isLast) Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: arrow),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          chip,
          if (!isLast) Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: arrow),
        ],
      ),
    );
  }
}
