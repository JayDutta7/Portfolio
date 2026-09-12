import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayajit_portfolio/main.dart';
import 'package:jayajit_portfolio/data/profile_data.dart';
import 'package:jayajit_portfolio/presentation/widgets/common/device_mockup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('Portfolio renders immediately with hero name, headline, and download resume button', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PortfolioApp(),
      ),
    );

    // Verify immediate render without lengthy pre-loaders
    await tester.pump();

    // Verify Hero Name
    expect(find.textContaining(ProfileData.name.toUpperCase()), findsWidgets);

    // Verify Hero Headline stating mobile developer tech stack (Android, Kotlin, Flutter)
    expect(find.textContaining('Android'), findsWidgets);
    expect(find.textContaining('Kotlin'), findsWidgets);
    expect(find.textContaining('Flutter'), findsWidgets);

    // Verify Prominent 'DOWNLOAD RESUME' button
    expect(find.text('DOWNLOAD RESUME'), findsWidgets);
  });

  testWidgets('Projects section renders device mockups and mobile tech tags (Retrofit, Room, RxJava)', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PortfolioApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify DeviceMockup widgets are rendered
    expect(find.byType(DeviceMockup), findsWidgets);

    // Verify modern mobile architecture UI tags are rendered
    expect(find.text('Retrofit'), findsWidgets);
    expect(find.text('Room DB'), findsWidgets);
    expect(find.text('RxJava'), findsWidgets);
    expect(find.text('Jetpack Compose'), findsWidgets);
  });

  testWidgets('Mobile viewport renders without overflow or horizontal scroll clipping', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: PortfolioApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify hero headline and button on mobile screen
    expect(find.text('DOWNLOAD RESUME'), findsWidgets);
    expect(find.textContaining('Android'), findsWidgets);
  });
}