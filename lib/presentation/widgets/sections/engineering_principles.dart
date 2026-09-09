import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../common/section_wrapper.dart';

class EngineeringPrinciples extends StatelessWidget {
  const EngineeringPrinciples({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    final stages = [
      {
        'id': '01',
        'title': 'UNDERSTAND',
        'items': ['Product requirements', 'User flows', 'Business rules'],
      },
      {
        'id': '02',
        'title': 'ARCHITECT',
        'items': ['Scalable architecture', 'State management', 'Data synchronization'],
      },
      {
        'id': '03',
        'title': 'BUILD',
        'items': ['Pixel-perfect UI', 'Feature integration', 'Rigorous testing'],
      },
      {
        'id': '04',
        'title': 'SHIP',
        'items': ['Optimization', 'Release management', 'Play Store deployment'],
      },
    ];

    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROCESS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'From idea to production.',
            style: theme.textTheme.displaySmall?.copyWith(
              height: 1.0,
            ),
          ),
          const SizedBox(height: 80),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 4 : 1,
              crossAxisSpacing: 40,
              mainAxisSpacing: 40,
              childAspectRatio: isDesktop ? 0.8 : 2.0,
            ),
            itemCount: stages.length,
            itemBuilder: (context, index) {
              final stage = stages[index];
              return _BuildStageCard(
                id: stage['id'] as String,
                title: stage['title'] as String,
                items: stage['items'] as List<String>,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BuildStageCard extends StatelessWidget {
  final String id;
  final String title;
  final List<String> items;

  const _BuildStageCard({
    required this.id,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          id,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 24),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              item,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
      ],
    );
  }
}
