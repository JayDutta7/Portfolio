import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/config/app_environment.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/firebase_presence_service.dart';
import '../../core/utils/distribution_helper.dart';
import '../../core/utils/resume_download/resume_download.dart';
import '../viewmodels/locale_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';
import '../widgets/common/environment_badge.dart';
import '../widgets/common/mesh_background.dart';
import '../widgets/common/nav_bar.dart';
import '../widgets/common/voice_assistant_sheet.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/architecture_section.dart';
import '../widgets/sections/contact_section.dart';
import '../widgets/sections/education_section.dart';
import '../widgets/sections/experience_section.dart';
import '../widgets/sections/footer_section.dart';
import '../widgets/sections/hero_section.dart';
import '../widgets/sections/projects_section.dart';
import '../widgets/sections/skills_section.dart';
import '../widgets/sections/setup_section.dart';
import '../widgets/sections/stats_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _scrollController = ScrollController();
  final _heroKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _architectureKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _educationKey = GlobalKey();
  final _contactKey = GlobalKey();
  bool _isStartupLoadingDone = false;
  bool _isAtBottom = false;
  bool _showScrollNav = false;
  bool _canScrollUp = false;
  bool _canScrollDown = false;
  ScrollDirection _scrollDirection = ScrollDirection.idle;
  double _lastScrollOffset = 0.0;
  Timer? _hideScrollNavTimer;
  bool _isHoveringScrollNav = false;

  @override
  void initState() {
    super.initState();
    DistributionHelper.init();
    FirebasePresenceService().init();
    _scrollController.addListener(_onScroll);
    // Warm up Firestore fetch in background immediately on startup.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lang = ref.read(localeProvider);
      ref.read(profileViewModelProvider(lang).future).ignore();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final atBottom = maxScroll > 0 && currentScroll >= (maxScroll - 160);
    final canUp = currentScroll > 100;
    final canDown = maxScroll > 0 && currentScroll < (maxScroll - 100);

    ScrollDirection currentDir = _scrollDirection;
    if (currentScroll > _lastScrollOffset + 3) {
      currentDir = ScrollDirection.reverse; // scrolling down
    } else if (currentScroll < _lastScrollOffset - 3) {
      currentDir = ScrollDirection.forward; // scrolling up
    }
    _lastScrollOffset = currentScroll;

    final shouldShow = canUp || canDown;
    if (_showScrollNav != shouldShow ||
        _canScrollUp != canUp ||
        _canScrollDown != canDown ||
        _isAtBottom != atBottom ||
        _scrollDirection != currentDir) {
      setState(() {
        _showScrollNav = shouldShow;
        _canScrollUp = canUp;
        _canScrollDown = canDown;
        _isAtBottom = atBottom;
        _scrollDirection = currentDir;
      });
    }

    _scheduleHideScrollNav();
  }

  void _scheduleHideScrollNav() {
    _hideScrollNavTimer?.cancel();
    _hideScrollNavTimer = Timer(const Duration(milliseconds: 2600), () {
      if (mounted && !_isHoveringScrollNav) {
        setState(() => _showScrollNav = false);
      }
    });
  }

  @override
  void dispose() {
    _hideScrollNavTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeInOutCubic,
    );
    _scheduleHideScrollNav();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 950),
      curve: Curves.easeInOutCubic,
    );
    _scheduleHideScrollNav();
  }


  Future<void> _handleRefresh() async {
    final lang = ref.read(localeProvider);
    ref.invalidate(profileViewModelProvider(lang));
    DistributionHelper.init();
    await Future.delayed(const Duration(milliseconds: 600));
  }

  List<NavItem> _getNavItems(AppLanguage lang) => [
    NavItem(lang.navWork, _projectsKey),
    NavItem(lang.navExperience, _experienceKey),
    NavItem(lang.navEngineering, _skillsKey),
    NavItem(lang.navAbout, _aboutKey),
  ];

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      final renderObject = ctx.findRenderObject() as RenderBox?;
      if (renderObject != null) {
        if (_scrollController.hasClients) {
          final offset = renderObject.localToGlobal(Offset.zero, ancestor: context.findRenderObject()).dy;
          final target = (_scrollController.offset + offset - 85).clamp(0.0, _scrollController.position.maxScrollExtent);
          _scrollController.animateTo(
            target,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
          return;
        }
        final scrollable = Scrollable.of(ctx);
        final position = scrollable.position;
        final offset = renderObject.localToGlobal(Offset.zero, ancestor: scrollable.context.findRenderObject()).dy;
        final target = (position.pixels + offset - 85).clamp(0.0, position.maxScrollExtent);
        position.animateTo(
          target,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
        return;
      }
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _openVoiceAssistant() {
    VoiceAssistantSheet.show(
      context,
      onScrollToProjects: () => _scrollTo(_projectsKey),
      onScrollToArchitecture: () => _scrollTo(_architectureKey),
      onScrollToSkills: () => _scrollTo(_skillsKey),
      onScrollToExperience: () => _scrollTo(_experienceKey),
      onScrollToEducation: () => _scrollTo(_educationKey),
      onScrollToAbout: () => _scrollTo(_aboutKey),
      onScrollToContact: () => _scrollTo(_contactKey),
      onDownloadResume: () {
        final profile = ref.read(profileSyncProvider);
        downloadResume(profile.resumeAssetPath, profile.resumeDownloadFileName);
      },
      onToggleTheme: () => ref.read(themeProvider.notifier).toggle(),
    );
  }

  Widget _buildScrollNav(bool isDark) {
    if (!_canScrollUp && !_canScrollDown) return const SizedBox.shrink();

    final isScrollingDown = _scrollDirection == ScrollDirection.reverse;
    final isScrollingUp = _scrollDirection == ScrollDirection.forward;

    final activeColor = isDark ? const Color(0xFF38BDF8) : AppColors.primary;
    final inactiveColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final bgColor = isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.92)
        : Colors.white.withValues(alpha: 0.95);
    final borderColor = isDark
        ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
        : AppColors.primary.withValues(alpha: 0.25);

    return MouseRegion(
      onEnter: (_) {
        _isHoveringScrollNav = true;
        _hideScrollNavTimer?.cancel();
      },
      onExit: (_) {
        _isHoveringScrollNav = false;
        _scheduleHideScrollNav();
      },
      child: AnimatedSlide(
        offset: _showScrollNav ? Offset.zero : const Offset(0.35, 0),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: _showScrollNav ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          child: IgnorePointer(
            ignoring: !_showScrollNav,
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: borderColor, width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_canScrollUp) ...[
                    _buildScrollNavButton(
                      icon: Icons.keyboard_arrow_up_rounded,
                      tooltip: 'Scroll to top',
                      isActive: isScrollingUp || _isAtBottom,
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      onTap: _scrollToTop,
                    ),
                  ],
                  if (_canScrollUp && _canScrollDown)
                    Container(
                      width: 1,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                  if (_canScrollDown) ...[
                    _buildScrollNavButton(
                      icon: Icons.keyboard_arrow_down_rounded,
                      tooltip: 'Scroll to bottom',
                      isActive: isScrollingDown && !_isAtBottom,
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      onTap: _scrollToBottom,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollNavButton({
    required IconData icon,
    required String tooltip,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? activeColor.withValues(alpha: 0.14) : Colors.transparent,
            ),
            child: Icon(
              icon,
              color: isActive ? activeColor : inactiveColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileSyncProvider);
    final currentLanguage = ref.watch(localeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: NavBar(
        items: _getNavItems(currentLanguage),
        onNavTap: _scrollTo,
        onLogoTap: () => _scrollTo(_heroKey),
        onVoiceTap: _openVoiceAssistant,
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildScrollNav(isDark),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'fab_voice_assistant',
            onPressed: _openVoiceAssistant,
            backgroundColor: AppColors.secondary,
            elevation: 6,
            shape: const CircleBorder(),
            tooltip: 'Voice Navigation',
            child: const Icon(Icons.mic_rounded, color: Colors.white, size: 24),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Ambient Mesh & Glow Canvas
          const Positioned.fill(
            child: AmbientMeshBackground(),
          ),

          // Scrollable Section Layer with Pull to Refresh
          Positioned.fill(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              displacement: 40,
              edgeOffset: 8,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  children: [
                    _TopOpportunityBanner(message: currentLanguage.availableBadge),
                    HeroSection(
                      profile: profile,
                      sectionKey: _heroKey,
                      scrollController: _scrollController,
                      projectsKey: _projectsKey,
                      onViewWork: () => _scrollTo(_projectsKey),
                    ),
                    StatsSection(profile: profile),
                    ExperienceSection(profile: profile, sectionKey: _experienceKey),
                    ProjectsSection(profile: profile, sectionKey: _projectsKey),
                    ArchitectureSection(profile: profile, sectionKey: _architectureKey),
                    SkillsSection(profile: profile, sectionKey: _skillsKey),
                    const SetupSection(),
                    AboutSection(profile: profile, sectionKey: _aboutKey),
                    EducationSection(profile: profile, sectionKey: _educationKey),
                    ContactSection(profile: profile, sectionKey: _contactKey),
                    SiteFooter(profile: profile),
                  ],
                ),
              ),
            ),
          ),

          // Floating environment badge for DEV / UAT builds
          if (!AppEnvironment.isProd)
            const EnvironmentBadge(),

          // Starting Loading Animation (Fade In -> Fade Out)
          if (!_isStartupLoadingDone)
            Positioned.fill(
              child: _StartingLoadingOverlay(
                onCompleted: () {
                  if (mounted) {
                    setState(() => _isStartupLoadingDone = true);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Lightweight starting loading overlay that smoothly fades in and then fades out
class _StartingLoadingOverlay extends StatefulWidget {
  final VoidCallback? onCompleted;

  const _StartingLoadingOverlay({this.onCompleted});

  @override
  State<_StartingLoadingOverlay> createState() => _StartingLoadingOverlayState();
}

class _StartingLoadingOverlayState extends State<_StartingLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Keyframe sequence: Fade In -> Hold -> Fade Out
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 38,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 24,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 38,
      ),
    ]).animate(_controller);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.94, end: 1.0).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 38,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 24,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.04).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 38,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted?.call();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = _opacityAnimation.value.clamp(0.0, 1.0);
        if (opacity <= 0.0 && _controller.value >= 0.99) {
          return const SizedBox.shrink();
        }

        return IgnorePointer(
          ignoring: opacity < 0.2,
          child: Opacity(
            opacity: opacity,
            child: Material(
              color: theme.scaffoldBackgroundColor,
              child: Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Minimalist sleek glowing spinner
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35 * opacity),
                              blurRadius: 28,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: CircularProgressIndicator(
                          strokeWidth: 3.2,
                          strokeCap: StrokeCap.round,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.08),
                        ),
                      ),
                    ],
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

class _TopOpportunityBanner extends StatelessWidget {
  final String message;
  const _TopOpportunityBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return Padding(
      padding: EdgeInsets.only(
        top: isMobile ? 10 : 14,
        left: 16,
        right: 16,
        bottom: 4,
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 14 : 18,
            vertical: isMobile ? 7 : 8,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.emerald.withValues(alpha: 0.12)
                : AppColors.emerald.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.emerald.withValues(alpha: 0.35),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.emerald.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.emerald,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: isMobile ? (width < 360 ? 11.0 : 11.8) : 12.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                    letterSpacing: 0.2,
                    height: 1.35,
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
