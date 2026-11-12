import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayajit_portfolio/data/profile_data.dart';
import 'package:jayajit_portfolio/presentation/viewmodels/locale_viewmodel.dart';
import 'package:jayajit_portfolio/screens/portfolio_home_screen.dart';
import 'package:jayajit_portfolio/sections/bento_hero_section.dart';
import 'package:jayajit_portfolio/sections/projects_architecture_section.dart';
import 'package:jayajit_portfolio/widgets/floating_nav_bar.dart';
import 'package:jayajit_portfolio/widgets/hover_bento_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  final testProfile = ProfileData.getProfile(AppLanguage.english);

  group('Linear / Vercel Dark Bento Design System Tests', () {
    testWidgets('HoverBentoCard renders child and glassmorphic slate container', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HoverBentoCard(
              child: Text('Test Bento Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Test Bento Card Content'), findsOneWidget);
      expect(find.byType(HoverBentoCard), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('FloatingNavBar renders JD monogram, all 5 tabs, and high-contrast CTA', (tester) async {
      String? tappedTab;
      bool ctaTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FloatingNavBar(
              activeSection: 'Overview',
              onSectionTap: (tab) => tappedTab = tab,
              onCtaTap: () => ctaTapped = true,
            ),
          ),
        ),
      );

      // Verify JD monogram badge
      expect(find.text('JD'), findsOneWidget);

      // Verify all 5 smooth-scroll section tabs
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Architecture'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Experience'), findsOneWidget);
      expect(find.text('Contact'), findsOneWidget);

      // Verify CTA button
      expect(find.textContaining("Let's Talk"), findsOneWidget);

      // Tap on Projects tab
      await tester.tap(find.text('Projects'));
      await tester.pump();
      expect(tappedTab, 'Projects');

      // Tap on CTA
      await tester.tap(find.textContaining("Let's Talk"));
      await tester.pump();
      expect(ctaTapped, isTrue);
    });

    testWidgets('BentoHeroSection renders 4 asymmetric Bento tiles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BentoHeroSection(profile: testProfile),
            ),
          ),
        ),
      );

      // Tile A: Main Hero
      expect(find.text('Available for Mobile Architect & Lead Roles'), findsOneWidget);
      expect(
        find.text('Architecting Offline-First, Native & Cross-Platform Mobile Systems.'),
        findsOneWidget,
      );
      expect(find.text('Explore Case Studies'), findsOneWidget);
      expect(find.text('Download CV'), findsOneWidget);

      // Tile B: Developer Profile
      expect(find.text(testProfile.name), findsOneWidget);
      expect(find.text('Kolkata, India'), findsOneWidget);

      // Tile C: High-Impact Metrics Strip
      expect(find.text('9+ Years'), findsOneWidget);
      expect(find.text('9+ Apps'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);

      // Tile D: Interactive Tech Stack Radar
      expect(find.text('SYSTEM ARCHITECTURE RADAR'), findsOneWidget);
      expect(find.text('Jetpack Compose'), findsOneWidget);
      expect(find.text('Riverpod'), findsOneWidget);
      expect(find.text('Method Channels'), findsOneWidget);
    });

    testWidgets('ProjectBentoCard toggles between Overview and Architecture mode seamlessly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProjectsArchitectureSection(),
            ),
          ),
        ),
      );

      // Check section title
      expect(find.text('ENTERPRISE PRODUCTION CASE STUDIES'), findsOneWidget);
      expect(find.text('Commercial Systems & Architecture Blueprints'), findsOneWidget);

      // Initially in Overview mode
      expect(find.text('PROBLEM SCOPE & CHALLENGE'), findsWidgets);
      expect(find.text('QUANTIFIABLE BUSINESS IMPACT'), findsWidgets);

      // Find segmented toggle buttons for Architecture mode
      final archToggles = find.text('Architecture');
      expect(archToggles, findsWidgets);

      // Tap the first Architecture toggle
      await tester.tap(archToggles.first);
      await tester.pumpAndSettle();

      // Verify Architecture blueprint elements are now visible
      expect(
        find.textContaining('ARCHITECTURE BLUEPRINT'),
        findsWidgets,
      );
      expect(find.text('PRESENTATION LAYER'), findsWidgets);
      expect(find.text('DOMAIN / USECASES LAYER'), findsWidgets);
      expect(find.text('DATA / OFFLINE SYNC LAYER'), findsWidgets);
      expect(find.text('PLATFORM BRIDGE / NATIVE SERVICES'), findsWidgets);

      // Toggle back to Overview
      final overviewToggles = find.text('Overview');
      await tester.tap(overviewToggles.first);
      await tester.pumpAndSettle();

      expect(find.text('PROBLEM SCOPE & CHALLENGE'), findsWidgets);
    });

    testWidgets('PortfolioHomeScreen renders completely with responsive layout', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PortfolioHomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(PortfolioHomeScreen), findsOneWidget);
      expect(find.byType(FloatingNavBar), findsOneWidget);
      expect(find.byType(BentoHeroSection), findsOneWidget);
      expect(find.byType(ProjectsArchitectureSection), findsOneWidget);
    });
  });
}
