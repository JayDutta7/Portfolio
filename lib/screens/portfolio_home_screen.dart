import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/utils/launch_helper.dart';
import '../core/utils/resume_download/resume_download.dart';
import '../presentation/viewmodels/profile_viewmodel.dart';
import '../sections/bento_hero_section.dart';
import '../sections/career_timeline_section.dart';
import '../sections/projects_architecture_section.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_nav_bar.dart';
import '../widgets/hover_bento_card.dart';

/// Full Responsive Screen Assembling the Linear / Vercel Dark Bento Portfolio
///
/// Features:
/// - Deep Obsidian Canvas (`#07090E`) with dual subtle radial ambient gradients
/// - Floating Glassmorphic Command Header with section tabs & high-contrast CTA
/// - Above-the-Fold Asymmetric Bento Grid
/// - Interactive "Product vs. Architecture" Enterprise Case Study Cards
/// - Interactive Vertical Career Timeline with glowing nodes
/// - Engineering Systems Blueprint & Direct Contact Strip
/// - Cross-platform resume downloading & seamless scroll synchronization
class PortfolioHomeScreen extends ConsumerStatefulWidget {
  const PortfolioHomeScreen({super.key});

  @override
  ConsumerState<PortfolioHomeScreen> createState() => _PortfolioHomeScreenState();
}

