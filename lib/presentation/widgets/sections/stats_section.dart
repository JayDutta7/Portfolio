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
        label: profile.stats.isNotEmpty ? profile.stats[0].label.toUpperCase() : 'YEARS EXPERIENCE',
        sub: 'Android & Flutter Development',
        colors: const [AppColors.primary, AppColors.secondary],
        icon: Icons.workspace_premium_rounded,
      ),
      _StatItem(
        value: profile.stats.length > 1 ? profile.stats[1].value : '2',
        label: profile.stats.length > 1 ? profile.stats[1].label.toUpperCase() : 'PLATFORMS',
        sub: 'Android + Flutter Cross-Platform',
        colors: const [AppColors.secondary, AppColors.flutterBlue],
        icon: Icons.devices_rounded,
      ),
      _StatItem(
        value: profile.stats.length > 2 ? profile.stats[2].value : '9',
        label: profile.stats.length > 2 ? profile.stats[2].label.toUpperCase() : 'PRODUCTION APPS',
        sub: 'Verified & Deployed to Stores',
        colors: const [AppColors.androidGreen, AppColors.emerald],
        icon: Icons.verified_rounded,
      ),
      _StatItem(
        value: profile.stats.length > 3 ? profile.stats[3].value : '4',
        label: profile.stats.length > 3 ? profile.stats[3].label.toUpperCase() : 'COMPANIES',
        sub: 'Enterprise-Scale Delivery',
        colors: const [AppColors.accent, Color(0xFFEC4899)],
        icon: Icons.business_rounded,
      ),
    ];

    return SectionWrapper(
      sectionKey: sectionKey,
      verticalPadding: 32,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          if (width >= 900) {
            // Desktop: 4 cards in a single row
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < statsData.length; i++) ...[
                    Expanded(child: _ImpactStatCard(stat: statsData[i])),
                    if (i < statsData.length - 1) const SizedBox(width: 16),
                  ],
                ],
              ),
            );
          } else if (width >= 500) {
            // Tablet: 2x2 grid
            return Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _ImpactStatCard(stat: statsData[0])),
                      const SizedBox(width: 14),
                      Expanded(child: _ImpactStatCard(stat: statsData[1])),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _ImpactStatCard(stat: statsData[2])),
                      const SizedBox(width: 14),
                      Expanded(child: _ImpactStatCard(stat: statsData[3])),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Mobile: stacked vertically
            return Column(
              children: [
                for (int i = 0; i < statsData.length; i++) ...[
                  _ImpactStatCard(stat: statsData[i]),
                  if (i < statsData.length - 1) const SizedBox(height: 12),
                ],
              ],
            );
          }
        },
      ),
    );
  }
}

class _StatItem {
  final String value;
  final String label;
  final String sub;
  final List<Color> colors;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.sub,
    required this.colors,
    required this.icon,
  });
}

class _ImpactStatCard extends StatefulWidget {
  final _StatItem stat;
  const _ImpactStatCard({required this.stat});

  @override
  State<_ImpactStatCard> createState() => _ImpactStatCardState();
}

class _ImpactStatCardState extends State<_ImpactStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final stat = widget.stat;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurface.withValues(alpha: _isHovered ? 0.95 : 0.85)
              : Colors.white.withValues(alpha: _isHovered ? 1.0 : 0.96),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? stat.colors.first.withValues(alpha: 0.5)
                : (isDark
                    ? AppColors.darkBorder.withValues(alpha: 0.6)
                    : AppColors.lightBorder),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (_isHovered) ...[
              BoxShadow(
                color: stat.colors.first.withValues(alpha: isDark ? 0.25 : 0.14),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ] else ...[
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.20)
                    : const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row: Icon badge + accent dot
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Glowing icon container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: _isHovered
                        ? LinearGradient(
                            colors: [
                              stat.colors.first.withValues(alpha: 0.20),
                              stat.colors.last.withValues(alpha: 0.10),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: _isHovered
                        ? null
                        : stat.colors.first.withValues(alpha: isDark ? 0.12 : 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: stat.colors.first.withValues(alpha: _isHovered ? 0.45 : 0.25),
                      width: 1,
                    ),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: stat.colors.first.withValues(alpha: 0.30),
                              blurRadius: 12,
                              spreadRadius: -2,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(stat.icon, color: stat.colors.first, size: 18),
                ),
                // Live status dot
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: _isHovered ? 8 : 6,
                  height: _isHovered ? 8 : 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: stat.colors.first,
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: stat.colors.first.withValues(alpha: 0.6),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Giant metric number with gradient
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                colors: stat.colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                stat.value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  letterSpacing: -2.0,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Accent bar separator
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 2.5,
              width: _isHovered ? 48 : 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [
                    stat.colors.first,
                    stat.colors.last.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Metric label
            Text(
              stat.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: theme.colorScheme.onSurface.withValues(alpha: isDark ? 0.85 : 0.75),
              ),
            ),

            const SizedBox(height: 3),

            // Subtle sub description
            Text(
              stat.sub,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
