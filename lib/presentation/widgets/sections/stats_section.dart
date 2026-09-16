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
        suffix: profile.stats.isNotEmpty ? _extractSuffix(profile.stats[0].value) : '+',
        title: profile.stats.isNotEmpty ? profile.stats[0].label.toUpperCase() : 'YEARS EXPERIENCE',
        subtitle: 'Enterprise Android & Flutter',
        icon: Icons.workspace_premium_rounded,
        gradient: const [AppColors.primary, Color(0xFF6366F1)],
      ),
      _StatConfig(
        targetNumber: _extractNumber(profile.stats.length > 1 ? profile.stats[1].value : '9'),
        suffix: profile.stats.length > 1 ? _extractSuffix(profile.stats[1].value) : '',
        title: profile.stats.length > 1 ? profile.stats[1].label.toUpperCase() : 'VERIFIED PRODUCTION APPS',
        subtitle: 'Consumer & Business Scale',
        icon: Icons.verified_rounded,
        gradient: const [Color(0xFF10B981), Color(0xFF06B6D4)],
      ),
      _StatConfig(
        targetNumber: _extractNumber(profile.stats.length > 2 ? profile.stats[2].value : '4'),
        suffix: profile.stats.length > 2 ? _extractSuffix(profile.stats[2].value) : '',
        title: profile.stats.length > 2 ? profile.stats[2].label.toUpperCase() : 'COMPANIES',
        subtitle: 'Fintech, Steel & Media Labs',
        icon: Icons.business_rounded,
        gradient: const [AppColors.accent, Color(0xFFEC4899)],
      ),
      _StatConfig(
        targetNumber: _extractNumber(profile.stats.length > 3 ? profile.stats[3].value : '2'),
        suffix: profile.stats.length > 3 ? _extractSuffix(profile.stats[3].value) : '',
        title: profile.stats.length > 3 ? profile.stats[3].label.toUpperCase() : 'PLATFORMS',
        subtitle: 'Android & iOS Ecosystems',
        icon: Icons.devices_rounded,
        gradient: const [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
      ),
      _StatConfig(
        targetNumber: _extractNumber(profile.stats.length > 4 ? profile.stats[4].value : '50K+'),
        suffix: profile.stats.length > 4 ? _extractSuffix(profile.stats[4].value) : 'K+',
        title: profile.stats.length > 4 ? profile.stats[4].label.toUpperCase() : 'DOWNLOADS',
        subtitle: 'App Store & Play Store',
        icon: Icons.cloud_download_rounded,
        gradient: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
      ),
      _StatConfig(
        targetNumber: 99,
        suffix: profile.stats.length > 5 && profile.stats[5].value.contains('99.8') ? '.8%+' : '%+',
        title: profile.stats.length > 5 ? profile.stats[5].label.toUpperCase() : 'CRASH-FREE RATES',
        subtitle: 'Enterprise Reliability',
        icon: Icons.health_and_safety_rounded,
        gradient: const [Color(0xFF22C55E), Color(0xFF14B8A6)],
      ),
    ];

    return SectionWrapper(
      sectionKey: sectionKey,
      verticalPadding: 28,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final spacing = width >= 560 ? 24.0 : 16.0;
          final runSpacing = width >= 560 ? 32.0 : 24.0;
          final columns = width >= 960 ? 3 : 2;
          final itemWidth = (width - spacing * (columns - 1)) / columns - 0.1;

          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            alignment: WrapAlignment.start,
            children: statsData.map((config) {
              return SizedBox(
                width: itemWidth,
                child: _CleanAnimatedStat(
                  config: config,
                  isCompact: width < 560,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  static int _extractNumber(String val) {
    var englishVal = val
        .replaceAll('০', '0')
        .replaceAll('১', '1')
        .replaceAll('২', '2')
        .replaceAll('৩', '3')
        .replaceAll('৪', '4')
        .replaceAll('৫', '5')
        .replaceAll('৬', '6')
        .replaceAll('৭', '7')
        .replaceAll('৮', '8')
        .replaceAll('৯', '9');
        
    final cleaned = englishVal.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleaned) ?? 0;
  }

  static String _extractSuffix(String val) {
    return val.replaceAll(RegExp(r'[0-9০-৯]'), '');
  }
}

class _StatConfig {
  final int targetNumber;
  final String suffix;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  const _StatConfig({
    required this.targetNumber,
    required this.suffix,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

/// Clean, cardless animated stat with stepped increasing numbers (e.g. 1 2 3 4 5 6 7 8 9+)
class _CleanAnimatedStat extends StatefulWidget {
  final _StatConfig config;
  final bool isCompact;

  const _CleanAnimatedStat({
    required this.config,
    this.isCompact = false,
  });

  @override
  State<_CleanAnimatedStat> createState() => _CleanAnimatedStatState();
}

class _CleanAnimatedStatState extends State<_CleanAnimatedStat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  ScrollPosition? _scrollPosition;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    // Duration gives clear ~150ms per digit step so users can see each number count up
    final durationMs = (widget.config.targetNumber * 160).clamp(700, 1600);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationMs),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    );

    // Initial visibility check on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newPosition = Scrollable.maybeOf(context)?.position;
    if (_scrollPosition != newPosition) {
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = newPosition;
      _scrollPosition?.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (!_hasTriggered) {
      _checkVisibility();
    }
  }

  void _checkVisibility() {
    if (!mounted || _hasTriggered) return;
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final pos = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      // Start counting up when top enters the viewport
      if (pos.dy < screenHeight * 0.92 && pos.dy + renderObject.size.height > 0) {
        _hasTriggered = true;
        _controller.forward(from: 0.0);
      }
    } else {
      // Fallback if layout hasn't computed yet
      _hasTriggered = true;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = widget.config.gradient.first;

    return MouseRegion(
      // Re-trigger counting animation on hover for user delight
      onEnter: (_) {
        _controller.forward(from: 0.0);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.isCompact ? 4 : 8,
          vertical: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon badge with soft ambient glow
            Container(
              padding: EdgeInsets.all(widget.isCompact ? 6 : 8),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: isDark ? 0.14 : 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: primaryColor.withValues(alpha: isDark ? 0.28 : 0.18),
                  width: 1,
                ),
              ),
              child: Icon(
                widget.config.icon,
                color: primaryColor,
                size: widget.isCompact ? 18 : 22,
              ),
            ),

            SizedBox(height: widget.isCompact ? 8 : 12),

            // Animated Increasing Number (1 2 3 4 5 6 7 8 9+)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final currentVal =
                    (_animation.value * widget.config.targetNumber).round();
                final isAtTarget = currentVal >= widget.config.targetNumber;

                return FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
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
                            fontSize: widget.isCompact ? 34 : 52,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                            letterSpacing: -2.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Suffix appears when counting reaches target (e.g. 1 2 3 ... 8 9 -> 9+)
                      if (widget.config.suffix.isNotEmpty)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isAtTarget ? 1.0 : 0.0,
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => LinearGradient(
                              colors: widget.config.gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: Text(
                              widget.config.suffix,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: widget.isCompact ? 24 : 36,
                                fontWeight: FontWeight.w800,
                                height: 1.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: widget.isCompact ? 6 : 8),

            // Title
            Text(
              widget.config.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: widget.isCompact ? 11.0 : 13.0,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 3),

            // Subtitle / context
            Text(
              widget.config.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: widget.isCompact ? 10.0 : 12.0,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),

            SizedBox(height: widget.isCompact ? 8 : 10),

            // Subtle gradient indicator bar
            Container(
              height: 2.0,
              width: widget.isCompact ? 24 : 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    widget.config.gradient.last.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
