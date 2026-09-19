import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/glass_container.dart';
import '../common/gradient_text.dart';
import '../common/section_wrapper.dart';

enum _EducationFilter { all, degrees, certifications, schooling }

/// Upgraded, state-of-the-art Education, Academics & Schooling section
/// presenting university degrees (MCA & BCA), professional certification,
/// and foundational schooling (12th & 10th) with interactive glassmorphism.
class EducationSection extends StatefulWidget {
  final Profile profile;
  final GlobalKey? sectionKey;

  const EducationSection({
    required this.profile,
    this.sectionKey,
    super.key,
  });

  @override
  State<EducationSection> createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  _EducationFilter _activeFilter = _EducationFilter.all;

  List<EducationItem> _getFilteredItems() {
    switch (_activeFilter) {
      case _EducationFilter.all:
        return widget.profile.education;
      case _EducationFilter.degrees:
        return widget.profile.education
            .where((e) => !e.isCertification && (e.title.contains('MCA') || e.title.contains('BCA') || e.title.contains('Master') || e.title.contains('Bachelor') || e.title.contains('মাস্টার') || e.title.contains('ব্যাচেলর') || e.title.contains('मास्टर') || e.title.contains('बैचलर')))
            .toList();
      case _EducationFilter.certifications:
        return widget.profile.education.where((e) => e.isCertification).toList();
      case _EducationFilter.schooling:
        return widget.profile.education
            .where((e) => !e.isCertification && !(e.title.contains('MCA') || e.title.contains('BCA') || e.title.contains('Master') || e.title.contains('Bachelor') || e.title.contains('মাস্টার') || e.title.contains('ব্যাচেলর') || e.title.contains('मास्टर') || e.title.contains('बैचलर')))
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktopOrWider(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 640;
    final isCompact = width < 380;
    final filteredItems = _getFilteredItems();

    return SectionWrapper(
      sectionKey: widget.sectionKey,
      verticalPadding: isDesktop ? 96 : 48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Pill
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.school_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ACADEMIC & SCHOOLING FOUNDATION',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    '${widget.profile.education.length} MILESTONES',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Main Headline
          GradientText(
            'Education & Academic Journey',
            colors: isDark
                ? [Colors.white, const Color(0xFF93C5FD), AppColors.primary]
                : [AppColors.lightTextPrimary, AppColors.primary],
            style: GoogleFonts.plusJakartaSans(
              fontSize: isDesktop ? 40 : (isCompact ? 26 : 30),
              fontWeight: FontWeight.w900,
              letterSpacing: isCompact ? -0.8 : -1.2,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),

          // Context Subtitle
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Text(
              'From foundational high school education in Serampore to Bachelor\'s and Master\'s degrees in Computer Applications, my formal academic path provided the mathematical, algorithmic, and software architecture principles that power 9+ years of mission-critical mobile development.',
              style: GoogleFonts.inter(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                fontSize: isMobile ? 14 : 16,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Summary Metrics Strip
          _AcademicMetricsStrip(isDark: isDark),
          const SizedBox(height: 32),

          // Interactive Category Filter Tabs
          _buildFilterTabs(isDark: isDark),
          const SizedBox(height: 28),

          // Responsive Milestone Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isMultiCol = constraints.maxWidth >= 840;
              final cardWidth = isMultiCol
                  ? (constraints.maxWidth - 20) / 2
                  : constraints.maxWidth;
              final double cardHeight;
              if (isMultiCol) {
                cardHeight = 390.0;
              } else if (constraints.maxWidth < 380) {
                cardHeight = 440.0;
              } else if (constraints.maxWidth < 600) {
                cardHeight = 390.0;
              } else {
                cardHeight = 360.0;
              }

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  for (final item in filteredItems)
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: _EducationMilestoneCard(
                        item: item,
                        isDark: isDark,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs({required bool isDark}) {
    final degreesCount = widget.profile.education
        .where((e) => !e.isCertification && (e.title.contains('MCA') || e.title.contains('BCA') || e.title.contains('Master') || e.title.contains('Bachelor') || e.title.contains('মাস্টার') || e.title.contains('ব্যাচেলর') || e.title.contains('मास्टर') || e.title.contains('बैचलर')))
        .length;
    final certsCount = widget.profile.education.where((e) => e.isCertification).length;
    final schoolCount = widget.profile.education
        .where((e) => !e.isCertification && !(e.title.contains('MCA') || e.title.contains('BCA') || e.title.contains('Master') || e.title.contains('Bachelor') || e.title.contains('মাস্টার') || e.title.contains('ব্যাচেলর') || e.title.contains('मास्टर') || e.title.contains('बैचलर')))
        .length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            filter: _EducationFilter.all,
            label: 'All Milestones',
            count: widget.profile.education.length,
            isDark: isDark,
          ),
          const SizedBox(width: 10),
          _buildFilterChip(
            filter: _EducationFilter.degrees,
            label: 'University Degrees',
            count: degreesCount,
            isDark: isDark,
          ),
          const SizedBox(width: 10),
          _buildFilterChip(
            filter: _EducationFilter.certifications,
            label: 'Technical Certifications',
            count: certsCount,
            isDark: isDark,
          ),
          const SizedBox(width: 10),
          _buildFilterChip(
            filter: _EducationFilter.schooling,
            label: 'Schooling (10th & 12th)',
            count: schoolCount,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required _EducationFilter filter,
    required String label,
    required int count,
    required bool isDark,
  }) {
    final isSelected = _activeFilter == filter;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _activeFilter = filter),
        borderRadius: BorderRadius.circular(50),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.18)
                : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.12),
              width: isSelected ? 1.4 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? (isDark ? Colors.white : AppColors.primary)
                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact info strip highlighting academic rigor and university credentials
class _AcademicMetricsStrip extends StatelessWidget {
  final bool isDark;

  const _AcademicMetricsStrip({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 10,
      children: [
        _buildMetricItem(
          icon: Icons.school_rounded,
          title: '2 Degrees',
          subtitle: 'MCA + BCA',
          accentColor: const Color(0xFF6366F1),
        ),
        _buildMetricItem(
          icon: Icons.account_balance_rounded,
          title: 'WBUT / MAKAUT',
          subtitle: 'State Technical University',
          accentColor: const Color(0xFF0EA5E9),
        ),
        _buildMetricItem(
          icon: Icons.workspace_premium_rounded,
          title: 'First Class',
          subtitle: '7.2+ Consistent CGPA',
          accentColor: const Color(0xFFF59E0B),
        ),
        _buildMetricItem(
          icon: Icons.domain_rounded,
          title: 'Serampore Roots',
          subtitle: 'HS (12th) & Madhyamik (10th)',
          accentColor: const Color(0xFF10B981),
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
  }) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.035),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: accentColor),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Rich interactive card representing an individual academic degree, schooling, or certification
class _EducationMilestoneCard extends StatefulWidget {
  final EducationItem item;
  final bool isDark;

  const _EducationMilestoneCard({
    required this.item,
    required this.isDark,
  });

  @override
  State<_EducationMilestoneCard> createState() => _EducationMilestoneCardState();
}

class _EducationMilestoneCardState extends State<_EducationMilestoneCard> {
  bool _isHovered = false;

  Color _getAccentColor() {
    final title = widget.item.title.toLowerCase();
    if (widget.item.isCertification) {
      return const Color(0xFF10B981); // Emerald
    }
    if (title.contains('mca') || title.contains('master') || title.contains('মাস্টার') || title.contains('मास्टर')) {
      return const Color(0xFF6366F1); // Indigo / Electric Blue
    }
    if (title.contains('bca') || title.contains('bachelor') || title.contains('ব্যাচেলর') || title.contains('बैचलर')) {
      return const Color(0xFF0EA5E9); // Sky Blue / Cyan
    }
    if (title.contains('higher') || title.contains('12th') || title.contains('উচ্চ') || title.contains('12')) {
      return const Color(0xFFF59E0B); // Amber / Gold
    }
    return const Color(0xFF8B5CF6); // Purple / Violet for 10th
  }

  IconData _getIcon() {
    final title = widget.item.title.toLowerCase();
    if (widget.item.isCertification) {
      return Icons.verified_rounded;
    }
    if (title.contains('mca') || title.contains('master') || title.contains('মাস্টার') || title.contains('मास्टर')) {
      return Icons.school_rounded;
    }
    if (title.contains('bca') || title.contains('bachelor') || title.contains('ব্যাচেলর') || title.contains('बैचलर')) {
      return Icons.computer_rounded;
    }
    if (title.contains('higher') || title.contains('12th') || title.contains('উচ্চ') || title.contains('12')) {
      return Icons.menu_book_rounded;
    }
    return Icons.auto_stories_rounded;
  }

  String _getCategoryTag() {
    if (widget.item.degreeType != null) {
      return widget.item.degreeType!.toUpperCase();
    }
    if (widget.item.isCertification) {
      return 'PROFESSIONAL CERTIFICATION';
    }
    final title = widget.item.title.toLowerCase();
    if (title.contains('mca') || title.contains('master')) {
      return 'POST-GRADUATE DEGREE · 3 YEARS';
    }
    if (title.contains('bca') || title.contains('bachelor')) {
      return 'UNDERGRADUATE DEGREE · 3 YEARS';
    }
    if (title.contains('higher') || title.contains('12th')) {
      return 'HIGHER SECONDARY SCHOOLING';
    }
    return 'SECONDARY SCHOOL EDUCATION';
  }

  @override
  Widget build(BuildContext context) {
    final accent = _getAccentColor();
    final icon = _getIcon();
    final category = _getCategoryTag();
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 640;
    final isCompact = width < 380;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        child: GlassContainer(
          padding: EdgeInsets.all(isCompact ? 12 : (isMobile ? 14 : 18)),
          glowColor: accent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Row: Category Pill & Timeline Period Badge
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(isCompact ? 5 : 6),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: _isHovered ? 0.22 : 0.12),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: accent.withValues(alpha: 0.35),
                                  width: 1,
                                ),
                              ),
                              child: Icon(icon, size: isCompact ? 13 : 14, color: accent),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              category,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: isCompact ? 9 : (isMobile ? 9.5 : 10),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 7 : 9,
                          vertical: isCompact ? 3 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: (widget.isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: (widget.isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: isCompact ? 10 : 11,
                              color: widget.isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.item.period,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: isCompact ? 9.5 : 10.5,
                                fontWeight: FontWeight.w700,
                                color: widget.isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isCompact ? 8 : 12),

                  // Title (Degree / Certification / Schooling)
                  Text(
                    widget.item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isCompact ? 15 : (isMobile ? 16.5 : 18),
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: theme.colorScheme.onSurface,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Institution Name & Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: isCompact ? 12 : 13.5,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${widget.item.institution}${widget.item.location != null ? ' · ${widget.item.location}' : ''}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: isCompact ? 11.5 : (isMobile ? 12.5 : 13.5),
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Achievement / Detail Badge (e.g. CGPA, First Class)
                  if (widget.item.detail != null || widget.item.isCertification) ...[
                    SizedBox(height: isCompact ? 8 : 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 8 : 10,
                          vertical: isCompact ? 3.5 : 4.5,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.item.isCertification
                                  ? Icons.verified_user_rounded
                                  : Icons.star_rounded,
                              size: isCompact ? 11.5 : 13,
                              color: accent,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.item.detail ?? 'Certified Professional Developer',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: isCompact ? 10 : 11,
                                fontWeight: FontWeight.w800,
                                color: accent,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // Coursework / Key Subject Tags pinned at bottom
              if (widget.item.coursework.isNotEmpty) ...[
                SizedBox(height: isCompact ? 8 : 10),
                Wrap(
                  spacing: isCompact ? 4 : 6,
                  runSpacing: isCompact ? 4 : 6,
                  children: [
                    for (final subject in widget.item.coursework)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 6 : 8,
                          vertical: isCompact ? 2.5 : 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: (widget.isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: (widget.isDark ? Colors.white : Colors.black).withValues(alpha: 0.07),
                          ),
                        ),
                        child: Text(
                          subject,
                          style: GoogleFonts.inter(
                            fontSize: isCompact ? 9.5 : (isMobile ? 10 : 11),
                            fontWeight: FontWeight.w500,
                            color: widget.isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF475569),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
