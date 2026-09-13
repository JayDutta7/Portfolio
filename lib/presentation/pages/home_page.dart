import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/distribution_helper.dart';
import '../../core/utils/resume_download/resume_download.dart';
import '../viewmodels/locale_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';
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
  final _heroKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _architectureKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _educationKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    DistributionHelper.init();
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
      onScrollToAbout: () => _scrollTo(_aboutKey),
      onScrollToContact: () => _scrollTo(_contactKey),
      onDownloadResume: () {
        final profile = ref.read(profileViewModelProvider);
        downloadResume(profile.resumeAssetPath, profile.resumeDownloadFileName);
      },
      onToggleTheme: () => ref.read(themeProvider.notifier).toggle(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileViewModelProvider);
    final currentLanguage = ref.watch(localeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: NavBar(
        items: _getNavItems(currentLanguage),
        onNavTap: _scrollTo,
        onLogoTap: () => _scrollTo(_heroKey),
        onVoiceTap: _openVoiceAssistant,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openVoiceAssistant,
        backgroundColor: AppColors.secondary,
        elevation: 6,
        shape: const CircleBorder(),
        tooltip: 'Voice Navigation',
        child: const Icon(Icons.mic_rounded, color: Colors.white, size: 24),
      ),
      body: Stack(
        children: [
          // Ambient Mesh & Glow Canvas
          const Positioned.fill(
            child: AmbientMeshBackground(),
          ),

          // Scrollable Section Layer
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _TopOpportunityBanner(message: currentLanguage.availableBadge),
                  HeroSection(
                    profile: profile,
                    sectionKey: _heroKey,
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
        ],
      ),
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

    return Padding(
      padding: const EdgeInsets.only(top: 14, left: 16, right: 16, bottom: 4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.emerald.withValues(alpha: 0.12)
                : AppColors.emerald.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(100),
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
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                    letterSpacing: 0.2,
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
