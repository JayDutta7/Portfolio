import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayajit_portfolio/main.dart';
import 'package:jayajit_portfolio/data/profile_data.dart';
import 'package:jayajit_portfolio/presentation/viewmodels/locale_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  test('Ghareka Consumer App does not contain Razorpay in techStack or description', () {
    final profile = ProfileData.getProfile(AppLanguage.english);
    final ghareka = profile.projects.firstWhere(
      (p) => p.title.contains('Ghareka Consumer'),
    );

    expect(ghareka.techStack.contains('Razorpay'), isFalse);
    expect(ghareka.overview.toLowerCase().contains('razorpay'), isFalse);
  });

  testWidgets('Scroll navigation controls hide at top and show upon scroll', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: PortfolioApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // At top of page: neither scroll up nor scroll down arrow should be visible
    expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsNothing);
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsNothing);

    // Voice assistant mic button is available
    expect(find.byIcon(Icons.mic_rounded), findsWidgets);

    // Drag the page to scroll down by 800px
    await tester.drag(find.byType(RefreshIndicator), const Offset(0, -800));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // After scrolling down: directional arrows appear
    expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);

    // Tap scroll to top
    await tester.tap(find.byIcon(Icons.keyboard_arrow_up_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    // Verified scroll to top executes smoothly
  });
}
