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
import '../hero_avatar/hero_avatar_ring.dart';
import '../hero_avatar/orbiting_tech_badges.dart';
import '../hero_avatar/pulsing_avatar_hero.dart';

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

class _HeroOrbitAvatarShowcase extends StatefulWidget {
  final Profile profile;
  const _HeroOrbitAvatarShowcase({required this.profile});

  @override
  State<_HeroOrbitAvatarShowcase> createState() => _HeroOrbitAvatarShowcaseState();
}

class _HeroOrbitAvatarShowcaseState extends State<_HeroOrbitAvatarShowcase> {
  bool _isAvatarHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    final double canvasSize = isMobile ? 360.0 : 450.0;
    final double avatarDiameter = isMobile ? 152.0 : 196.0;
    final double avatarRadius = avatarDiameter / 2;
    final double innerRadius = isMobile ? 112.0 : 142.0;
    final double outerRadius = isMobile ? 154.0 : 194.0;
    final double badgeSize = isMobile ? 36.0 : 44.0;

    // 1. Inner Track Badges: Core Native & Language Runtimes (Clockwise revolution)
    final innerBadges = [
      OrbitBadgeItem(
        name: 'Flutter',
        icon: CustomPaint(
          painter: _TechLogoPainter(
            type: _TechBadgeType.flutter,
            color: const Color(0xFF38BDF8),
            isDark: isDark,
          ),
        ),
        color: const Color(0xFF38BDF8),
        glowColor: const Color(0xFF0284C7),
        tooltip: 'Flutter (Dart) • Cross-Platform Master',
      ),
      OrbitBadgeItem(
        name: 'Android',
        icon: CustomPaint(
          painter: _TechLogoPainter(
            type: _TechBadgeType.android,
            color: const Color(0xFF34D399),
            isDark: isDark,
          ),
        ),
        color: const Color(0xFF34D399),
        glowColor: const Color(0xFF10B981),
        tooltip: 'Android Native • Jetpack & Coroutines',
      ),
      OrbitBadgeItem(
        name: 'Kotlin',
        icon: CustomPaint(
          painter: _TechLogoPainter(
            type: _TechBadgeType.kotlin,
            color: const Color(0xFF818CF8),
            isDark: isDark,
          ),
        ),
        color: const Color(0xFF818CF8),
        glowColor: const Color(0xFFC084FC),
        tooltip: 'Kotlin & KMP • Multiplatform',
      ),
      OrbitBadgeItem(
        name: 'iOS',
        icon: CustomPaint(
          painter: _TechLogoPainter(
            type: _TechBadgeType.ios,
            color: const Color(0xFF64748B),
            isDark: isDark,
          ),
        ),
        color: const Color(0xFF64748B),
        glowColor: const Color(0xFF475569),
        tooltip: 'iOS',
      ),
    ];

    // 2. Outer Track Badges: Cloud, Ecosystem & App Stores (Counter-clockwise revolution)
    final outerBadges = [
      OrbitBadgeItem(
        name: 'Firebase',
        icon: CustomPaint(
          painter: _TechLogoPainter(
            type: _TechBadgeType.firebase,
            color: const Color(0xFFFBBF24),
            isDark: isDark,
          ),
        ),
        color: const Color(0xFFFBBF24),
        glowColor: const Color(0xFFD97706),
        tooltip: 'Firebase • Cloud & Auth Architecture',
      ),
      OrbitBadgeItem(
        name: 'Git',
        icon: CustomPaint(
          painter: _TechLogoPainter(
            type: _TechBadgeType.git,
            color: const Color(0xFFFB923C),
            isDark: isDark,
          ),
        ),
        color: const Color(0xFFFB923C),
        glowColor: const Color(0xFFEA580C),
        tooltip: 'Git & CI/CD Pipelines',
      ),
      OrbitBadgeItem(
        name: 'Play Store',
        icon: CustomPaint(
          painter: _TechLogoPainter(
            type: _TechBadgeType.playStore,
            color: const Color(0xFF34D399),
            isDark: isDark,
          ),
        ),
        color: const Color(0xFF34D399),
        glowColor: const Color(0xFF059669),
        tooltip: 'Google Play • Published Enterprise Apps',
      ),
      OrbitBadgeItem(
        name: 'App Store',
        icon: CustomPaint(
          painter: _TechLogoPainter(
            type: _TechBadgeType.appStore,
            color: const Color(0xFF38BDF8),
            isDark: isDark,
          ),
        ),
        color: const Color(0xFF38BDF8),
        glowColor: const Color(0xFF2563EB),
        tooltip: 'Apple App Store • Certified Releases',
      ),
    ];

    // 3. Anchored live experience & availability status badge
    final statusBadge = Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 5 : 7,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.94)
            : Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isDark
              ? const Color(0xFF38BDF8).withValues(alpha: 0.5)
              : AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF10B981),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF10B981),
                  blurRadius: 6,
                  spreadRadius: 1.5,
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Text(
            '9+ YRS • Senior Mobile Dev',
            style: GoogleFonts.jetBrainsMono(
              fontSize: isMobile ? 10.0 : 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );

    // 4. Rotating conic border with mouse parallax 3D card tilt
    final heroAvatarRing = HeroAvatarRing(
      size: avatarDiameter,
      borderWidth: 4.0,
      onHoverChanged: (hovered) {
        setState(() {
          _isAvatarHovered = hovered;
        });
      },
      child: Image.asset(
        widget.profile.profilePicture,
        fit: BoxFit.cover,
        width: avatarDiameter,
        height: avatarDiameter,
        errorBuilder: (context, error, stackTrace) => Container(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              size: isMobile ? 64 : 88,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );

    // 5. Bioluminescent multi-ring ripples wrapping avatar & badge
    final pulsingHero = PulsingAvatarHero(
      avatarRadius: avatarRadius,
      isHovered: _isAvatarHovered,
      accentColor: const Color(0xFF06B6D4),
      secondaryColor: const Color(0xFF6366F1),
      badge: statusBadge,
      child: heroAvatarRing,
    );

    // 6. Dual concentric circular orbital tracks with upright planetary badges
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: OrbitingTechBadges(
        canvasSize: canvasSize,
        innerRadius: innerRadius,
        outerRadius: outerRadius,
        badgeSize: badgeSize,
        isDark: isDark,
        innerBadges: innerBadges,
        outerBadges: outerBadges,
        centerWidget: pulsingHero,
      ),
    );
  }
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
