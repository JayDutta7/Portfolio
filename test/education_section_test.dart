import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayajit_portfolio/data/profile_data.dart';
import 'package:jayajit_portfolio/presentation/viewmodels/locale_viewmodel.dart';
import 'package:jayajit_portfolio/presentation/widgets/sections/education_section.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  testWidgets('EducationSection displays all 5 milestones and filters correctly', (tester) async {
    final profile = ProfileData.getProfile(AppLanguage.english);
    
    // Set a desktop surface size
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: EducationSection(profile: profile),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify all 5 items are initially present
    expect(find.text('Master of Computer Applications (MCA)'), findsOneWidget);
    expect(find.text('Bachelor of Computer Applications (BCA)'), findsOneWidget);
    expect(find.text('Professional Android Developer'), findsOneWidget);
    expect(find.text('Higher Secondary (12th)'), findsOneWidget);
    expect(find.text('Madhyamik (10th)'), findsOneWidget);

    // Verify Institutions are present
    expect(find.textContaining('Brainware Group of Institutions'), findsOneWidget);
    expect(find.textContaining('Meghnad Saha Institute of Technology'), findsOneWidget);
    expect(find.textContaining('Ejob India'), findsOneWidget);
    expect(find.textContaining('Serampore High School'), findsOneWidget);
    expect(find.textContaining('Serampore Union Institution'), findsOneWidget);

    // Tap "University Degrees" filter
    await tester.tap(find.text('University Degrees'));
    await tester.pumpAndSettle();

    // Now only MCA and BCA should be visible
    expect(find.text('Master of Computer Applications (MCA)'), findsOneWidget);
    expect(find.text('Bachelor of Computer Applications (BCA)'), findsOneWidget);
    expect(find.text('Professional Android Developer'), findsNothing);
    expect(find.text('Higher Secondary (12th)'), findsNothing);
    expect(find.text('Madhyamik (10th)'), findsNothing);

    // Tap "Technical Certifications" filter
    await tester.tap(find.text('Technical Certifications'));
    await tester.pumpAndSettle();

    // Now only Professional Android Developer should be visible
    expect(find.text('Master of Computer Applications (MCA)'), findsNothing);
    expect(find.text('Bachelor of Computer Applications (BCA)'), findsNothing);
    expect(find.text('Professional Android Developer'), findsOneWidget);
    expect(find.text('Higher Secondary (12th)'), findsNothing);
    expect(find.text('Madhyamik (10th)'), findsNothing);

    // Tap "Schooling (10th & 12th)" filter
    await tester.tap(find.text('Schooling (10th & 12th)'));
    await tester.pumpAndSettle();

    // Now only HS and Madhyamik should be visible
    expect(find.text('Master of Computer Applications (MCA)'), findsNothing);
    expect(find.text('Bachelor of Computer Applications (BCA)'), findsNothing);
    expect(find.text('Professional Android Developer'), findsNothing);
    expect(find.text('Higher Secondary (12th)'), findsOneWidget);
    expect(find.text('Madhyamik (10th)'), findsOneWidget);

    // Tap "All Milestones" filter
    await tester.tap(find.text('All Milestones'));
    await tester.pumpAndSettle();

    // All 5 back
    expect(find.text('Master of Computer Applications (MCA)'), findsOneWidget);
    expect(find.text('Bachelor of Computer Applications (BCA)'), findsOneWidget);
    expect(find.text('Professional Android Developer'), findsOneWidget);
    expect(find.text('Higher Secondary (12th)'), findsOneWidget);
    expect(find.text('Madhyamik (10th)'), findsOneWidget);
  });
}
