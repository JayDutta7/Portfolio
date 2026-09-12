import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayajit_portfolio/main.dart';
import 'package:jayajit_portfolio/data/profile_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('Portfolio home page renders hero name', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PortfolioApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining(ProfileData.name.toUpperCase()), findsWidgets);
  });
}