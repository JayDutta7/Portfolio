import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../common/hover_card.dart';
import '../common/section_wrapper.dart';

class EngineeringPrinciples extends StatelessWidget {
  const EngineeringPrinciples({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktopOrWider(context);

    final principles = [
      const _Principle(
        title: 'Architecture',
        description: 'Maintainable and scalable application architecture using Clean Architecture and MVVM.',
        icon: Icons.architecture_rounded,
      ),
      const _Principle(
        title: 'Performance',
        description: 'Responsive UI and optimized application performance, ensuring smooth 60fps experiences.',
        icon: Icons.speed_rounded,
      ),
      const _Principle(
        title: 'Offline First',
        description: 'Reliable local persistence and synchronization strategies for field operations.',
        icon: Icons.cloud_off_rounded,
      ),
      const _Principle(
        title: 'Production',
        description: 'Release management, Play Store deployment and real-world product engineering.',
        icon: Icons.rocket_launch_rounded,
      ),
    ];

    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Engineering Philosophy',
            title: 'How I Build',
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 4 : 1,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: isDesktop ? 0.85 : 1.5,
            ),
            itemCount: principles.length,
            itemBuilder: (context, index) {
              return _PrincipleCard(principle: principles[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _PrincipleCard extends StatelessWidget {
  final _Principle principle;
  const _PrincipleCard({required this.principle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HoverCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              principle.icon,
              color: theme.colorScheme.primary,
              size: 28,
            ),
          ),
          const Spacer(),
          Text(
            principle.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            principle.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _Principle {
  final String title;
  final String description;
  final IconData icon;
  const _Principle({
    required this.title,
    required this.description,
    required this.icon,
  });
}
