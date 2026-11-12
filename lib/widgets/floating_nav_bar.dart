import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Floating Glassmorphic Command Header
///
/// Features:
/// - Sticky, centered pill navigation bar (max-width: 760px, top margin: 20px, borderRadius: 999)
/// - BackdropFilter blur (sigmaX: 16, sigmaY: 16)
/// - Glowing 'JD' monogram badge with animated gradient border
/// - Smooth-scroll section tabs: Overview, Architecture, Projects, Experience, Contact
/// - High-contrast primary CTA button: "Resume / Let's Talk"
/// - Graceful responsive adaptation on all viewports without flex overflow
class FloatingNavBar extends StatelessWidget {
  final String activeSection;
  final ValueChanged<String>? onSectionTap;
  final VoidCallback? onCtaTap;
  final VoidCallback? onLogoTap;

  static const List<String> navTabs = [
    'Overview',
    'Architecture',
    'Projects',
    'Experience',
    'Contact',
  ];

  const FloatingNavBar({
    this.activeSection = 'Overview',
    this.onSectionTap,
    this.onCtaTap,
    this.onLogoTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final isMobile = availableWidth < 680;
        final isCompact = availableWidth < 460;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Container(
              margin: EdgeInsets.only(
                top: isMobile ? 12 : 20,
                left: isCompact ? 10 : 16,
                right: isCompact ? 10 : 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.cardBorder.withValues(alpha: 0.9),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: AppColors.cyanGlow.withValues(alpha: 0.08),
                    blurRadius: 24,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    height: isMobile ? 50 : 56,
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 6 : (isMobile ? 8 : 12),
                      vertical: 4,
                    ),
                    color: AppColors.cardSurfaceSolid.withValues(alpha: 0.85),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Glowing Monogram Badge
                        _MonogramBadge(onTap: onLogoTap),
                        const SizedBox(width: 6),

                        // Section Tabs or Mobile Dropdown
                        if (!isMobile)
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (final tab in navTabs)
                                      _NavTabItem(
                                        title: tab,
                                        isActive: activeSection.toLowerCase() ==
                                            tab.toLowerCase(),
                                        onTap: () => onSectionTap?.call(tab),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: Center(
                              child: _MobileNavDropdown(
                                activeSection: activeSection,
                                tabs: navTabs,
                                onSectionTap: onSectionTap,
                              ),
                            ),
                          ),
                        const SizedBox(width: 6),

                        // High-Contrast Primary CTA Button
                        _PrimaryCtaButton(
                          isCompact: isCompact || availableWidth < 740,
                          onTap: onCtaTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MonogramBadge extends StatefulWidget {
  final VoidCallback? onTap;
  const _MonogramBadge({this.onTap});

  @override
  State<_MonogramBadge> createState() => _MonogramBadgeState();
}

class _MonogramBadgeState extends State<_MonogramBadge> {
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
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: _isHovered ? AppColors.electricCyan : AppColors.cardBorder,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.electricCyan.withValues(alpha: 0.45)
                    : AppColors.electricCyan.withValues(alpha: 0.15),
                blurRadius: _isHovered ? 14 : 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.electricCyan, AppColors.emerald],
              ).createShader(bounds),
              child: Text(
                'JD',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTabItem extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTabItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavTabItem> createState() => _NavTabItemState();
}

class _NavTabItemState extends State<_NavTabItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isHighlight = widget.isActive || _isHovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.electricCyan.withValues(alpha: 0.12)
                : (_isHovered
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: widget.isActive
                  ? AppColors.electricCyan.withValues(alpha: 0.35)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isActive) ...[
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: const BoxDecoration(
                    color: AppColors.electricCyan,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
              Text(
                widget.title,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w500,
                  color: widget.isActive
                      ? AppColors.textPrimary
                      : (_isHovered ? AppColors.textPrimary : AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileNavDropdown extends StatelessWidget {
  final String activeSection;
  final List<String> tabs;
  final ValueChanged<String>? onSectionTap;

  const _MobileNavDropdown({
    required this.activeSection,
    required this.tabs,
    this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Navigate Sections',
      color: AppColors.cardSurfaceSolid,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      elevation: 12,
      onSelected: (val) => onSectionTap?.call(val),
      itemBuilder: (context) {
        return tabs.map((tab) {
          final isSelected = activeSection.toLowerCase() == tab.toLowerCase();
          return PopupMenuItem<String>(
            value: tab,
            child: Row(
              children: [
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      color: AppColors.electricCyan,
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  const SizedBox(width: 16),
                Text(
                  tab,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.electricCyan : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                activeSection,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryCtaButton extends StatefulWidget {
  final bool isCompact;
  final VoidCallback? onTap;

  const _PrimaryCtaButton({
    required this.isCompact,
    this.onTap,
  });

  @override
  State<_PrimaryCtaButton> createState() => _PrimaryCtaButtonState();
}

class _PrimaryCtaButtonState extends State<_PrimaryCtaButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final label = widget.isCompact ? "Let's Talk" : "Resume / Let's Talk";

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCompact ? 9 : 14,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
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
                    ? AppColors.electricCyan.withValues(alpha: 0.45)
                    : AppColors.electricCyan.withValues(alpha: 0.22),
                blurRadius: _isHovered ? 16 : 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: widget.isCompact ? 11 : 11.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                    color: const Color(0xFF07090E),
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 13,
                  color: Color(0xFF07090E),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
