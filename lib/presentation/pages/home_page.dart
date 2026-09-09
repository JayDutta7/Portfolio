import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/common/nav_bar.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/architecture_section.dart';
import '../widgets/sections/contact_section.dart';
import '../widgets/sections/device_showcase.dart';
import '../widgets/sections/education_section.dart';
import '../widgets/sections/experience_section.dart';
import '../widgets/sections/engineering_principles.dart';
import '../widgets/sections/code_moment.dart';
import '../widgets/sections/footer_section.dart';
import '../widgets/sections/hero_section.dart';
import '../widgets/sections/projects_section.dart';
import '../widgets/sections/skills_section.dart';

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
              ProjectsSection(profile: profile, sectionKey: _projectsKey),
              DeviceShowcase(projects: profile.projects.take(4).toList()),
              ArchitectureSection(profile: profile),
              SkillsSection(profile: profile, sectionKey: _skillsKey),
              const EngineeringPrinciples(),
              const CodeMoment(),
              ExperienceSection(profile: profile, sectionKey: _experienceKey),
              AboutSection(profile: profile, sectionKey: _aboutKey),
              EducationSection(profile: profile, sectionKey: _educationKey),
              ContactSection(profile: profile, sectionKey: _contactKey),
              SiteFooter(profile: profile),
            ],
          ),
        ),
      ),
      loading: () => Scaffold(
        backgroundColor: const Color(0xFF050505),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Jayajit Dutta'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ],
          ),
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
