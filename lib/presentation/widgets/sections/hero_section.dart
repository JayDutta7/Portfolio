import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/resume_download/resume_download.dart';
import '../../../domain/models/profile_models.dart';
import '../../viewmodels/locale_viewmodel.dart';
import '../common/gradient_text.dart';
import '../common/section_wrapper.dart';

class HeroSection extends ConsumerWidget {
  final Profile profile;
  final VoidCallback onViewWork;
  final GlobalKey? sectionKey;
  final ScrollController? scrollController;
  final GlobalKey? projectsKey;
  final VoidCallback? onViewCaseStudies;

  const HeroSection({
    required this.profile,
    required this.onViewWork,
    this.sectionKey,
    this.scrollController,
    this.projectsKey,
    this.onViewCaseStudies,
    super.key,
  });

  void _scrollToCaseStudies(BuildContext context) {
    if (onViewCaseStudies != null) {
      onViewCaseStudies!();
      return;
    }
    if (scrollController != null && scrollController!.hasClients) {
      if (projectsKey?.currentContext != null) {
        final renderBox = projectsKey!.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final scrollable = Scrollable.of(projectsKey!.currentContext!);
          final position = scrollable.position;
          final offset = renderBox.localToGlobal(Offset.zero, ancestor: scrollable.context.findRenderObject()).dy;
          final target = (position.pixels + offset - 85).clamp(0.0, position.maxScrollExtent);
          scrollController!.animateTo(
            target,
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeInOutCubic,
          );
          return;
        }
      }
    }
    onViewWork();
  }

  Future<void> _handleDownloadResume(BuildContext context) async {
    try {
      await downloadResume(profile.resumeAssetPath, profile.resumeDownloadFileName);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not download resume: $e')),
        );
      }
    }
  }

  Widget _buildSubtitle(
    BuildContext context, {
    required bool isDesktop,
    required bool isMobile,
    required bool isTablet,
    required bool isDark,
  }) {
    final baseStyle = GoogleFonts.inter(
      fontSize: isMobile ? 15.0 : (isTablet ? 16.5 : 18.0),
      height: 1.65,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
    );

    InlineSpan techSpan(String text) {
      return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 6 : 8,
            vertical: isMobile ? 2 : 3,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF38BDF8).withValues(alpha: 0.14)
                : const Color(0xFF6366F1).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.45)
                  : const Color(0xFF6366F1).withValues(alpha: 0.30),
              width: 1,
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.jetBrainsMono(
              fontSize: isMobile ? 12.0 : (isTablet ? 13.5 : 14.5),
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF4338CA),
            ),
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isDesktop ? 640 : 700),
      child: Text.rich(
        TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(text: 'Architecting high-performance, scalable native '),
            techSpan('Android'),
            const TextSpan(text: ' ('),
            techSpan('Kotlin'),
            const TextSpan(text: ', '),
            techSpan('Jetpack Compose'),
            const TextSpan(text: ') and cross-platform ('),
            techSpan('Flutter'),
            const TextSpan(text: ') mobile applications with '),
            techSpan('Clean Architecture'),
            const TextSpan(text: ' & '),
            techSpan('Modular Systems'),
            const TextSpan(text: '.'),
          ],
        ),
        textAlign: isDesktop ? TextAlign.left : TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentLanguage = ref.watch(localeProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        final isTablet = width >= 600 && width <= 1024;
        final isDesktop = width > 1024;

        final headlineFontSize = isDesktop
            ? 70.0
            : (isTablet
                ? 48.0
                : (width < 380 ? 30.0 : 36.0));
        final headlineLetterSpacing = isDesktop ? -2.4 : (isTablet ? -1.5 : -0.9);

        final buttonWidth = isDesktop
            ? 240.0
            : (isTablet
                ? 224.0
                : (width < 500 ? (width - 48).clamp(200.0, 270.0) : 220.0));
        final buttonHeight = isMobile ? 50.0 : 54.0;

        final textContent = Column(
          crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Text(
              currentLanguage.heroGreeting,
              style: GoogleFonts.plusJakartaSans(
                fontSize: isDesktop ? 26.0 : (isTablet ? 22.0 : 18.0),
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(height: isMobile ? 4 : 6),
            GradientText(
              profile.name,
              colors: isDark
                  ? AppColors.heroTitleGradient
                  : AppColors.heroTitleGradientLight,
              textAlign: isDesktop ? TextAlign.left : TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: headlineFontSize,
                fontWeight: FontWeight.w900,
                height: 1.22,
                letterSpacing: headlineLetterSpacing,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            _CyclingAnimatedTitle(
              titles: currentLanguage.animatedRoles,
              isDesktop: isDesktop,
              isDark: isDark,
            ),
            SizedBox(height: isMobile ? 16 : 24),
            _buildSubtitle(
              context,
              isDesktop: isDesktop,
              isMobile: isMobile,
              isTablet: isTablet,
              isDark: isDark,
            ),
            SizedBox(height: isMobile ? 24 : 36),
            Wrap(
              spacing: 16,
              runSpacing: 14,
              alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _CaseStudiesCTAButton(
                  label: 'View Case Studies',
                  icon: Icons.explore_rounded,
                  onPressed: () => _scrollToCaseStudies(context),
                  width: buttonWidth,
                  height: buttonHeight,
                ),
                _ResumeCTAButton(
                  label: 'Download Resume (PDF)',
                  icon: Icons.description_rounded,
                  onPressed: () => _handleDownloadResume(context),
                  width: buttonWidth,
                  height: buttonHeight,
                ),
              ],
            ),
            SizedBox(height: isMobile ? 24 : 36),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
              children: [
                _SocialPill(
                  icon: Icons.code_rounded,
                  label: 'GitHub',
                  onTap: () => LaunchHelper.openUrl(profile.githubUrl),
                ),
                _SocialPill(
                  icon: Icons.work_rounded,
                  label: 'LinkedIn',
                  onTap: () => LaunchHelper.openUrl(profile.linkedInUrl),
                ),
                _SocialPill(
                  icon: Icons.email_rounded,
                  label: 'Email',
                  onTap: () => LaunchHelper.sendEmail(profile.email),
                ),
              ],
            ),
          ],
        );

        final avatarShowcase = Center(
          child: _HeroOrbitAvatarShowcase(profile: profile),
        );

        return SizedBox(
          key: sectionKey,
          width: double.infinity,
          child: SectionWrapper(
            verticalPadding: isDesktop ? 96 : (isTablet ? 48 : 24),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: textContent,
                      ),
                      const SizedBox(width: 48),
                      Expanded(
                        flex: 5,
                        child: avatarShowcase,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      avatarShowcase,
                      SizedBox(height: isTablet ? 32 : 20),
                      textContent,
                    ],
                  ),
          ),
        );
      },
    );
  }
}

