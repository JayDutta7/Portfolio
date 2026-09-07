import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/profile_viewmodel.dart';
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

  late final List<NavItem> _navItems = [
    NavItem('Home', _heroKey),
    NavItem('About', _aboutKey),
    NavItem('Skills', _skillsKey),
    NavItem('Experience', _experienceKey),
    NavItem('Projects', _projectsKey),
    NavItem('Education', _educationKey),
    NavItem('Contact', _contactKey),
  ];

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = ref.watch(profileViewModelProvider);

    return profileViewModel.when(
      data: (profile) => Scaffold(
        appBar: NavBar(
          items: _navItems,
          onNavTap: _scrollTo,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeroSection(
                profile: profile,
                sectionKey: _heroKey,
                onViewWork: () => _scrollTo(_projectsKey),
              ),
              AboutSection(profile: profile, sectionKey: _aboutKey),
              SkillsSection(profile: profile, sectionKey: _skillsKey),
              ExperienceSection(profile: profile, sectionKey: _experienceKey),
              ProjectsSection(profile: profile, sectionKey: _projectsKey),
              ArchitectureSection(profile: profile),
              StatsSection(profile: profile),
              EducationSection(profile: profile, sectionKey: _educationKey),
              ContactSection(profile: profile, sectionKey: _contactKey),
              SiteFooter(profile: profile),
            ],
          ),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
