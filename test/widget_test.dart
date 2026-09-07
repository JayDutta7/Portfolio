import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayajit_portfolio/main.dart';
import 'package:jayajit_portfolio/data/profile_data.dart';

void main() {
  testWidgets('Portfolio home page renders hero name', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PortfolioApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining(ProfileData.name), findsWidgets);
  });
}
