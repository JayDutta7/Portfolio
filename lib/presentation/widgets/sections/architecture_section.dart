import 'package:flutter/material.dart';
import '../../../domain/models/profile_models.dart';
import '../common/section_wrapper.dart';

class ArchitectureSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ArchitectureSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SectionHeading(
            eyebrow: 'System Design',
            title: 'Clean Architecture Layering',
            alignment: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 48),
          _ArchitectureLayer(
            title: 'UI Layer',
            subtitle: 'Jetpack Compose / Flutter UI',
            description: 'Stateless components reacting to ViewState.',
            color: const Color(0xFF6366F1),
          ),
          const _Arrow(),
          _ArchitectureLayer(
            title: 'ViewModel / State Management',
            subtitle: 'ViewModel + StateFlow / Riverpod',
            description: 'Managing UI state and processing user intents.',
            color: const Color(0xFF818CF8),
          ),
          const _Arrow(),
          _ArchitectureLayer(
            title: 'Domain Layer (Use Cases)',
            subtitle: 'Pure Business Logic',
            description: 'Reusable business rules and domain entities.',
            color: const Color(0xFF94A3B8),
          ),
          const _Arrow(),
          _ArchitectureLayer(
            title: 'Data Layer (Repository)',
            subtitle: 'Repository Pattern',
            description: 'Single source of truth for data operations.',
            color: const Color(0xFF14B8A6),
          ),
          const _Arrow(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ArchitectureLayer(
                title: 'Remote Source',
                subtitle: 'Retrofit / Dio',
                width: 200,
                color: Color(0xFF2DD4BF),
              ),
              SizedBox(width: 24),
              _ArchitectureLayer(
                title: 'Local Source',
                subtitle: 'Room / SQLite',
                width: 200,
                color: Color(0xFF5EEAD4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArchitectureLayer extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? description;
  final Color color;
  final double? width;

  const _ArchitectureLayer({
    required this.title,
    required this.subtitle,
    this.description,
    required this.color,
    this.width,
    super.key,
  });

  @override
  State<_ArchitectureLayer> createState() => _ArchitectureLayerState();
}

class _ArchitectureLayerState extends State<_ArchitectureLayer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width ?? 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? widget.color : theme.dividerColor,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(
              widget.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: _isHovered ? widget.color : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w700,
              ),
            ),
            if (widget.description != null && _isHovered) ...[
              const SizedBox(height: 12),
              Text(
                widget.description!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).dividerColor,
    );
  }
}