enum _TechBadgeType {
  flutter,
  kotlin,
  android,
  git,
  ios,
  playStore,
  firebase,
  appStore,
}

class _TechBadgeData {
  final String name;
  final Color color;
  final Color glowColor;
  final _TechBadgeType type;

  const _TechBadgeData({
    required this.name,
    required this.color,
    required this.glowColor,
    required this.type,
  });
}

class _HeroOrbitAvatarShowcase extends StatefulWidget {
  final Profile profile;
  const _HeroOrbitAvatarShowcase({required this.profile});

  @override
  State<_HeroOrbitAvatarShowcase> createState() => _HeroOrbitAvatarShowcaseState();
}

class _HeroOrbitAvatarShowcaseState extends State<_HeroOrbitAvatarShowcase>
    with TickerProviderStateMixin {
  late final AnimationController _orbitController;
  late final AnimationController _pulseController;
  late final AnimationController _bounceController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _bounceAnimation;
  late final Animation<double> _ringScaleAnimation;
  late final Animation<double> _outerRippleAnimation;
  int? _hoveredBadgeIndex;

  static const List<_TechBadgeData> _badges = [
    _TechBadgeData(
      name: 'Flutter',
      color: Color(0xFF38BDF8),
      glowColor: Color(0xFF0284C7),
      type: _TechBadgeType.flutter,
    ),
    _TechBadgeData(
      name: 'Kotlin',
      color: Color(0xFF818CF8),
      glowColor: Color(0xFFC084FC),
      type: _TechBadgeType.kotlin,
    ),
    _TechBadgeData(
      name: 'Android',
      color: Color(0xFF34D399),
      glowColor: Color(0xFF10B981),
      type: _TechBadgeType.android,
    ),
    _TechBadgeData(
      name: 'Git',
      color: Color(0xFFFB923C),
      glowColor: Color(0xFFEA580C),
      type: _TechBadgeType.git,
    ),
    _TechBadgeData(
      name: 'iOS',
      color: Color(0xFF64748B),
      glowColor: Color(0xFF475569),
      type: _TechBadgeType.ios,
    ),
    _TechBadgeData(
      name: 'Play Store',
      color: Color(0xFF34D399),
      glowColor: Color(0xFF059669),
      type: _TechBadgeType.playStore,
    ),
    _TechBadgeData(
      name: 'Firebase',
      color: Color(0xFFFBBF24),
      glowColor: Color(0xFFD97706),
      type: _TechBadgeType.firebase,
    ),
    _TechBadgeData(
      name: 'App Store',
      color: Color(0xFF38BDF8),
      glowColor: Color(0xFF2563EB),
      type: _TechBadgeType.appStore,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.10).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _ringScaleAnimation = Tween<double>(begin: 0.98, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutCubic),
    );

    _outerRippleAnimation = Tween<double>(begin: 1.04, end: 1.34).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOutQuad),
    );

    _bounceAnimation = Tween<double>(begin: -9.0, end: 9.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    final double canvasSize = isMobile ? 320.0 : 420.0;
    final double centerCoord = canvasSize / 2;
    final double orbitRadius = isMobile ? 120.0 : 162.0;
    final double avatarSize = isMobile ? 164.0 : 228.0;
    final double badgeSize = isMobile ? 36.0 : 46.0;
    final double iconSize = isMobile ? 20.0 : 26.0;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: canvasSize,
        height: canvasSize,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // 1. Orbital track & radar ring background with dynamic rotation & pulsing
            AnimatedBuilder(
              animation: Listenable.merge([_orbitController, _pulseController]),
              builder: (context, child) {
                return CustomPaint(
                  size: Size(canvasSize, canvasSize),
                  painter: _OrbitTrackPainter(
                    orbitRadius: orbitRadius,
                    isDark: isDark,
                    rotationAngle: _orbitController.value * 2 * math.pi,
                    pulseValue: _pulseAnimation.value,
                  ),
                );
              },
            ),

            // 2. Multi-layered Pulsing, Expanding & Bouncing Circles
            AnimatedBuilder(
              animation: Listenable.merge([_pulseController, _bounceController, _orbitController]),
              builder: (context, child) {
                final bounceY = _bounceAnimation.value;
                final pulse = _pulseAnimation.value;
                final ripple = _outerRippleAnimation.value;
                final ringScale = _ringScaleAnimation.value;

                return Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Layer A: Outermost radar sonar ripple wave (expanding, bouncing & fading)
                    Transform.translate(
                      offset: Offset(0, bounceY * 0.3),
                      child: Transform.scale(
                        scale: ripple,
                        child: Container(
                          width: avatarSize + (isMobile ? 56 : 76),
                          height: avatarSize + (isMobile ? 56 : 76),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF06B6D4).withValues(
                                alpha: isDark
                                    ? (0.28 * (1.35 - ripple).clamp(0.0, 1.0))
                                    : (0.16 * (1.35 - ripple).clamp(0.0, 1.0)),
                              ),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Layer B: Mid-level cosmic halo ring with gradient border (bounces gently)
                    Transform.translate(
                      offset: Offset(0, bounceY * 0.5),
                      child: Transform.scale(
                        scale: ringScale,
                        child: Container(
                          width: avatarSize + (isMobile ? 36 : 52),
                          height: avatarSize + (isMobile ? 36 : 52),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFA855F7).withValues(
                                alpha: isDark ? 0.35 : 0.22,
                              ),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFA855F7).withValues(
                                  alpha: isDark ? 0.20 : 0.10,
                                ),
                                blurRadius: 20,
                                spreadRadius: -2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Layer C: Core radiant aura glow (vibrant neon bounce & scale)
                    Transform.translate(
                      offset: Offset(0, bounceY * 0.75),
                      child: Transform.scale(
                        scale: pulse,
                        child: Container(
                          width: avatarSize + (isMobile ? 24 : 36),
                          height: avatarSize + (isMobile ? 24 : 36),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFFA855F7).withValues(alpha: isDark ? 0.40 : 0.24),
                                const Color(0xFF6366F1).withValues(alpha: isDark ? 0.30 : 0.16),
                                const Color(0xFF06B6D4).withValues(alpha: isDark ? 0.18 : 0.08),
                                Colors.transparent,
                              ],
                              stops: const [0.25, 0.55, 0.82, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Layer D: Small orbital satellite orbs that float & bounce around the perimeter
                    Transform.translate(
                      offset: Offset(
                        math.cos(_orbitController.value * 2 * math.pi + 1.2) * (avatarSize * 0.56),
                        math.sin(_orbitController.value * 2 * math.pi + 1.2) * (avatarSize * 0.56) + (bounceY * 0.6),
                      ),
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF38BDF8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.8),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(
                        math.cos(-_orbitController.value * 2 * math.pi * 1.3) * (avatarSize * 0.54),
                        math.sin(-_orbitController.value * 2 * math.pi * 1.3) * (avatarSize * 0.54) + (bounceY * 0.5),
                      ),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFA855F7),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFA855F7).withValues(alpha: 0.8),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // 3. Circular Avatar with rotating neon multi-gradient border and rhythmic vertical bounce
            AnimatedBuilder(
              animation: Listenable.merge([_bounceController, _orbitController, _pulseController]),
              builder: (context, child) {
                final bounceY = _bounceAnimation.value;
                final rotAngle = _orbitController.value * 2 * math.pi;
                final pulse = _pulseAnimation.value;

                return Transform.translate(
                  offset: Offset(0, bounceY),
                  child: GestureDetector(
                    onTap: () {
                      if (_orbitController.isAnimating) {
                        _orbitController.stop();
                      } else {
                        _orbitController.repeat();
                      }
                    },
                    child: Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          transform: GradientRotation(rotAngle),
                          colors: const [
                            Color(0xFF8B5CF6),
                            Color(0xFF06B6D4),
                            Color(0xFFEC4899),
                            Color(0xFF3B82F6),
                            Color(0xFF8B5CF6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.45 * pulse),
                            blurRadius: (isMobile ? 24 : 36) * pulse,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: const Color(0xFF06B6D4).withValues(alpha: 0.28 * pulse),
                            blurRadius: (isMobile ? 16 : 26) * pulse,
                            spreadRadius: -3,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(3.5),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? const Color(0xFF0A0D14) : Colors.white,
                          border: Border.all(
                            color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.8),
                            width: 2.0,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            widget.profile.profilePicture,
                            fit: BoxFit.cover,
                            width: avatarSize,
                            height: avatarSize,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                              child: Center(
                                child: Icon(
                                  Icons.person_rounded,
                                  size: isMobile ? 64 : 90,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // 4. The 8 Orbiting Tech Badges with Harmonic Radial Bounce
            AnimatedBuilder(
              animation: Listenable.merge([_orbitController, _bounceController]),
              builder: (context, child) {
                final baseAngle = _orbitController.value * 2 * math.pi;
                final bounceY = _bounceAnimation.value;

                return Stack(
                  children: List.generate(_badges.length, (index) {
                    final badge = _badges[index];
                    final angle = baseAngle + index * (2 * math.pi / _badges.length);
                    // Organic radial oscillation so the orbit breathes and bounces
                    final radialOscillation = math.sin((angle * 2.5) + (_bounceController.value * math.pi)) * 4.5;
                    final currentRadius = orbitRadius + radialOscillation;
                    final x = centerCoord + currentRadius * math.cos(angle);
                    final y = centerCoord + currentRadius * math.sin(angle) + (bounceY * 0.35);
                    final isHovered = _hoveredBadgeIndex == index;

                    return Positioned(
                      left: x - badgeSize / 2,
                      top: y - badgeSize / 2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _hoveredBadgeIndex = (_hoveredBadgeIndex == index) ? null : index;
                          });
                        },
                        child: MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              _hoveredBadgeIndex = index;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              if (_hoveredBadgeIndex == index) {
                                _hoveredBadgeIndex = null;
                              }
                            });
                          },
                          cursor: SystemMouseCursors.click,
                          child: Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message: badge.name,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: badge.color.withValues(alpha: 0.6),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: badge.glowColor.withValues(alpha: 0.4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 180),
                              scale: isHovered ? 1.28 : 1.0,
                              child: Container(
                                width: badgeSize,
                                height: badgeSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark
                                      ? const Color(0xFF0B0F19)
                                      : const Color(0xFFFFFFFF),
                                  border: Border.all(
                                    color: isHovered
                                        ? badge.color
                                        : badge.color.withValues(alpha: 0.55),
                                    width: isHovered ? 2.2 : 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: badge.glowColor.withValues(alpha: isHovered ? 0.65 : 0.35),
                                      blurRadius: isHovered ? 18 : 10,
                                      spreadRadius: isHovered ? 2 : 0.5,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: iconSize,
                                    height: iconSize,
                                    child: CustomPaint(
                                      painter: _TechLogoPainter(
                                        type: badge.type,
                                        color: badge.color,
                                        isDark: isDark,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbitTrackPainter extends CustomPainter {
  final double orbitRadius;
  final bool isDark;
  final double rotationAngle;
  final double pulseValue;

  const _OrbitTrackPainter({
    required this.orbitRadius,
    required this.isDark,
    this.rotationAngle = 0.0,
    this.pulseValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Soft glowing outer orbit baseline
    final glowPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: isDark ? (0.12 * pulseValue) : 0.07)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, orbitRadius, glowPaint);

    // 2. Dynamic rotating dashed orbit ring (spins counter-clockwise for parallax)
    final dashPaint = Paint()
      ..color = (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
          .withValues(alpha: isDark ? (0.35 * pulseValue) : 0.25)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    const totalDashes = 48;
    const dashAngle = (2 * math.pi) / totalDashes;
    const dashDrawAngle = dashAngle * 0.55;
    final startOffset = -rotationAngle * 0.5;

    for (int i = 0; i < totalDashes; i++) {
      final startAngle = startOffset + i * dashAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: orbitRadius),
        startAngle,
        dashDrawAngle,
        false,
        dashPaint,
      );
    }

    // 3. Inner pulsing violet orbit ring
    final innerPaint = Paint()
      ..color = (isDark ? const Color(0xFFA855F7) : const Color(0xFF7C3AED))
          .withValues(alpha: isDark ? (0.16 * pulseValue) : 0.09)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, orbitRadius - 28, innerPaint);

    // 4. Subtle radar crosshair ticks (top, bottom, left, right)
    final tickPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.18 : 0.12)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const tickLength = 5.0;
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) + (rotationAngle * 0.2);
      final p1 = Offset(
        center.dx + (orbitRadius - tickLength) * math.cos(angle),
        center.dy + (orbitRadius - tickLength) * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + (orbitRadius + tickLength) * math.cos(angle),
        center.dy + (orbitRadius + tickLength) * math.sin(angle),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitTrackPainter oldDelegate) =>
      oldDelegate.orbitRadius != orbitRadius ||
      oldDelegate.isDark != isDark ||
      oldDelegate.rotationAngle != rotationAngle ||
      oldDelegate.pulseValue != pulseValue;
}

class _TechLogoPainter extends CustomPainter {
  final _TechBadgeType type;
  final Color color;
  final bool isDark;

  const _TechLogoPainter({
    required this.type,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    switch (type) {
      case _TechBadgeType.flutter:
        final paintLight = Paint()..color = const Color(0xFF54C5F8)..style = PaintingStyle.fill;
        final paintMed = Paint()..color = const Color(0xFF29B6F6)..style = PaintingStyle.fill;
        final paintDark = Paint()..color = const Color(0xFF01579B)..style = PaintingStyle.fill;

        final pathTop = Path()
          ..moveTo(w * 0.20, h * 0.15)
          ..lineTo(w * 0.85, h * 0.80)
          ..lineTo(w * 0.62, h * 0.80)
          ..lineTo(w * 0.05, h * 0.23)
          ..close();
        canvas.drawPath(pathTop, paintLight);

        final pathMid = Path()
          ..moveTo(w * 0.38, h * 0.65)
          ..lineTo(w * 0.52, h * 0.79)
          ..lineTo(w * 0.38, h * 0.93)
          ..lineTo(w * 0.24, h * 0.79)
          ..close();
        canvas.drawPath(pathMid, paintMed);

        final pathBottom = Path()
          ..moveTo(w * 0.52, h * 0.79)
          ..lineTo(w * 0.85, h * 0.79)
          ..lineTo(w * 0.71, h * 0.93)
          ..lineTo(w * 0.38, h * 0.93)
          ..close();
        canvas.drawPath(pathBottom, paintDark);
        break;

      case _TechBadgeType.kotlin:
        final rect = Rect.fromLTWH(w * 0.18, h * 0.18, w * 0.64, h * 0.64);
        final grad = const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF7F52FF), Color(0xFFC711E1), Color(0xFFE4485D)],
        ).createShader(rect);
        final pGrad = Paint()..shader = grad..style = PaintingStyle.fill;

        final pathUpper = Path()
          ..moveTo(w * 0.18, h * 0.18)
          ..lineTo(w * 0.82, h * 0.18)
          ..lineTo(w * 0.18, h * 0.82)
          ..close();
        canvas.drawPath(pathUpper, pGrad);

        final pathLower = Path()
          ..moveTo(w * 0.82, h * 0.82)
          ..lineTo(w * 0.35, h * 0.82)
          ..lineTo(w * 0.82, h * 0.35)
          ..close();
        canvas.drawPath(pathLower, pGrad);
        break;

      case _TechBadgeType.android:
        final pGreen = Paint()..color = const Color(0xFF3DDC84)..style = PaintingStyle.fill;
        final pWhite = Paint()..color = Colors.white..style = PaintingStyle.fill;
        final pAntenna = Paint()
          ..color = const Color(0xFF3DDC84)
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

        canvas.drawLine(Offset(w * 0.38, h * 0.34), Offset(w * 0.28, h * 0.20), pAntenna);
        canvas.drawLine(Offset(w * 0.62, h * 0.34), Offset(w * 0.72, h * 0.20), pAntenna);

        final head = Path()
          ..arcTo(Rect.fromLTWH(w * 0.22, h * 0.32, w * 0.56, h * 0.56), math.pi, math.pi, true)
          ..close();
        canvas.drawPath(head, pGreen);

        canvas.drawCircle(Offset(w * 0.38, h * 0.48), 1.8, pWhite);
        canvas.drawCircle(Offset(w * 0.62, h * 0.48), 1.8, pWhite);
        break;

      case _TechBadgeType.git:
        final pGit = Paint()..color = const Color(0xFFF05032)..style = PaintingStyle.fill;
        final pStem = Paint()
          ..color = Colors.white
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
        final pNode = Paint()..color = Colors.white..style = PaintingStyle.fill;

        final diamond = Path()
          ..moveTo(w * 0.5, h * 0.12)
          ..lineTo(w * 0.88, h * 0.5)
          ..lineTo(w * 0.5, h * 0.88)
          ..lineTo(w * 0.12, h * 0.5)
          ..close();
        canvas.drawPath(diamond, pGit);

        canvas.drawLine(Offset(w * 0.42, h * 0.32), Offset(w * 0.42, h * 0.68), pStem);
        final branch = Path()
          ..moveTo(w * 0.42, h * 0.54)
          ..quadraticBezierTo(w * 0.58, h * 0.54, w * 0.62, h * 0.42);
        canvas.drawPath(branch, pStem);

        canvas.drawCircle(Offset(w * 0.42, h * 0.34), 2.2, pNode);
        canvas.drawCircle(Offset(w * 0.42, h * 0.66), 2.2, pNode);
        canvas.drawCircle(Offset(w * 0.62, h * 0.42), 2.2, pNode);
        break;

      case _TechBadgeType.ios:
        // Use dark slate in light mode for visibility, white in dark mode
        final appleColor = isDark ? Colors.white : const Color(0xFF0F172A);
        final biteColor = isDark ? const Color(0xFF0C101A) : Colors.white;
        final pApple = Paint()..color = appleColor..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(w * 0.44, h * 0.56), w * 0.21, pApple);
        canvas.drawCircle(Offset(w * 0.56, h * 0.56), w * 0.21, pApple);

        final leaf = Path()
          ..moveTo(w * 0.50, h * 0.26)
          ..quadraticBezierTo(w * 0.64, h * 0.24, w * 0.64, h * 0.35)
          ..quadraticBezierTo(w * 0.50, h * 0.37, w * 0.50, h * 0.26)
          ..close();
        canvas.drawPath(leaf, pApple);

        final pBite = Paint()..color = biteColor..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(w * 0.72, h * 0.52), w * 0.09, pBite);
        break;

      case _TechBadgeType.playStore:
        final pBlue = Paint()..color = const Color(0xFF00C3FF)..style = PaintingStyle.fill;
        final pGreen = Paint()..color = const Color(0xFF00E676)..style = PaintingStyle.fill;
        final pAmber = Paint()..color = const Color(0xFFFFD400)..style = PaintingStyle.fill;
        final pRed = Paint()..color = const Color(0xFFFF3A44)..style = PaintingStyle.fill;

        final pathRed = Path()
          ..moveTo(w * 0.22, h * 0.18)
          ..lineTo(w * 0.60, h * 0.50)
          ..lineTo(w * 0.22, h * 0.82)
          ..close();
        canvas.drawPath(pathRed, pRed);

        final pathBlue = Path()
          ..moveTo(w * 0.22, h * 0.18)
          ..lineTo(w * 0.78, h * 0.50)
          ..lineTo(w * 0.60, h * 0.50)
          ..close();
        canvas.drawPath(pathBlue, pBlue);

        final pathGreen = Path()
          ..moveTo(w * 0.22, h * 0.82)
          ..lineTo(w * 0.60, h * 0.50)
          ..lineTo(w * 0.78, h * 0.50)
          ..close();
        canvas.drawPath(pathGreen, pGreen);

        final pathAmber = Path()
          ..moveTo(w * 0.60, h * 0.50)
          ..lineTo(w * 0.78, h * 0.50)
          ..lineTo(w * 0.70, h * 0.58)
          ..close();
        canvas.drawPath(pathAmber, pAmber);
        break;

      case _TechBadgeType.firebase:
        final p1 = Paint()..color = const Color(0xFFFFCA28)..style = PaintingStyle.fill;
        final p2 = Paint()..color = const Color(0xFFFFA000)..style = PaintingStyle.fill;
        final p3 = Paint()..color = const Color(0xFFF57C00)..style = PaintingStyle.fill;

        final path1 = Path()
          ..moveTo(w * 0.48, h * 0.12)
          ..lineTo(w * 0.16, h * 0.70)
          ..lineTo(w * 0.50, h * 0.88)
          ..close();
        canvas.drawPath(path1, p1);

        final path2 = Path()
          ..moveTo(w * 0.74, h * 0.35)
          ..lineTo(w * 0.50, h * 0.88)
          ..lineTo(w * 0.84, h * 0.72)
          ..close();
        canvas.drawPath(path2, p2);

        final path3 = Path()
          ..moveTo(w * 0.36, h * 0.40)
          ..lineTo(w * 0.50, h * 0.88)
          ..lineTo(w * 0.62, h * 0.62)
          ..close();
        canvas.drawPath(path3, p3);
        break;

      case _TechBadgeType.appStore:
        final pBg = Paint()..color = const Color(0xFF0D96F6)..style = PaintingStyle.fill;
        final pSticks = Paint()
          ..color = Colors.white
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.15, h * 0.15, w * 0.70, h * 0.70),
            const Radius.circular(5),
          ),
          pBg,
        );
        canvas.drawLine(Offset(w * 0.32, h * 0.75), Offset(w * 0.50, h * 0.28), pSticks);
        canvas.drawLine(Offset(w * 0.68, h * 0.75), Offset(w * 0.50, h * 0.28), pSticks);
        canvas.drawLine(Offset(w * 0.26, h * 0.62), Offset(w * 0.74, h * 0.62), pSticks);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _TechLogoPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.color != color;
}

class _CyclingAnimatedTitle extends StatefulWidget {
  final List<String> titles;
  final bool isDesktop;
  final bool isDark;

  const _CyclingAnimatedTitle({
    required this.titles,
    required this.isDesktop,
    required this.isDark,
  });

  @override
  State<_CyclingAnimatedTitle> createState() => _CyclingAnimatedTitleState();
}

class _CyclingAnimatedTitleState extends State<_CyclingAnimatedTitle> {
  int _titleIndex = 0;
  int _charIndex = 0;
  Timer? _typeTimer;
  Timer? _cursorTimer;
  bool _showCursor = true;
  bool _isDeleting = false;

  String get _currentTitle =>
      widget.titles.isNotEmpty ? widget.titles[_titleIndex % widget.titles.length] : '';

  @override
  void initState() {
    super.initState();
    _startTypewriter();
    _startCursorBlink();
  }

  @override
  void didUpdateWidget(covariant _CyclingAnimatedTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.titles != widget.titles) {
      _charIndex = 0;
      _isDeleting = false;
      _titleIndex = 0;
      _startTypewriter();
    }
  }

  void _startCursorBlink() {
    _cursorTimer?.cancel();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
      }
    });
  }

  void _startTypewriter() {
    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 65), (timer) {
      if (!mounted) return;

      final title = _currentTitle;
      setState(() {
        if (!_isDeleting) {
          if (_charIndex < title.length) {
            _charIndex++;
          } else {
            // Finished typing: pause 2.2s so visitor can read comfortably
            _typeTimer?.cancel();
            _typeTimer = Timer(const Duration(milliseconds: 2200), () {
              if (mounted) {
                _isDeleting = true;
                _startDeleting();
              }
            });
          }
        }
      });
    });
  }

  void _startDeleting() {
    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 32), (timer) {
      if (!mounted) return;

      setState(() {
        if (_charIndex > 0) {
          _charIndex--;
        } else {
          // Finished deleting: advance to next title and re-type
          _typeTimer?.cancel();
          _isDeleting = false;
          _titleIndex = (_titleIndex + 1) % widget.titles.length;
          _typeTimer = Timer(const Duration(milliseconds: 400), () {
            if (mounted) {
              _startTypewriter();
            }
          });
        }
      });
    });
  }

  void _skipToNext() {
    _typeTimer?.cancel();
    setState(() {
      _titleIndex = (_titleIndex + 1) % widget.titles.length;
      _charIndex = 0;
      _isDeleting = false;
    });
    _startTypewriter();
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final isTablet = MediaQuery.sizeOf(context).width >= 600 &&
        MediaQuery.sizeOf(context).width <= 1024;
    final fontSize = isMobile ? 19.0 : (isTablet ? 24.0 : 30.0);
    final title = _currentTitle;
    final displayedText =
        title.isNotEmpty ? title.substring(0, _charIndex.clamp(0, title.length)) : '';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _skipToNext,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: widget.isDesktop ? Alignment.centerLeft : Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GradientText(
                  displayedText.isEmpty ? ' ' : displayedText,
                  colors: widget.isDark
                      ? const [
                          Color(0xFF38BDF8),
                          Color(0xFF818CF8),
                          Color(0xFFC084FC),
                        ]
                      : const [
                          Color(0xFF0284C7),
                          Color(0xFF4F46E5),
                          Color(0xFF9333EA),
                        ],
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                // Glowing cyan blinking cursor
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: _showCursor ? 1.0 : 0.0,
                  child: Container(
                    width: 3.0,
                    height: fontSize * 1.05,
                    margin: const EdgeInsets.only(left: 3),
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFF0284C7),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF38BDF8).withValues(alpha: 0.7),
                          blurRadius: 8,
                        ),
                      ],
                    ),
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

