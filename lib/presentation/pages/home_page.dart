import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/locale_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/common/mesh_background.dart';
import '../widgets/common/nav_bar.dart';
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
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _educationKey = GlobalKey();
  final _contactKey = GlobalKey();

  List<NavItem> _getNavItems(AppLanguage lang) => [
    NavItem(lang.navWork, _projectsKey),
    NavItem(lang.navExperience, _experienceKey),
    NavItem(lang.navEngineering, _skillsKey),
    NavItem(lang.navAbout, _aboutKey),
  ];

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = ref.watch(profileViewModelProvider);
    final currentLanguage = ref.watch(localeProvider);
    final theme = Theme.of(context);

    return profileViewModel.when(
      data: (profile) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: NavBar(
          items: _getNavItems(currentLanguage),
          onNavTap: _scrollTo,
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
                    HeroSection(
                      profile: profile,
                      sectionKey: _heroKey,
                      onViewWork: () => _scrollTo(_projectsKey),
                    ),
                    StatsSection(profile: profile),
                    ExperienceSection(profile: profile, sectionKey: _experienceKey),
                    ProjectsSection(profile: profile, sectionKey: _projectsKey),
                    ArchitectureSection(profile: profile),
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
      ),
      loading: () => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'JAYAJIT DUTTA'.toUpperCase(),
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error loading profile: $error'),
        ),
      ),
    );
  }
}
