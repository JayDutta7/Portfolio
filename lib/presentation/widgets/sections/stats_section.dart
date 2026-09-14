import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/profile_models.dart';
import '../common/section_wrapper.dart';

class StatsSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const StatsSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final statsData = [
      _StatConfig(
        targetNumber: _extractNumber(profile.stats.isNotEmpty ? profile.stats[0].value : '9+'),
        suffix: profile.stats.isNotEmpty && profile.stats[0].value.contains('+') ? '+' : '',
        title: profile.stats.isNotEmpty ? profile.stats[0].label.toUpperCase() : 'YEARS EXPERIENCE',
        subtitle: 'Enterprise Android & Flutter',
        categoryTag: '01 // LEAD',
        icon: Icons.workspace_premium_rounded,
        gradient: const [AppColors.primary, Color(0xFF6366F1)],
      ),
      _StatConfig(
        targetNumber: _extractNumber(profile.stats.length > 1 ? profile.stats[1].value : '9'),
        suffix: '',
        title: profile.stats.length > 1 ? profile.stats[1].label.toUpperCase() : 'VERIFIED PRODUCTION APPS',
        subtitle: 'Consumer & Business Scale',
        categoryTag: '02 // APPS',
        icon: Icons.verified_rounded,
        gradient: const [Color(0xFF10B981), Color(0xFF06B6D4)],
      ),
      _StatConfig(
        targetNumber: _extractNumber(profile.stats.length > 2 ? profile.stats[2].value : '4'),
        suffix: '',
        title: profile.stats.length > 2 ? profile.stats[2].label.toUpperCase() : 'COMPANIES',
        subtitle: 'Fintech, Steel & Media Labs',
        categoryTag: '03 // CORPS',
        icon: Icons.business_rounded,
        gradient: const [AppColors.accent, Color(0xFFEC4899)],
      ),
      _StatConfig(
        targetNumber: _extractNumber(profile.stats.length > 3 ? profile.stats[3].value : '2'),
        suffix: '',
        title: profile.stats.length > 3 ? profile.stats[3].label.toUpperCase() : 'PLATFORMS',
        subtitle: 'Android & iOS Ecosystems',
        categoryTag: '04 // DUAL',
        icon: Icons.devices_rounded,
        gradient: const [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
      ),
    ];

    return SectionWrapper(
      sectionKey: sectionKey,
      verticalPadding: 28,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          if (width >= 960) {
            // Desktop: 4 cards in a row
            return Row(
              children: [
                for (int i = 0; i < statsData.length; i++) ...[
                  if (i > 0) const SizedBox(width: 14),
                  Expanded(
                    child: _BentoStatCard(
                      config: statsData[i],
                      index: i,
                    ),
                  ),
                ],
              ],
            );
          } else if (width >= 560) {
            // Tablet: 2x2 Grid
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _BentoStatCard(config: statsData[0], index: 0)),
                    const SizedBox(width: 12),
                    Expanded(child: _BentoStatCard(config: statsData[1], index: 1)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _BentoStatCard(config: statsData[2], index: 2)),
                    const SizedBox(width: 12),
                    Expanded(child: _BentoStatCard(config: statsData[3], index: 3)),
                  ],
                ),
              ],
            );
          } else {
            // Mobile: 2x2 compact grid with adjusted typography & spacing
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _BentoStatCard(config: statsData[0], index: 0, isCompact: true)),
                    const SizedBox(width: 8),
                    Expanded(child: _BentoStatCard(config: statsData[1], index: 1, isCompact: true)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _BentoStatCard(config: statsData[2], index: 2, isCompact: true)),
                    const SizedBox(width: 8),
                    Expanded(child: _BentoStatCard(config: statsData[3], index: 3, isCompact: true)),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  static int _extractNumber(String val) {
    final cleaned = val.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleaned) ?? 0;
  }
}

class _StatConfig {
  final int targetNumber;
  final String suffix;
  final String title;
  final String subtitle;
  final String categoryTag;
  final IconData icon;
  final List<Color> gradient;

