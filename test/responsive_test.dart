import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayajit_portfolio/main.dart';
import 'package:jayajit_portfolio/presentation/pages/project_details_page.dart';
import 'package:jayajit_portfolio/presentation/viewmodels/locale_viewmodel.dart';
import 'package:jayajit_portfolio/data/profile_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  final screenSizes = [
    const Size(320, 568),  // iPhone SE 1st gen
    const Size(360, 800),  // Common Android
    const Size(375, 812),  // iPhone X / mini
    const Size(390, 844),  // iPhone 13 / 14
    const Size(414, 896),  // iPhone XR / 11
    const Size(600, 960),  // Small tablet
    const Size(768, 1024), // iPad portrait
    const Size(1024, 768), // iPad landscape
    const Size(1280, 800), // Laptop
    const Size(1440, 900), // Desktop
    const Size(1920, 1080),// Full HD
    const Size(2560, 1440),// Ultrawide 2K
  ];

  for (final size in screenSizes) {
    testWidgets('HomePage renders without overflow at ${size.width}x${size.height}', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: PortfolioApp(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Scroll down gradually through all sections to check for overflows
      final scrollableFinder = find.byType(Scrollable).first;
      for (int i = 0; i < 15; i++) {
        await tester.drag(scrollableFinder, const Offset(0, -600));
        await tester.pump(const Duration(milliseconds: 100));
      }
    });

    testWidgets('ProjectDetailsPage renders without overflow at ${size.width}x${size.height}', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: ProjectDetailsPage(
            project: ProfileData.getProfile(AppLanguage.english).projects.first,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final scrollableFinder = find.byType(Scrollable).first;
      for (int i = 0; i < 10; i++) {
        await tester.drag(scrollableFinder, const Offset(0, -600));
        await tester.pump(const Duration(milliseconds: 100));
      }
    });
  }
}
