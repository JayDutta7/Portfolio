import 'dart:async';
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
      _StatItem(
        value: profile.stats.isNotEmpty ? profile.stats[0].value : '9+',
        numericValue: _extractNumber(profile.stats.isNotEmpty ? profile.stats[0].value : '9+'),
        suffix: profile.stats.isNotEmpty && profile.stats[0].value.contains('+') ? '+' : '',
        label: profile.stats.isNotEmpty ? profile.stats[0].label.toUpperCase() : 'YEARS EXPERIENCE',
        colors: const [AppColors.primary, AppColors.secondary],
        icon: Icons.workspace_premium_rounded,
      ),
      _StatItem(
        value: profile.stats.length > 1 ? profile.stats[1].value : '2',
        numericValue: _extractNumber(profile.stats.length > 1 ? profile.stats[1].value : '2'),
        suffix: '',
        label: profile.stats.length > 1 ? profile.stats[1].label.toUpperCase() : 'PLATFORMS',
        colors: const [AppColors.secondary, AppColors.flutterBlue],
        icon: Icons.devices_rounded,
      ),
      _StatItem(
        value: profile.stats.length > 2 ? profile.stats[2].value : '9',
        numericValue: _extractNumber(profile.stats.length > 2 ? profile.stats[2].value : '9'),
        suffix: '',
        label: profile.stats.length > 2 ? profile.stats[2].label.toUpperCase() : 'PRODUCTION APPS',
        colors: const [AppColors.androidGreen, AppColors.emerald],
        icon: Icons.verified_rounded,
      ),
      _StatItem(
        value: profile.stats.length > 3 ? profile.stats[3].value : '4',
        numericValue: _extractNumber(profile.stats.length > 3 ? profile.stats[3].value : '4'),
        suffix: '',
        label: profile.stats.length > 3 ? profile.stats[3].label.toUpperCase() : 'COMPANIES',
        colors: const [AppColors.accent, Color(0xFFEC4899)],
        icon: Icons.business_rounded,
      ),
    ];

    return SectionWrapper(
      sectionKey: sectionKey,
      verticalPadding: 24,
      child: _StatsTickerStrip(stats: statsData),
    );
  }

  static int _extractNumber(String val) {
    final cleaned = val.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleaned) ?? 0;
  }
}

class _StatItem {
  final String value;
  final int numericValue;
  final String suffix;
  final String label;
  final List<Color> colors;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.numericValue,
    required this.suffix,
    required this.label,
    required this.colors,
    required this.icon,
  });
}

/// Animated scrolling ticker strip that auto-scrolls and shows counting numbers
class _StatsTickerStrip extends StatefulWidget {
  final List<_StatItem> stats;
  const _StatsTickerStrip({required this.stats});

  @override
  State<_StatsTickerStrip> createState() => _StatsTickerStripState();
}

class _StatsTickerStripState extends State<_StatsTickerStrip> {
  late final ScrollController _scrollController;
  Timer? _scrollTimer;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Start auto-scroll after a brief delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!_isHovered && _scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        if (maxScroll > 0) {
          final current = _scrollController.offset;
          // Seamless loop: when we reach past the halfway point (one full set), jump back
          final halfwayPoint = maxScroll / 2;
          if (current >= halfwayPoint) {
            _scrollController.jumpTo(current - halfwayPoint);
          } else {
            _scrollController.jumpTo(current + 0.5);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Duplicate stats for seamless infinite scroll
    final tickerItems = [...widget.stats, ...widget.stats];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurface.withValues(alpha: 0.80)
              : Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.6)
                : AppColors.lightBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.25)
                  : const Color(0xFF0F172A).withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Colors.transparent,
                isDark ? Colors.white : Colors.black,
                isDark ? Colors.white : Colors.black,
                Colors.transparent,
              ],
              stops: const [0.0, 0.06, 0.94, 1.0],
            ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: SizedBox(
              height: 110,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tickerItems.length,
                itemBuilder: (context, index) {
                  final stat = tickerItems[index];
                  final isLast = index == tickerItems.length - 1;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _TickerStatCell(stat: stat, isDark: isDark),
                      if (!isLast) _GlowingDivider(isDark: isDark),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual stat cell in the ticker
class _TickerStatCell extends StatelessWidget {
  final _StatItem stat;
  final bool isDark;
  const _TickerStatCell({required this.stat, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          // Accent icon with glow
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: stat.colors.first.withValues(alpha: isDark ? 0.15 : 0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: stat.colors.first.withValues(alpha: 0.30),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: stat.colors.first.withValues(alpha: isDark ? 0.20 : 0.12),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Icon(stat.icon, color: stat.colors.first, size: 20),
          ),

          const SizedBox(width: 14),

          // Number + Label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated counter number
                _AnimatedCounter(
                  targetValue: stat.numericValue,
                  suffix: stat.suffix,
                  colors: stat.colors,
                ),
                const SizedBox(height: 2),
                Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
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

/// Glowing vertical divider between stat cells
class _GlowingDivider extends StatelessWidget {
  final bool isDark;
  const _GlowingDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            (isDark ? AppColors.primary : const Color(0xFF94A3B8)).withValues(alpha: isDark ? 0.35 : 0.25),
            Colors.transparent,
          ],
          stops: const [0.1, 0.5, 0.9],
        ),
      ),
    );
  }
}

/// Counting number animation that rolls up from 0 to target
class _AnimatedCounter extends StatefulWidget {
  final int targetValue;
  final String suffix;
  final List<Color> colors;
  const _AnimatedCounter({
    required this.targetValue,
    required this.suffix,
    required this.colors,
  });

  @override
  State<_AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<_AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentValue = (_animation.value * widget.targetValue).round();
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            colors: widget.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            '$currentValue${widget.suffix}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1.5,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