  const _StatConfig({
    required this.targetNumber,
    required this.suffix,
    required this.title,
    required this.subtitle,
    required this.categoryTag,
    required this.icon,
    required this.gradient,
  });
}

/// Eye-catching Bento HUD Card with animated counting number and glow effects
class _BentoStatCard extends StatefulWidget {
  final _StatConfig config;
  final int index;
  final bool isCompact;

  const _BentoStatCard({
    required this.config,
    required this.index,
    this.isCompact = false,
  });

  @override
  State<_BentoStatCard> createState() => _BentoStatCardState();
}

class _BentoStatCardState extends State<_BentoStatCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _counterController;
  late final Animation<double> _countAnimation;

  @override
  void initState() {
    super.initState();
    _counterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _countAnimation = CurvedAnimation(
      parent: _counterController,
      curve: Curves.easeOutCubic,
    );
    _counterController.forward();
  }

  @override
  void dispose() {
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = widget.config.gradient.first;
    final secondaryColor = widget.config.gradient.last;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: isDark
              ? (_isHovered
                  ? const Color(0xFF131B2E)
                  : const Color(0xFF0C101B).withValues(alpha: 0.85))
              : (_isHovered
                  ? Colors.white
                  : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? primaryColor.withValues(alpha: isDark ? 0.70 : 0.50)
                : (isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.8)
                    : const Color(0xFFE2E8F0)),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: primaryColor.withValues(alpha: isDark ? 0.25 : 0.15),
                blurRadius: 20,
                offset: const Offset(0, 6),
              )
            else
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.20)
                    : const Color(0xFF64748B).withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Ambient radial glow behind the number
              Positioned(
                top: -24,
                right: -24,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isHovered ? (isDark ? 0.35 : 0.18) : (isDark ? 0.14 : 0.07),
                  child: Container(
                    width: widget.isCompact ? 90 : 120,
                    height: widget.isCompact ? 90 : 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor,
                          secondaryColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Card content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isCompact ? 12 : 18,
                  vertical: widget.isCompact ? 12 : 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top header: Icon Badge + (Optional) Category Tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Glass icon badge
                        Container(
                          padding: EdgeInsets.all(widget.isCompact ? 6 : 8),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: isDark ? 0.16 : 0.10),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: isDark ? 0.35 : 0.25),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            widget.config.icon,
                            color: primaryColor,
                            size: widget.isCompact ? 16 : 20,
                          ),
                        ),

                        // Tech badge / index (shown on tablet and desktop)
                        if (!widget.isCompact)
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.config.categoryTag,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 9.0,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: widget.isCompact ? 8 : 12),

                    // Increasing Animated Number with Gradient ShaderMask
                    AnimatedBuilder(
                      animation: _countAnimation,
                      builder: (context, child) {
                        final currentVal =
                            (_countAnimation.value * widget.config.targetNumber).round();
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) => LinearGradient(
                                colors: widget.config.gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                '$currentVal',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: widget.isCompact ? 28 : 44,
                                  fontWeight: FontWeight.w900,
                                  height: 1.0,
                                  letterSpacing: -1.2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (widget.config.suffix.isNotEmpty)
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: widget.config.gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds),
                                child: Text(
                                  widget.config.suffix,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: widget.isCompact ? 20 : 30,
                                    fontWeight: FontWeight.w800,
                                    height: 1.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: widget.isCompact ? 5 : 8),

                    // Title
                    Text(
                      widget.config.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: widget.isCompact ? 10.5 : 12.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Subtitle / context
                    Text(
                      widget.config.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: widget.isCompact ? 9.5 : 11.0,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),

                    SizedBox(height: widget.isCompact ? 8 : 12),

                    // Glowing accent line at bottom that expands on hover
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      height: 2.0,
                      width: _isHovered ? (widget.isCompact ? 40 : 54) : 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            secondaryColor.withValues(alpha: 0.2),
                          ],
                        ),
                        boxShadow: [
                          if (_isHovered)
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.6),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
