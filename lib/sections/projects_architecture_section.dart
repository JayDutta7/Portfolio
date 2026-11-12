import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/utils/launch_helper.dart';
import '../domain/models/profile_models.dart';
import '../theme/app_theme.dart';
import '../widgets/hover_bento_card.dart';

/// Interactive "Product vs. Architecture" Case Study Cards
///
/// Features:
/// - Stateful `ProjectBentoCard` with `[ Overview ]` | `[ Architecture ]` segmented toggle
/// - AnimatedCrossFade / AnimatedSwitcher transitions
/// - Overview Mode: Problem solved, quantifiable business impact, tech chips, screenshots
/// - Architecture Mode: JetBrains Mono visual blueprint with:
///   Presentation Layer -> Domain / UseCases -> Data / Offline Sync -> Platform Bridge / Native Services
/// - Strictly populated with the 5 verified enterprise & commercial production applications
class ProjectsArchitectureSection extends StatelessWidget {
  final GlobalKey? sectionKey;

  const ProjectsArchitectureSection({this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          const _SectionHeaderBlueprint(
            badge: 'ENTERPRISE PRODUCTION CASE STUDIES',
            title: 'Commercial Systems & Architecture Blueprints',
            subtitle:
                'Explore the real-world production applications I have architected and scaled. '
                'Toggle between the business problem/impact overview and the JetBrains Mono technical blueprint.',
          ),
          const SizedBox(height: 36),

          // 5 Verified Enterprise Case Studies
          for (int i = 0; i < _enterpriseCaseStudies.length; i++) ...[
            ProjectBentoCard(
              caseStudy: _enterpriseCaseStudies[i],
              index: i + 1,
            ),
            if (i < _enterpriseCaseStudies.length - 1)
              const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section Header
// ---------------------------------------------------------------------------
class _SectionHeaderBlueprint extends StatelessWidget {
  final String badge;
  final String title;
  final String subtitle;

  const _SectionHeaderBlueprint({
    required this.badge,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.electricCyan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.electricCyan.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            badge,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.electricCyan,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Title
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isMobile ? 26 : 38,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.2,
            height: 1.12,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        // Subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Stateful Project Bento Card with Segmented Toggle
// ---------------------------------------------------------------------------
class ProjectBentoCard extends StatefulWidget {
  final EnterpriseCaseStudy caseStudy;
  final int index;

  const ProjectBentoCard({
    required this.caseStudy,
    required this.index,
    super.key,
  });

  @override
  State<ProjectBentoCard> createState() => _ProjectBentoCardState();
}

class _ProjectBentoCardState extends State<ProjectBentoCard> {
  bool _isArchitectureMode = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 720;
    final accentColor = widget.caseStudy.accentColor;

    return HoverBentoCard(
      accentGlowColor: accentColor,
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Badges & Segmented Toggle
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              // Metadata badges
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      'CASE STUDY 0${widget.index}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Text(
                      widget.caseStudy.company.toUpperCase(),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Text(
                    widget.caseStudy.platformSummary,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),

              // Segmented Toggle: [ Overview ] | [ Architecture ]
              _SegmentedModeToggle(
                isArchitecture: _isArchitectureMode,
                accentColor: accentColor,
                onChanged: (isArch) {
                  setState(() => _isArchitectureMode = isArch);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Project Title
          Text(
            widget.caseStudy.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.caseStudy.roleAndPeriod,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: accentColor,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 24),

          // Animated CrossFade between Overview & Architecture
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 320),
            firstCurve: Curves.easeInOutCubic,
            secondCurve: Curves.easeInOutCubic,
            crossFadeState: _isArchitectureMode
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: _OverviewView(
              caseStudy: widget.caseStudy,
              accentColor: accentColor,
              isMobile: isMobile,
            ),
            secondChild: _ArchitectureView(
              caseStudy: widget.caseStudy,
              accentColor: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Segmented Toggle Widget
// ---------------------------------------------------------------------------
class _SegmentedModeToggle extends StatelessWidget {
  final bool isArchitecture;
  final Color accentColor;
  final ValueChanged<bool> onChanged;

  const _SegmentedModeToggle({
    required this.isArchitecture,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.canvasBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TogglePill(
              label: 'Overview',
              icon: Icons.article_outlined,
              isSelected: !isArchitecture,
              accentColor: accentColor,
              onTap: () => onChanged(false),
            ),
            _TogglePill(
              label: 'Architecture',
              icon: Icons.account_tree_outlined,
              isSelected: isArchitecture,
              accentColor: accentColor,
              onTap: () => onChanged(true),
            ),
          ],
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _TogglePill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: isSelected
                ? accentColor.withValues(alpha: 0.55)
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.15),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? accentColor : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mode 1: Overview View
// ---------------------------------------------------------------------------
class _OverviewView extends StatelessWidget {
  final EnterpriseCaseStudy caseStudy;
  final Color accentColor;
  final bool isMobile;

  const _OverviewView({
    required this.caseStudy,
    required this.accentColor,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 1024;
    final hasScreenshot = caseStudy.screenshotUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDesktop && hasScreenshot)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: _buildOverviewContent(context),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 4,
                child: _buildDeviceMockupPreview(context),
              ),
            ],
          )
        else ...[
          _buildOverviewContent(context),
          if (hasScreenshot) ...[
            const SizedBox(height: 24),
            _buildDeviceMockupPreview(context),
          ],
        ],
      ],
    );
  }

  Widget _buildOverviewContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Problem Statement Box
        _ImpactInfoCard(
          number: '01',
          title: 'PROBLEM SCOPE & CHALLENGE',
          content: caseStudy.problemSolved,
          accentColor: accentColor,
        ),
        const SizedBox(height: 14),

        // Business & Quantifiable Impact Box
        _ImpactInfoCard(
          number: '02',
          title: 'QUANTIFIABLE BUSINESS IMPACT',
          content: caseStudy.businessImpact,
          accentColor: AppColors.emerald,
        ),
        const SizedBox(height: 20),

        // Tech Chips
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ENGINEERING STACK CHIPS',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tech in caseStudy.techChips)
                  _TechChipPill(label: tech, accentColor: accentColor),
              ],
            ),
          ],
        ),

        // Action Links
        if (caseStudy.links.isNotEmpty) ...[
          const SizedBox(height: 22),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              for (final link in caseStudy.links)
                _CaseStudyActionLink(link: link, accentColor: accentColor),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDeviceMockupPreview(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 240),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.asset(
            caseStudy.screenshotUrl!,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              color: AppColors.cardSurfaceElevated,
              child: Center(
                child: Icon(
                  Icons.phone_iphone_rounded,
                  size: 48,
                  color: accentColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImpactInfoCard extends StatelessWidget {
  final String number;
  final String title;
  final String content;
  final Color accentColor;

  const _ImpactInfoCard({
    required this.number,
    required this.title,
    required this.content,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                number,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textPrimary.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }
}

class _TechChipPill extends StatelessWidget {
  final String label;
  final Color accentColor;

  const _TechChipPill({required this.label, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cardSurfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _CaseStudyActionLink extends StatelessWidget {
  final ProjectLink link;
  final Color accentColor;

  const _CaseStudyActionLink({
    required this.link,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => LaunchHelper.openUrl(link.url),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getLinkIcon(link.type),
                  size: 14,
                  color: accentColor,
                ),
                const SizedBox(width: 7),
                Text(
                  link.label,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_outward_rounded,
                  size: 12,
                  color: accentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getLinkIcon(ProjectLinkType type) {
    switch (type) {
      case ProjectLinkType.playStore:
        return Icons.shop_outlined;
      case ProjectLinkType.appStore:
        return Icons.apple;
      case ProjectLinkType.web:
        return Icons.language_rounded;
      case ProjectLinkType.github:
        return Icons.code_rounded;
    }
  }
}

// ---------------------------------------------------------------------------
// Mode 2: Architecture Blueprint View (JetBrains Mono Visual Blueprint)
// ---------------------------------------------------------------------------
class _ArchitectureView extends StatelessWidget {
  final EnterpriseCaseStudy caseStudy;
  final Color accentColor;

  const _ArchitectureView({
    required this.caseStudy,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final bp = caseStudy.blueprint;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF07090E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blueprint Terminal Header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: AppColors.emerald,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    'ARCHITECTURE BLUEPRINT // TIERED CLEAN PATTERN',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.electricCyan,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.cardSurfaceElevated,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(
                  'STRICT SEPARATION OF CONCERNS',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.emerald,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4-Tier Visual Architecture Blueprint Pipeline
          _BlueprintLayerNode(
            stepNumber: '01',
            layerName: 'PRESENTATION LAYER',
            techTag: bp.presentationLayer,
            details: bp.presentationDetails,
            accentColor: AppColors.electricCyan,
          ),
          const _LayerConnectorArrow(),

          _BlueprintLayerNode(
            stepNumber: '02',
            layerName: 'DOMAIN / USECASES LAYER',
            techTag: bp.domainLayer,
            details: bp.domainDetails,
            accentColor: const Color(0xFFA855F7),
          ),
          const _LayerConnectorArrow(),

          _BlueprintLayerNode(
            stepNumber: '03',
            layerName: 'DATA / OFFLINE SYNC LAYER',
            techTag: bp.dataLayer,
            details: bp.dataDetails,
            accentColor: AppColors.amber,
          ),
          const _LayerConnectorArrow(),

          _BlueprintLayerNode(
            stepNumber: '04',
            layerName: 'PLATFORM BRIDGE / NATIVE SERVICES',
            techTag: bp.platformBridgeLayer,
            details: bp.platformBridgeDetails,
            accentColor: AppColors.emerald,
          ),

          const SizedBox(height: 24),
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 20),

          // Architectural Specifications Matrix Table
          Text(
            'RUNTIME & PLATFORM CHARACTERISTICS',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              for (final entry in bp.architectureSpecs.entries)
                _SpecMatrixPill(keyLabel: entry.key, value: entry.value),
            ],
          ),
        ],
      ),
    );
  }
}

class _BlueprintLayerNode extends StatelessWidget {
  final String stepNumber;
  final String layerName;
  final String techTag;
  final List<String> details;
  final Color accentColor;

  const _BlueprintLayerNode({
    required this.stepNumber,
    required this.layerName,
    required this.techTag,
    required this.details,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardSurfaceSolid,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      stepNumber,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    layerName,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  techTag,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final item in details)
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  ↳ ',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: accentColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
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

class _LayerConnectorArrow extends StatelessWidget {
  const _LayerConnectorArrow();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 1,
              height: 14,
              color: AppColors.cardBorder,
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: AppColors.electricCyan,
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecMatrixPill extends StatelessWidget {
  final String keyLabel;
  final String value;

  const _SpecMatrixPill({
    required this.keyLabel,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardSurfaceSolid,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$keyLabel: ',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5 Commercial & Enterprise Production Case Studies Models & Data
// ---------------------------------------------------------------------------
class EnterpriseCaseStudy {
  final String title;
  final String company;
  final String roleAndPeriod;
  final String platformSummary;
  final String problemSolved;
  final String businessImpact;
  final List<String> techChips;
  final String? screenshotUrl;
  final List<ProjectLink> links;
  final Color accentColor;
  final ArchitectureBlueprint blueprint;

  const EnterpriseCaseStudy({
    required this.title,
    required this.company,
    required this.roleAndPeriod,
    required this.platformSummary,
    required this.problemSolved,
    required this.businessImpact,
    required this.techChips,
    required this.screenshotUrl,
    required this.links,
    required this.accentColor,
    required this.blueprint,
  });
}

class ArchitectureBlueprint {
  final String presentationLayer;
  final List<String> presentationDetails;
  final String domainLayer;
  final List<String> domainDetails;
  final String dataLayer;
  final List<String> dataDetails;
  final String platformBridgeLayer;
  final List<String> platformBridgeDetails;
  final Map<String, String> architectureSpecs;

  const ArchitectureBlueprint({
    required this.presentationLayer,
    required this.presentationDetails,
    required this.domainLayer,
    required this.domainDetails,
    required this.dataLayer,
    required this.dataDetails,
    required this.platformBridgeLayer,
    required this.platformBridgeDetails,
    required this.architectureSpecs,
  });
}

final List<EnterpriseCaseStudy> _enterpriseCaseStudies = [
  // 1. Retail CRM (Shyam Steel)
  const EnterpriseCaseStudy(
    title: 'Retail CRM (Field-Force Automation)',
    company: 'Shyam Steel Industries Ltd.',
    roleAndPeriod: 'Lead Android Developer · 2021 – 2024',
    platformSummary: 'Native Android · Kotlin · Clean MVVM',
    problemSolved:
        'A distributed field sales force of hundreds of sales executives operating across rural retail corridors '
        'with patchy cellular reception required automated physical dealer visit validation and real-time order bookings '
        'without battery drain or connectivity loss.',
    businessImpact:
        'Boosted daily dealer visit compliance by 45%, reduced 8-hour shift battery consumption by 38% '
        '(under 4% total drain), and reliably processed over ₹100M+ in quarterly dealer orders.',
    techChips: [
      'Kotlin',
      'Native Android SDK',
      'MVVM',
      'Clean Architecture',
      'Room DB',
      'WorkManager',
      'Foreground Services',
      'FusedLocationProvider',
      'RxJava',
      'Coroutines',
    ],
    screenshotUrl: 'assets/images/crm.jpeg',
    links: [],
    accentColor: AppColors.emerald,
    blueprint: ArchitectureBlueprint(
      presentationLayer: 'MVVM + LiveData & DataBinding',
      presentationDetails: [
        'Lifecycle-aware ViewModel state streams observing Room SQLite livedata',
        'Geo-fenced dealer visit check-in screens with dynamic proximity validation',
      ],
      domainLayer: 'Pure Kotlin UseCases & Repositories',
      domainDetails: [
        'CheckInDealerUseCase with biometric and timestamp verification',
        'GeoFenceValidator computing Haversine distance to registered store coords',
        'OrderBookingEngine validating credit limits and inventory rules',
      ],
      dataLayer: 'Room SQLite (Single Source of Truth) & HTTP Sync',
      dataDetails: [
        'Atomic SQLite transactions with multi-table relation caching',
        'WorkManager background sync worker with exponential backoff and network constraints',
        'Retrofit HTTP client with token refresh interceptors and request batching',
      ],
      platformBridgeLayer: 'Android Foreground Services & Sensors',
      platformBridgeDetails: [
        'High-priority Foreground Service with persistent low-power notification channel',
        'FusedLocationProvider shifting GPS polling frequency via accelerometer activity',
        'OEM battery optimization guard preventing OS process termination',
      ],
      architectureSpecs: {
        'State Model': 'MVVM + Reactive LiveData',
        'Storage': 'Room SQLite (SSOT)',
        'Background Sync': 'WorkManager + Exponential Backoff',
        'Location Telemetry': 'Adaptive FusedLocation Sensor Gated',
      },
    ),
  ),

  // 2. Ghareka PMT (Shyam Steel)
  const EnterpriseCaseStudy(
    title: 'Ghareka PMT (Civil Engineering Management)',
    company: 'Shyam Steel Industries Ltd.',
    roleAndPeriod: 'Principal Native Android Architect · 2025 – Present',
    platformSummary: 'Native Android · Jetpack Compose · MVI/MVVM',
    problemSolved:
        'Civil site supervisors operating in cellular dead zones at remote construction sites needed '
        'an infallible mobile tool to capture complex engineering inspection logs, safety audits, and photo evidence '
        'with zero risk of data loss upon disconnection.',
    businessImpact:
        '100% elimination of paper inspection logs, zero data loss reports across 500+ active enterprise project sites, '
        'and 25% faster site clearance turnaround.',
    techChips: [
      'Jetpack Compose',
      'Kotlin',
      'Clean Architecture',
      'Room DB',
      'WorkManager',
      'Coroutines / Flow',
      'Retrofit',
      'Material 3',
    ],
    screenshotUrl: 'assets/images/ghareka_pmt.jpeg',
    links: [
      ProjectLink(
        label: 'pmt.ghareka.com',
        url: 'https://pmt.ghareka.com',
        type: ProjectLinkType.web,
      ),
    ],
    accentColor: AppColors.electricCyan,
    blueprint: ArchitectureBlueprint(
      presentationLayer: '100% Declarative Jetpack Compose',
      presentationDetails: [
        'Single-Activity architecture driven entirely by Compose Navigation and Material 3',
        'Unidirectional data flow (UDF) powered by Kotlin StateFlow and MVI Reducer',
      ],
      domainLayer: 'Inspection & Milestone Business Logic',
      domainDetails: [
        'InspectionAuditUseCase validating mandatory civil engineering criteria',
        'MilestoneValidationPipeline orchestrating phase completion checks',
        'Asynchronous bitmap downsampling isolate maintaining 60 FPS UI responsiveness',
      ],
      dataLayer: 'Room SQLite SSOT & Jetpack WorkManager',
      dataDetails: [
        'Scoped atomic Room DB transactions ensuring zero half-written audits',
        'Multipart upload worker streaming compressed photo evidence to cloud storage',
        'Offline audit queue with conflict resolution and cryptographic checksums',
      ],
      platformBridgeLayer: 'CameraX & Hardware Storage Framework',
      platformBridgeDetails: [
        'CameraX direct hardware capture with auto-focus and flash metering',
        'Scoped Storage Access Framework for localized encrypted file persistence',
        'Network capabilities callback monitor triggering opportunistic sync',
      ],
      architectureSpecs: {
        'UI Engine': '100% Jetpack Compose (Declarative)',
        'Architecture': 'Single-Activity Clean MVI',
        'Local DB': 'Room SQLite with Atomic Transactions',
        'Evidence Engine': 'CameraX + Coroutines Bitmap Compression',
      },
    ),
  ),

  // 3. Ghareka Consumer App, Buildistan & Pariwar (Shyam Steel)
  const EnterpriseCaseStudy(
    title: 'Ghareka Ecosystem: Consumer, Buildistan & Pariwar',
    company: 'Shyam Steel Industries Ltd.',
    roleAndPeriod: 'Lead Flutter Developer · 2023 – Present',
    platformSummary: 'Cross-Platform Flutter · Dart · Clean Architecture',
    problemSolved:
        'Unified cross-platform ecosystem serving three mission-critical domains: consumer structural steel estimators '
        'calculating reinforcement bar matrices (Ghareka), dynamic multi-vendor B2B procurement marketplace with '
        'Easebuzz payment processing (Buildistan), and trade loyalty rewards with high-speed barcode/QR coupon scanning (Pariwar).',
    businessImpact:
        '100,000+ monthly QR scans with 0 replay fraud incidents, 4.5★ app store rating, 40% reduction in pre-sales inquiries, '
        'and processing over 1,500 daily bulk B2B material RFQs.',
    techChips: [
      'Flutter',
      'Dart',
      'Riverpod',
      'BLoC',
      'Clean Architecture',
      'Easebuzz Payment Gateway',
      'Google ML Kit',
      'HMAC-SHA256',
      'Method Channels',
    ],
    screenshotUrl: 'assets/images/ghareka.jpeg',
    links: [
      ProjectLink(
        label: 'Ghareka App',
        url: 'https://play.google.com/store/apps/details?id=com.ghreka.consumerapp',
        type: ProjectLinkType.playStore,
      ),
      ProjectLink(
        label: 'Buildistan B2B',
        url: 'https://play.google.com/store/apps/details?id=com.buildistan.b2b',
        type: ProjectLinkType.playStore,
      ),
      ProjectLink(
        label: 'Pariwar Loyalty',
        url: 'https://play.google.com/store/apps/details?id=com.shyamsteel.pariwar',
        type: ProjectLinkType.playStore,
      ),
    ],
    accentColor: AppColors.emerald,
    blueprint: ArchitectureBlueprint(
      presentationLayer: 'Flutter Material 3 + Riverpod & BLoC',
      presentationDetails: [
        'Consumer app: Riverpod state orchestration with reactive estimation form states',
        'Buildistan: Event-driven BLoC multi-vendor cart state machine with optimistic updates',
        'Pariwar: High-contrast stockyard scanner viewport with visual scan confirmation',
      ],
      domainLayer: 'Mathematical Estimators & Cryptographic Engine',
      domainDetails: [
        'StructuralSteelEstimator offloaded to Dart background Isolates (60 FPS sustained)',
        'MultiVendorCartSplitter computing tiered volume discounts and distinct supplier lead times',
        'HMAC-SHA256 CouponVerifier with local rolling nonce verification',
      ],
      dataLayer: 'Resilient Dio Interceptors & Local SQLite Ledgers',
      dataDetails: [
        'Dio network client with automatic JWT token refresh and exponential backoff retry',
        'SQLite local cart persistence preventing state drift during interrupted checkouts',
        'Encrypted SQLCipher transactional ledger for verified offline scan credits',
      ],
      platformBridgeLayer: 'Method Channels to Native Android / iOS',
      platformBridgeDetails: [
        'Bidirectional Method Channels bridging Google ML Kit Barcode hardware scanner',
        'Native CameraX autofocus & exposure compensation for glare-resistant outdoor scanning',
        'Easebuzz Payment Gateway native SDK bridge with cryptographic hash signature checks',
      ],
      architectureSpecs: {
        'Cross-Platform UI': 'Flutter 3.x + Dart',
        'State Management': 'Riverpod (Consumer/Pariwar) & BLoC (Buildistan)',
        'Native Bridges': 'Method Channels (ML Kit, Easebuzz)',
        'Security': 'HMAC-SHA256 Nonce Verification & SQLCipher',
      },
    ),
  ),

  // 4. Captain Logistics & Message Club (Nat IT Solved Pvt Ltd)
  const EnterpriseCaseStudy(
    title: 'Captain Logistics & Message Club Platform',
    company: 'Nat IT Solved Pvt. Ltd.',
    roleAndPeriod: 'Android Application Developer · 2017 – 2019',
    platformSummary: 'Native Android · Kotlin · Real-Time Telemetry',
    problemSolved:
        'Commercial fleet operators required sub-second vehicle telemetry, automated driver dispatch, '
        'and live route turn-by-turn routing concurrently with a high-throughput CRM broadcast messaging app '
        'capable of dispatching 10,000 burst notifications without thread starvation or UI jank.',
    businessImpact:
        'Achieved sub-200ms telemetry streaming latency, 30% decrease in fleet idle time, and '
        'dispatched 5M+ monthly notifications with 99.95% delivery receipt accuracy.',
    techChips: [
      'Native Android',
      'Kotlin',
      'MVVM',
      'LiveData',
      'WebSockets',
      'Google Maps SDK',
      'Foreground Services',
      'Room DB',
      'Retrofit',
      'FCM Batch Dispatch',
    ],
    screenshotUrl: 'assets/images/massageclub.jpg',
    links: [
      ProjectLink(
        label: 'Message Club Play Store',
        url: 'https://play.google.com/store/apps/details?id=com.massageclub&hl=en',
        type: ProjectLinkType.playStore,
      ),
    ],
    accentColor: AppColors.electricCyan,
    blueprint: ArchitectureBlueprint(
      presentationLayer: 'MVVM + LiveData & Custom Maps Overlays',
      presentationDetails: [
        'Hardware-accelerated Google Maps SDK overlay rendering hundreds of live vehicles',
        'Custom vehicle marker animations with bearing interpolation and route polylines',
        'High-density notification campaign preview and broadcast dispatch dashboard',
      ],
      domainLayer: 'Telemetry & Deduplication Engines',
      domainDetails: [
        'LiveTelemetryStreamHandler buffering continuous GPS breadcrumbs with Kalman filtering',
        'RoutePolylineSmoother optimizing path points before screen render',
        'MessageDeduplicationUseCase processing burst notification payloads up to 10,000 items',
      ],
      dataLayer: 'Room FIFO Queues & Batch HTTP Pipelines',
      dataDetails: [
        'Prioritized Room DB FIFO message queue maintaining sub-15ms local query responses',
        'Retrofit HTTP adaptive connection pooling for high-throughput batch dispatches',
        'Local SQLite breadcrumb store with auto-retransmit on connection restore',
      ],
      platformBridgeLayer: 'Continuous Telemetry Foreground Service & WebSockets',
      platformBridgeDetails: [
        'Dedicated Android Foreground Service gathering continuous GPS telemetry',
        'WebSocket client with automated ping-pong keepalive and reconnect daemon',
        'FCM high-priority push dispatch receiver with notification channel grouping',
      ],
      architectureSpecs: {
        'Streaming Protocol': 'WebSockets (Sub-200ms Latency)',
        'Mapping Engine': 'Google Maps SDK Hardware Overlays',
        'Queueing': 'Room DB Prioritized FIFO Buffer',
        'Throughput': '5M+ Monthly Broadcast Payloads',
      },
    ),
  ),

  // 5. Staffer (Matrix Media Solution) & Drlife (DCC Services)
  const EnterpriseCaseStudy(
    title: 'Staffer & DrLife Telemedicine Platform',
    company: 'Matrix Media Solution & DCC Services',
    roleAndPeriod: 'Android Engineer / Consultant · 2018 – 2020',
    platformSummary: 'Native Android · Kotlin · WebRTC C++ · SQLCipher',
    problemSolved:
        'Workforce shift scheduling app requiring two-way synchronization with native Android calendars and conflict resolution, '
        'paired with a telemedicine platform delivering ultra-low-latency encrypted video consultations and HIPAA-compliant patient medical records.',
    businessImpact:
        'Eliminated 80% of workforce shift disputes, automated reminders for 15,000+ frontline workers, '
        'conducted 20,000+ secure remote teleconsultations with a 99.4% connection rate, and passed 100% of HIPAA security audits.',
    techChips: [
      'Native Android',
      'Kotlin',
      'WebRTC C++',
      'SQLCipher AES-256',
      'Android CalendarProvider',
      'MVVM',
      'LiveData',
      'Clean Architecture',
      'Retrofit',
    ],
    screenshotUrl: null,
    links: [
      ProjectLink(
        label: 'GitHub Codebase',
        url: 'https://github.com/JayDutta7',
        type: ProjectLinkType.github,
      ),
    ],
    accentColor: Color(0xFFA855F7),
    blueprint: ArchitectureBlueprint(
      presentationLayer: 'Lifecycle-Safe MVVM & WebRTC Canvas',
      presentationDetails: [
        'WebRTC SurfaceViewRenderer custom video canvas with hardware scaling and aspect ratio fitting',
        'Interactive shift availability matrix and roster conflict alert dialogs',
      ],
      domainLayer: 'Roster Logic & WebRTC Signaling Protocols',
      domainDetails: [
        'ShiftConflictResolver analyzing overlapping shift requests across multiple time zones',
        'WebRTCSignalingChannel negotiating SDP offers/answers and ICE candidate trickle',
        'EncryptedPrescriptionManager validating digital signatures before cloud archival',
      ],
      dataLayer: 'SQLCipher 256-bit AES & Room Offline Cache',
      dataDetails: [
        'SQLCipher 256-bit AES encrypted SQLite database preventing plaintext patient data exposure',
        'Room DB offline roster store with two-way reconciliation against remote server',
        'Retrofit TLS 1.3 encrypted REST client with certificate pinning',
      ],
      platformBridgeLayer: 'Native C++ Codecs & Calendar ContentResolver',
      platformBridgeDetails: [
        'Native WebRTC C++ wrapper bindings utilizing hardware H.264/VP8 video codecs',
        'Android CalendarProvider ContentResolver API for bidirectional system calendar synchronization',
        'Dynamic video bitrate downsampling daemon adapting to fluctuating 3G/4G bandwidth',
      ],
      architectureSpecs: {
        'Video Telemetry': 'Peer-to-Peer WebRTC C++ Hardware Codecs',
        'Security Standard': '256-bit AES SQLCipher (HIPAA Certified)',
        'System Integration': 'Android CalendarProvider ContentResolver',
        'Architecture': 'Clean MVVM with Lifecycle Safety',
      },
    ),
  ),
];
