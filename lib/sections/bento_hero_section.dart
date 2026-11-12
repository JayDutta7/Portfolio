import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/utils/launch_helper.dart';
import '../domain/models/profile_models.dart';
import '../theme/app_theme.dart';
import '../widgets/hover_bento_card.dart';

/// Above-the-Fold Asymmetric Bento Grid
///
/// Responsive 12-column equivalent layout:
/// - Desktop (>1024px): 3 columns (Tile A 2 cols + Tile B 1 col; Tile C 1 col + Tile D 2 cols)
/// - Tablet (600-1024px): 2 columns (Tile A 2 cols; Tile B 1 col + Tile C 1 col; Tile D 2 cols)
/// - Mobile (<600px): 1 stacked column
class BentoHeroSection extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onExploreProjects;
  final VoidCallback? onDownloadResume;

  const BentoHeroSection({
    required this.profile,
    this.onExploreProjects,
    this.onDownloadResume,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = width > 1024;
        final isTablet = width >= 600 && width <= 1024;
        const gap = 20.0;

        if (isDesktop) {
          final colWidth = (width - (gap * 2)) / 3;
          final twoColWidth = (colWidth * 2) + gap;

          return Column(
            children: [
              // Row 1: Tile A (2 cols) + Tile B (1 col)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: twoColWidth,
                      child: _HeroTileA(
                        profile: profile,
                        onExploreProjects: onExploreProjects,
                        onDownloadResume: onDownloadResume,
                      ),
                    ),
                    const SizedBox(width: gap),
                    SizedBox(
                      width: colWidth,
                      child: _ProfileTileB(profile: profile),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: gap),

              // Row 2: Tile C (1 col) + Tile D (2 cols)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: colWidth,
                      child: const _MetricsTileC(),
                    ),
                    const SizedBox(width: gap),
                    SizedBox(
                      width: twoColWidth,
                      child: const _TechRadarTileD(),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (isTablet) {
          final halfWidth = (width - gap) / 2;

          return Column(
            children: [
              // Row 1: Tile A (full width)
              _HeroTileA(
                profile: profile,
                onExploreProjects: onExploreProjects,
                onDownloadResume: onDownloadResume,
              ),
              const SizedBox(height: gap),

              // Row 2: Tile B + Tile C
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: halfWidth,
                      child: _ProfileTileB(profile: profile),
                    ),
                    const SizedBox(width: gap),
                    SizedBox(
                      width: halfWidth,
                      child: const _MetricsTileC(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: gap),

              // Row 3: Tile D (full width)
              const _TechRadarTileD(),
            ],
          );
        } else {
          // Mobile Stacked (<600px)
          return Column(
            children: [
              _HeroTileA(
                profile: profile,
                onExploreProjects: onExploreProjects,
                onDownloadResume: onDownloadResume,
              ),
              const SizedBox(height: gap),
              _ProfileTileB(profile: profile),
              const SizedBox(height: gap),
              const _MetricsTileC(),
              const SizedBox(height: gap),
              const _TechRadarTileD(),
            ],
          );
        }
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Bento Tile A: Main Hero (Span 2 cols)
// ---------------------------------------------------------------------------
class _HeroTileA extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onExploreProjects;
  final VoidCallback? onDownloadResume;

  const _HeroTileA({
    required this.profile,
    this.onExploreProjects,
    this.onDownloadResume,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return HoverBentoCard(
      accentGlowColor: AppColors.electricCyan,
      padding: EdgeInsets.all(isMobile ? 22 : 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pulsing Emerald Status Pill
              const _PulsingStatusPill(
                label: 'Available for Mobile Architect & Lead Roles',
              ),
              const SizedBox(height: 24),

              // Headline in Plus Jakarta Sans (ExtraBold, tight letter-spacing)
              Text(
                'Architecting Offline-First, Native & Cross-Platform Mobile Systems.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 28 : 42,
                  fontWeight: FontWeight.w800,
                  height: 1.08,
                  letterSpacing: isMobile ? -1.0 : -1.8,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 18),

              // Concise Executive Summary
              Text(
                '9+ years of engineering enterprise production systems across Android SDK, '
                'Kotlin, Jetpack Compose, Flutter, Clean Architecture, and BLE/NDK hardware integration. '
                'Specialized in resilient offline database synchronization, background telemetry, '
                'and zero-drift cross-platform architectures.',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 14 : 15.5,
                  height: 1.65,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Action Row: Primary Gradient CTA + Secondary Glass Button + Socials
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Primary Gradient CTA
              _PrimaryActionGradientButton(
                label: 'Explore Case Studies',
                icon: Icons.layers_outlined,
                onTap: onExploreProjects,
              ),

              // Secondary Glass Button
              _SecondaryGlassButton(
                label: 'Download CV',
                icon: Icons.download_rounded,
                onTap: onDownloadResume,
              ),

              // Social Links
              _SocialIconButton(
                tooltip: 'GitHub Profile',
                icon: Icons.code_rounded,
                onTap: () => LaunchHelper.openUrl(profile.githubUrl),
              ),
              _SocialIconButton(
                tooltip: 'LinkedIn Profile',
                icon: Icons.business_center_outlined,
                onTap: () => LaunchHelper.openUrl(profile.linkedInUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bento Tile B: Developer Profile & Identity (Span 1 col)
// ---------------------------------------------------------------------------
class _ProfileTileB extends StatefulWidget {
  final Profile profile;
  const _ProfileTileB({required this.profile});

  @override
  State<_ProfileTileB> createState() => _ProfileTileBState();
}

class _ProfileTileBState extends State<_ProfileTileB>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HoverBentoCard(
      accentGlowColor: AppColors.emerald,
      padding: const EdgeInsets.all(26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animated Gradient Border Squircle Avatar Frame
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              final angle = _rotationController.value * 2 * math.pi;
              return Container(
                width: 140,
                height: 140,
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  gradient: SweepGradient(
                    transform: GradientRotation(angle),
                    colors: const [
                      AppColors.electricCyan,
                      AppColors.emerald,
                      Color(0xFFA855F7),
                      AppColors.electricCyan,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emerald.withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(33),
                  child: Container(
                    color: AppColors.cardSurfaceSolid,
                    child: Image.asset(
                      widget.profile.profilePicture,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.cardSurfaceElevated,
                        child: const Icon(
                          Icons.person_rounded,
                          size: 64,
                          color: AppColors.electricCyan,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Name
          Text(
            widget.profile.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),

          // Title
          Text(
            'Mobile Architect | Senior Android & Flutter Consultant',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),

          // Location Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.cardSurfaceElevated,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColors.cardBorder,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 13,
                  color: AppColors.emerald,
                ),
                const SizedBox(width: 6),
                Text(
                  'Kolkata, India',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bento Tile C: High-Impact Metrics Strip (Span 1 col)
// ---------------------------------------------------------------------------
class _MetricsTileC extends StatelessWidget {
  const _MetricsTileC();

  @override
  Widget build(BuildContext context) {
    return const HoverBentoCard(
      accentGlowColor: AppColors.electricCyan,
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MetricRowItem(
            value: '9+ Years',
            label: 'Production Exp',
            detail: 'Native Android & Flutter Core',
            accentColor: AppColors.electricCyan,
          ),
          _MetricDivider(),
          _MetricRowItem(
            value: '9+ Apps',
            label: 'Enterprise Deployed',
            detail: 'Commercial Play & App Stores',
            accentColor: AppColors.emerald,
          ),
          _MetricDivider(),
          _MetricRowItem(
            value: '100%',
            label: 'Clean Arch & Offline',
            detail: 'Room, Riverpod, NDK & BLE',
            accentColor: Color(0xFFA855F7),
          ),
        ],
      ),
    );
  }
}

class _MetricRowItem extends StatelessWidget {
  final String value;
  final String label;
  final String detail;
  final Color accentColor;

  const _MetricRowItem({
    required this.value,
    required this.label,
    required this.detail,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
                color: accentColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Text(
                label.toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          detail,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 1,
        color: AppColors.cardBorder.withValues(alpha: 0.6),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bento Tile D: Interactive Tech Stack Radar (Span 2 cols)
// ---------------------------------------------------------------------------
enum TechLayerCategory { all, coreUi, stateArch, systemNative }

class _TechRadarTileD extends StatefulWidget {
  const _TechRadarTileD();

  @override
  State<_TechRadarTileD> createState() => _TechRadarTileDState();
}

class _TechRadarTileDState extends State<_TechRadarTileD> {
  TechLayerCategory _activeCategory = TechLayerCategory.all;

  static const List<_TechSkillItem> _allSkills = [
    // Core & UI
    _TechSkillItem('Kotlin', TechLayerCategory.coreUi, AppColors.emerald),
    _TechSkillItem('Dart', TechLayerCategory.coreUi, AppColors.electricCyan),
    _TechSkillItem('Jetpack Compose', TechLayerCategory.coreUi, AppColors.emerald),
    _TechSkillItem('Flutter', TechLayerCategory.coreUi, AppColors.electricCyan),
    _TechSkillItem('Android SDK', TechLayerCategory.coreUi, AppColors.emerald),
    _TechSkillItem('Java', TechLayerCategory.coreUi, Color(0xFFF59E0B)),

    // State & Architecture
    _TechSkillItem('Clean Architecture', TechLayerCategory.stateArch, Color(0xFFA855F7)),
    _TechSkillItem('Riverpod', TechLayerCategory.stateArch, AppColors.electricCyan),
    _TechSkillItem('BLoC', TechLayerCategory.stateArch, AppColors.electricCyan),
    _TechSkillItem('MVVM', TechLayerCategory.stateArch, AppColors.emerald),
    _TechSkillItem('Room DB (SQLite)', TechLayerCategory.stateArch, Color(0xFFF59E0B)),
    _TechSkillItem('Coroutines / Flow', TechLayerCategory.stateArch, AppColors.emerald),

    // System & Native
    _TechSkillItem('Method Channels', TechLayerCategory.systemNative, AppColors.electricCyan),
    _TechSkillItem('NDK / JNI C++', TechLayerCategory.systemNative, Color(0xFFA855F7)),
    _TechSkillItem('Bluetooth / BLE', TechLayerCategory.systemNative, AppColors.emerald),
    _TechSkillItem('Foreground Services', TechLayerCategory.systemNative, AppColors.emerald),
    _TechSkillItem('Offline-First Sync', TechLayerCategory.systemNative, AppColors.electricCyan),
    _TechSkillItem('CI/CD GitHub Actions', TechLayerCategory.systemNative, Color(0xFFF59E0B)),
  ];

  List<_TechSkillItem> get _visibleSkills {
    if (_activeCategory == TechLayerCategory.all) return _allSkills;
    return _allSkills.where((s) => s.category == _activeCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return HoverBentoCard(
      accentGlowColor: AppColors.emerald,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Layer Filter Tabs
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.emerald,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SYSTEM ARCHITECTURE RADAR',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 6,
                children: [
                  _CategoryFilterPill(
                    label: 'All',
                    isSelected: _activeCategory == TechLayerCategory.all,
                    onTap: () => setState(() => _activeCategory = TechLayerCategory.all),
                  ),
                  _CategoryFilterPill(
                    label: 'Core & UI',
                    isSelected: _activeCategory == TechLayerCategory.coreUi,
                    onTap: () => setState(() => _activeCategory = TechLayerCategory.coreUi),
                  ),
                  _CategoryFilterPill(
                    label: 'State & Arch',
                    isSelected: _activeCategory == TechLayerCategory.stateArch,
                    onTap: () => setState(() => _activeCategory = TechLayerCategory.stateArch),
                  ),
                  _CategoryFilterPill(
                    label: 'System & Native',
                    isSelected: _activeCategory == TechLayerCategory.systemNative,
                    onTap: () => setState(() => _activeCategory = TechLayerCategory.systemNative),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Categorized Glowing Pill Chips
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Wrap(
              key: ValueKey(_activeCategory),
              spacing: 8,
              runSpacing: 10,
              children: [
                for (final item in _visibleSkills)
                  _TechRadarChip(item: item),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechSkillItem {
  final String name;
  final TechLayerCategory category;
  final Color color;

  const _TechSkillItem(this.name, this.category, this.color);
}

class _CategoryFilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryFilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.electricCyan.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? AppColors.electricCyan.withValues(alpha: 0.55)
                : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.electricCyan : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _TechRadarChip extends StatefulWidget {
  final _TechSkillItem item;
  const _TechRadarChip({required this.item});

  @override
  State<_TechRadarChip> createState() => _TechRadarChipState();
}

class _TechRadarChipState extends State<_TechRadarChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.item.color;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _isHovered
              ? color.withValues(alpha: 0.18)
              : color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isHovered
                ? color.withValues(alpha: 0.65)
                : color.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              widget.item.name,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: _isHovered ? AppColors.textPrimary : AppColors.textPrimary.withValues(alpha: 0.88),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared Micro-Widgets for Hero
// ---------------------------------------------------------------------------
class _PulsingStatusPill extends StatefulWidget {
  final String label;
  const _PulsingStatusPill({required this.label});

  @override
  State<_PulsingStatusPill> createState() => _PulsingStatusPillState();
}

class _PulsingStatusPillState extends State<_PulsingStatusPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.emerald.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.emerald.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald.withValues(alpha: 0.12),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 12 + (_pulseController.value * 4),
                    height: 12 + (_pulseController.value * 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emerald.withValues(
                        alpha: 0.3 * (1.0 - _pulseController.value),
                      ),
                    ),
                  ),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emerald,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              widget.label,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF34D399),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionGradientButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _PrimaryActionGradientButton({
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  State<_PrimaryActionGradientButton> createState() =>
      _PrimaryActionGradientButtonState();
}

class _PrimaryActionGradientButtonState
    extends State<_PrimaryActionGradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: _isHovered
                  ? [const Color(0xFF0EA5E9), const Color(0xFF10B981)]
                  : [AppColors.electricCyan, AppColors.emerald],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.electricCyan.withValues(alpha: 0.5)
                    : AppColors.electricCyan.withValues(alpha: 0.25),
                blurRadius: _isHovered ? 20 : 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 17, color: const Color(0xFF07090E)),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF07090E),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryGlassButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _SecondaryGlassButton({
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  State<_SecondaryGlassButton> createState() => _SecondaryGlassButtonState();
}

class _SecondaryGlassButtonState extends State<_SecondaryGlassButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.cardSurfaceSolid,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? AppColors.electricCyan : AppColors.cardBorder,
              width: 1,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 16,
                  color: _isHovered ? AppColors.electricCyan : AppColors.textPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: _isHovered ? AppColors.electricCyan : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback? onTap;

  const _SocialIconButton({
    required this.tooltip,
    required this.icon,
    this.onTap,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.electricCyan.withValues(alpha: 0.12)
                  : AppColors.cardSurfaceSolid,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered ? AppColors.electricCyan : AppColors.cardBorder,
                width: 1,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: _isHovered ? AppColors.electricCyan : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