class _PortfolioHomeScreenState extends ConsumerState<PortfolioHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _overviewKey = GlobalKey();
  final GlobalKey _architectureKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  String _activeSection = 'Overview';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;

    // Dynamically calculate section positions
    String currentSection = 'Overview';
    if (offset < 400) {
      currentSection = 'Overview';
    } else if (offset < 1200) {
      currentSection = 'Projects';
    } else if (offset < 2400) {
      currentSection = 'Architecture';
    } else if (offset < 3400) {
      currentSection = 'Experience';
    } else {
      currentSection = 'Contact';
    }

    if (currentSection != _activeSection) {
      setState(() => _activeSection = currentSection);
    }
  }

  void _scrollToKey(GlobalKey key, String sectionName) {
    setState(() => _activeSection = sectionName);
    final ctx = key.currentContext;
    if (ctx != null) {
      final box = ctx.findRenderObject() as RenderBox?;
      if (box != null && _scrollController.hasClients) {
        final targetOffset = box.localToGlobal(
          Offset.zero,
          ancestor: context.findRenderObject(),
        ).dy;
        final target = (_scrollController.offset + targetOffset - 90).clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        );

        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  void _handleNavTap(String tab) {
    switch (tab) {
      case 'Overview':
        _scrollToKey(_overviewKey, 'Overview');
        break;
      case 'Architecture':
        _scrollToKey(_architectureKey, 'Architecture');
        break;
      case 'Projects':
        _scrollToKey(_projectsKey, 'Projects');
        break;
      case 'Experience':
        _scrollToKey(_experienceKey, 'Experience');
        break;
      case 'Contact':
        _scrollToKey(_contactKey, 'Contact');
        break;
    }
  }

  void _downloadResumeAction() {
    final profile = ref.read(profileSyncProvider);
    downloadResume(profile.resumeAssetPath, profile.resumeDownloadFileName);
  }

  void _openContactModal() {
    final profile = ref.read(profileSyncProvider);
    showDialog(
      context: context,
      builder: (context) => _ContactDialog(profile: profile),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileSyncProvider);

    return Scaffold(
      backgroundColor: AppColors.canvasBackground,
      body: Stack(
        children: [
          // Ambient Radial Mesh Background Canvas
          const Positioned.fill(
            child: _AmbientObsidianCanvas(),
          ),

          // Primary Scroll View
          Positioned.fill(
            child: SelectionArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1240),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 96), // Clearance for sticky nav header

                          // Component 2: Above-the-Fold Bento Grid
                          Container(
                            key: _overviewKey,
                            child: BentoHeroSection(
                              profile: profile,
                              onExploreProjects: () => _scrollToKey(_projectsKey, 'Projects'),
                              onDownloadResume: _downloadResumeAction,
                            ),
                          ),
                          const SizedBox(height: 80),

                          // Component 3: Enterprise Case Study Cards (Overview & Architecture Modes)
                          Container(
                            key: _projectsKey,
                            child: ProjectsArchitectureSection(
                              sectionKey: _architectureKey,
                            ),
                          ),
                          const SizedBox(height: 80),

                          // Component 4: Interactive Career Timeline
                          CareerTimelineSection(
                            sectionKey: _experienceKey,
                          ),
                          const SizedBox(height: 80),

                          // Component 5: Direct Contact & Blueprint Spec Card
                          Container(
                            key: _contactKey,
                            child: _ContactAndSpecStrip(
                              profile: profile,
                              onDownloadCv: _downloadResumeAction,
                              onScheduleCall: _openContactModal,
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Minimalist Glassmorphic Footer
                          const _LinearBentoFooter(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Component 1: Floating Glassmorphic Sticky Command Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FloatingNavBar(
              activeSection: _activeSection,
              onSectionTap: _handleNavTap,
              onLogoTap: () => _scrollToKey(_overviewKey, 'Overview'),
              onCtaTap: _openContactModal,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ambient Canvas Background
// Subtle radial ambient gradients: #0EA5E9 at 6% in top-left, #10B981 at 5% in bottom-right
// ---------------------------------------------------------------------------
class _AmbientObsidianCanvas extends StatelessWidget {
  const _AmbientObsidianCanvas();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          // Base Deep Obsidian (#07090E)
          Container(color: AppColors.canvasBackground),

          // Top-Left Cyan Radial Glow (#0EA5E9 @ 6% opacity)
          Positioned(
            top: -120,
            left: -120,
            width: 720,
            height: 720,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0EA5E9).withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Bottom-Right Emerald Radial Glow (#10B981 @ 5% opacity)
          Positioned(
            bottom: -150,
            right: -150,
            width: 800,
            height: 800,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF10B981).withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Ambient subtle grid dots overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _SubtleGridPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubtleGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.18)
      ..strokeWidth = 1.0;

    const step = 48.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Direct Contact & Architecture Spec Strip
// ---------------------------------------------------------------------------
class _ContactAndSpecStrip extends StatelessWidget {
  final dynamic profile;
  final VoidCallback onDownloadCv;
  final VoidCallback onScheduleCall;

  const _ContactAndSpecStrip({
    required this.profile,
    required this.onDownloadCv,
    required this.onScheduleCall,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 720;

    return HoverBentoCard(
      accentGlowColor: AppColors.electricCyan,
      padding: EdgeInsets.all(isMobile ? 24 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.emerald,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'LET’S BUILD SOMETHING RESILIENT',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.electricCyan,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Ready to Elevate Your Mobile Architecture & Engineering Squad?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 24 : 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Currently open to Mobile Architect, Principal Android/Flutter Engineer, '
            'and Engineering Leadership opportunities. Let’s connect on system design, '
            'native performance bottlenecks, or building zero-drift offline applications.',
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Contact Details Grid
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _ContactActionCard(
                icon: Icons.email_outlined,
                label: 'Direct Email',
                value: profile.email,
                accentColor: AppColors.electricCyan,
                onTap: () => LaunchHelper.sendEmail(profile.email),
              ),
              _ContactActionCard(
                icon: Icons.phone_outlined,
                label: 'Phone / WhatsApp',
                value: profile.phone,
                accentColor: AppColors.emerald,
                onTap: () => LaunchHelper.makeCall(profile.phone),
              ),
              _ContactActionCard(
                icon: Icons.business_center_outlined,
                label: 'LinkedIn Profile',
                value: 'jayajit-dutta-7124b9125',
                accentColor: const Color(0xFFA855F7),
                onTap: () => LaunchHelper.openUrl(profile.linkedInUrl),
              ),
              _ContactActionCard(
                icon: Icons.code_rounded,
                label: 'GitHub Repositories',
                value: 'github.com/JayDutta7',
                accentColor: AppColors.amber,
                onTap: () => LaunchHelper.openUrl(profile.githubUrl),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Action row
          Wrap(
            spacing: 14,
            runSpacing: 12,
            children: [
              _PrimaryGradientButton(
                label: 'Schedule a Call / Send Message',
                icon: Icons.chat_bubble_outline_rounded,
                onTap: onScheduleCall,
              ),
              _SecondaryGlassButton(
                label: 'Download Complete CV (PDF)',
                icon: Icons.download_rounded,
                onTap: onDownloadCv,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;
  final VoidCallback onTap;

  const _ContactActionCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_ContactActionCard> createState() => _ContactActionCardState();
}

class _ContactActionCardState extends State<_ContactActionCard> {
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
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.12)
                : AppColors.cardSurfaceSolid,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.5)
                  : AppColors.cardBorder,
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
                  size: 18,
                  color: widget.accentColor,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryGradientButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryGradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_PrimaryGradientButton> createState() => _PrimaryGradientButtonState();
}

class _PrimaryGradientButtonState extends State<_PrimaryGradientButton> {
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
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: _isHovered
                  ? [const Color(0xFF0EA5E9), const Color(0xFF10B981)]
                  : [AppColors.electricCyan, AppColors.emerald],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.electricCyan.withValues(alpha: _isHovered ? 0.45 : 0.22),
                blurRadius: _isHovered ? 18 : 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 16, color: const Color(0xFF07090E)),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF07090E),
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
  final VoidCallback onTap;

  const _SecondaryGlassButton({
    required this.label,
    required this.icon,
    required this.onTap,
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
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.cardSurfaceSolid,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? AppColors.electricCyan : AppColors.cardBorder,
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

// ---------------------------------------------------------------------------
// Linear Bento Footer
// ---------------------------------------------------------------------------
class _LinearBentoFooter extends StatelessWidget {
  const _LinearBentoFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: [
          Row(
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
              Flexible(
                child: Text(
                  'JAYAJIT DUTTA // MOBILE ARCHITECT',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Linear / Vercel Dark Bento · Flutter Web',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Interactive Contact Modal Sheet / Dialog
// ---------------------------------------------------------------------------
class _ContactDialog extends StatelessWidget {
  final dynamic profile;
  const _ContactDialog({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.cardSurfaceSolid,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.electricCyan.withValues(alpha: 0.4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.electricCyan.withValues(alpha: 0.2),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Direct Contact & Schedule',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Connect directly with Jayajit Dutta for enterprise mobile architecture, consulting, or leadership inquiries.',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _DialogContactTile(
                icon: Icons.email_rounded,
                title: 'Email',
                value: profile.email,
                onTap: () {
                  Navigator.of(context).pop();
                  LaunchHelper.sendEmail(profile.email);
                },
              ),
              const SizedBox(height: 12),
              _DialogContactTile(
                icon: Icons.phone_rounded,
                title: 'Phone / WhatsApp',
                value: profile.phone,
                onTap: () {
                  Navigator.of(context).pop();
                  LaunchHelper.makeCall(profile.phone);
                },
              ),
              const SizedBox(height: 12),
              _DialogContactTile(
                icon: Icons.business_center_rounded,
                title: 'LinkedIn',
                value: 'jayajit-dutta-7124b9125',
                onTap: () {
                  Navigator.of(context).pop();
                  LaunchHelper.openUrl(profile.linkedInUrl);
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close Window',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
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

class _DialogContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _DialogContactTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardSurfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.electricCyan),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
