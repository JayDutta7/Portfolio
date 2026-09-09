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
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '03 / ENGINEERING',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Beautiful on the surface.\nThoughtful underneath.',
            style: theme.textTheme.displaySmall?.copyWith(
              height: 1.0,
            ),
          ),
          const SizedBox(height: 80),
          const _ArchitectureDiagram(),
          const SizedBox(height: 120),
          _EcosystemComparison(isDesktop: isDesktop),
        ],
      ),
    );
  }
}

class _ArchitectureDiagram extends StatelessWidget {
  const _ArchitectureDiagram();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _DiagramNode(title: 'FLUTTER / COMPOSE UI', color: Color(0xFF6366F1)),
        _ConnectingLine(),
        _DiagramNode(title: 'VIEWMODEL / RIVERPOD', color: Color(0xFF818CF8)),
        _ConnectingLine(),
        _DiagramNode(title: 'REPOSITORY LAYER', color: Color(0xFF14B8A6)),
        _ConnectingLine(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _DiagramNode(title: 'REMOTE API', width: 200, color: Color(0xFF2DD4BF)),
            SizedBox(width: 24),
            _DiagramNode(title: 'LOCAL DB', width: 200, color: Color(0xFF5EEAD4)),
          ],
        ),
      ],
    );
  }
}

class _DiagramNode extends StatelessWidget {
  final String title;
  final Color color;
  final double width;

  const _DiagramNode({
    required this.title,
    required this.color,
    this.width = 500,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor, width: 0.5),
      ),
      child: Center(
        child: Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _ConnectingLine extends StatelessWidget {
  const _ConnectingLine();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Theme.of(context).dividerColor,
    );
  }
}

class _EcosystemComparison extends StatelessWidget {
  final bool isDesktop;
  const _EcosystemComparison({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: isDesktop ? Axis.horizontal : Axis.vertical,
      children: [
        _maybeExpanded(
          expand: isDesktop,
          flex: 1,
          child: const _EcosystemBox(
            title: 'ANDROID',
            items: ['Kotlin', 'Jetpack Compose', 'Coroutines', 'Flow', 'WorkManager', 'CameraX', 'Hilt', 'ML Kit'],
            color: Color(0xFF3DDC84),
          ),
        ),
        if (isDesktop) ...[
          const SizedBox(width: 40),
          Text('VS', style: TextStyle(color: Colors.white.withValues(alpha: 0.1), fontWeight: FontWeight.w900, fontSize: 48)),
          const SizedBox(width: 40),
        ] else
          const SizedBox(height: 40),
        _maybeExpanded(
          expand: isDesktop,
          flex: 1,
          child: const _EcosystemBox(
            title: 'FLUTTER',
            items: ['Dart', 'Riverpod', 'Provider', 'MVVM', 'Dio', 'REST API', 'ObjectBox', 'Firebase'],
            color: Color(0xFF02569B),
          ),
        ),
      ],
    );
  }
}

class _EcosystemBox extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color color;

  const _EcosystemBox({
    required this.title,
    required this.items,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final item in items)
                Text(
                  item,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _maybeExpanded({
  required bool expand,
  required int flex,
  required Widget child,
}) {
  if (expand) {
    return Expanded(flex: flex, child: child);
  }
  return child;
}
