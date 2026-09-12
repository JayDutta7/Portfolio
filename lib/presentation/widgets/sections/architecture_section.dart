import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/glass_container.dart';
import '../common/gradient_text.dart';
import '../common/section_wrapper.dart';

class ArchitectureSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ArchitectureSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);
    final isDark = theme.brightness == Brightness.dark;

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '03 / ENGINEERING ARCHITECTURE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GradientText(
            'Beautiful on the surface.\nThoughtful underneath.',
            colors: isDark
                ? [Colors.white, AppColors.secondary, AppColors.primary]
                : [AppColors.lightTextPrimary, AppColors.primary],
            style: theme.textTheme.displayMedium?.copyWith(
              height: 1.05,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 64),
          const _ArchitectureStackVisualizer(),
          const SizedBox(height: 100),
          _EcosystemBattle(isDesktop: isDesktop),
        ],
      ),
    );
  }
}

class _ArchitectureStackVisualizer extends StatelessWidget {
  const _ArchitectureStackVisualizer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _StackNode(
          title: '01. UI LAYER',
          sub: 'Jetpack Compose / Flutter UI',
          color: AppColors.primary,
        ),
        _StackArrow(),
        const _StackNode(
          title: '02. PRESENTATION / STATE LAYER',
          sub: 'ViewModel / StateFlow / Riverpod',
          color: AppColors.secondary,
        ),
        _StackArrow(),
        const _StackNode(
          title: '03. DOMAIN / BUSINESS LOGIC',
          sub: 'Clean Architecture UseCases & Entities',
          color: AppColors.accent,
        ),
        _StackArrow(),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _maybeExpanded(
                  expand: isWide,
                  flex: 1,
                  child: const _StackNode(
                    title: 'REMOTE API DATA SOURCE',
                    sub: 'Retrofit / Dio / REST APIs',
                    color: AppColors.emerald,
                  ),
                ),
                if (isWide) const SizedBox(width: 20) else const SizedBox(height: 16),
                _maybeExpanded(
                  expand: isWide,
                  flex: 1,
                  child: const _StackNode(
                    title: 'LOCAL CACHE DATA SOURCE',
                    sub: 'Room DB / SQLite / ObjectBox',
                    color: AppColors.amber,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _StackNode extends StatelessWidget {
  final String title;
  final String sub;
  final Color color;

  const _StackNode({
    required this.title,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 640;
    final isCompact = width < 380;

    return GlassContainer(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 16 : 24,
      ),
      glowColor: color,
      borderColor: color.withValues(alpha: 0.3),
      child: Center(
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: isCompact ? 1.0 : 2,
                  fontSize: isCompact ? 10 : 11,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: isMobile ? (isCompact ? 14 : 16) : 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StackArrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.secondary.withValues(alpha: 0.3),
          ],
        ),
      ),
    );
  }
}

class _EcosystemBattle extends StatelessWidget {
  final bool isDesktop;
  const _EcosystemBattle({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: isDesktop ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _maybeExpanded(
          expand: isDesktop,
          flex: 1,
          child: const _EcosystemCardRich(
            title: 'NATIVE ANDROID',
            subtitle: 'High-performance Kotlin & Jetpack Compose',
            items: ['Kotlin', 'Jetpack Compose', 'Coroutines & Flow', 'Clean Architecture', 'Hilt / Koin', 'Room DB', 'WorkManager', 'CameraX'],
            color: AppColors.androidGreen,
            icon: Icons.android_rounded,
          ),
        ),
        if (isDesktop) const SizedBox(width: 32) else const SizedBox(height: 32),
        _maybeExpanded(
          expand: isDesktop,
          flex: 1,
          child: const _EcosystemCardRich(
            title: 'FLUTTER MULTI-PLATFORM',
            subtitle: 'Cross-platform Android & iOS execution',
            items: ['Dart', 'Riverpod', 'Provider', 'MVVM', 'Dio / REST APIs', 'ObjectBox', 'sqflite', 'Firebase Push'],
            color: AppColors.flutterBlue,
            icon: Icons.flutter_dash_rounded,
          ),
        ),
      ],
    );
  }
}

class _EcosystemCardRich extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> items;
  final Color color;
  final IconData icon;

  const _EcosystemCardRich({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 640;
    final isCompact = width < 380;

    return GlassContainer(
      padding: EdgeInsets.all(isMobile ? (isCompact ? 18 : 24) : 36),
      glowColor: color,
      borderColor: color.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 10 : 14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Icon(icon, color: color, size: isMobile ? 24 : 36),
              ),
              SizedBox(width: isMobile ? 14 : 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: color,
                          fontSize: isMobile ? (isCompact ? 17 : 20) : 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: isMobile ? 12 : 13,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 24 : 36),
          Wrap(
            spacing: isMobile ? 8 : 10,
            runSpacing: isMobile ? 8 : 10,
            children: [
              for (final item in items)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10 : 14,
                    vertical: isMobile ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    item,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                      fontSize: isMobile ? 11 : 12,
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