class _CaseStudiesCTAButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  const _CaseStudiesCTAButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.width,
    this.height,
  });

  @override
  State<_CaseStudiesCTAButton> createState() => _CaseStudiesCTAButtonState();
}

class _CaseStudiesCTAButtonState extends State<_CaseStudiesCTAButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _isHovered ? 1.03 : 1.0,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withValues(alpha: _isHovered ? 0.55 : 0.35),
                  blurRadius: _isHovered ? 28 : 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(widget.icon, size: isMobile ? 18 : 20, color: Colors.white),
                      const SizedBox(width: 8),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: isMobile ? 13.5 : 14.5,
                              letterSpacing: 0.3,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResumeCTAButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  const _ResumeCTAButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.width,
    this.height,
  });

  @override
  State<_ResumeCTAButton> createState() => _ResumeCTAButtonState();
}

class _ResumeCTAButtonState extends State<_ResumeCTAButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    final accentColor = isDark ? const Color(0xFF38BDF8) : const Color(0xFF4338CA);
    final bgSurface = isDark
        ? const Color(0xFF0F172A).withValues(alpha: _isHovered ? 0.95 : 0.8)
        : Colors.white.withValues(alpha: _isHovered ? 1.0 : 0.96);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _isHovered ? 1.03 : 1.0,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Container(
            decoration: BoxDecoration(
              color: bgSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: accentColor,
                width: 1.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: _isHovered ? 0.35 : 0.12),
                  blurRadius: _isHovered ? 24 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(widget.icon, size: isMobile ? 18 : 20, color: accentColor),
                      const SizedBox(width: 8),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: isMobile ? 13.5 : 14.5,
                              letterSpacing: 0.3,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryCTAButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _PrimaryCTAButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_PrimaryCTAButton> createState() => _PrimaryCTAButtonState();
}

class _PrimaryCTAButtonState extends State<_PrimaryCTAButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 640;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _isHovered ? 1.04 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _isHovered ? 0.45 : 0.25),
                blurRadius: _isHovered ? 28 : 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: widget.onPressed,
            icon: Icon(widget.icon, size: 18, color: Colors.white),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 22 : 32, vertical: isMobile ? 16 : 22),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryCTAButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _SecondaryCTAButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_SecondaryCTAButton> createState() => _SecondaryCTAButtonState();
}

class _SecondaryCTAButtonState extends State<_SecondaryCTAButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = MediaQuery.sizeOf(context).width < 640;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _isHovered ? 1.04 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: _isHovered ? 0.1 : 0.04)
                : Colors.black.withValues(alpha: _isHovered ? 0.06 : 0.02),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? theme.colorScheme.primary : theme.dividerColor,
              width: 1.5,
            ),
          ),
          child: OutlinedButton.icon(
            onPressed: widget.onPressed,
            icon: Icon(widget.icon, size: 18, color: theme.colorScheme.onSurface),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.label,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 28, vertical: isMobile ? 16 : 22),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialPill extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SocialPill> createState() => _SocialPillState();
}

class _SocialPillState extends State<_SocialPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _isHovered
                ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.1)
                : (isDark ? AppColors.darkSurface : AppColors.lightSurfaceAlt),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _isHovered ? theme.colorScheme.primary : theme.dividerColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 14,
                color: _isHovered ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: _isHovered ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
