import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jayajit_portfolio/core/config/app_environment.dart';
import 'package:jayajit_portfolio/presentation/widgets/common/environment_badge.dart';

void main() {
  group('AppEnvironment Tests', () {
    test('default environment is prod when not specified', () {
      expect(AppEnvironment.current, equals(AppEnvironment.prod));
      expect(AppEnvironment.isProd, isTrue);
      expect(AppEnvironment.isDev, isFalse);
      expect(AppEnvironment.isUat, isFalse);
    });

    test('labels match expected format', () {
      expect(AppEnvironment.dev.label, equals('DEV'));
      expect(AppEnvironment.uat.label, equals('UAT'));
      expect(AppEnvironment.prod.label, equals('PROD'));
    });

    test('dbPrefixes isolate environments properly', () {
      expect(AppEnvironment.prod.dbPrefix, equals('portfolio'));
      expect(AppEnvironment.uat.dbPrefix, equals('portfolio_uat'));
      expect(AppEnvironment.dev.dbPrefix, equals('portfolio_dev'));
    });

    test('colors are distinct for environments', () {
      expect(AppEnvironment.dev.badgeColor, isNot(equals(AppEnvironment.uat.badgeColor)));
      expect(AppEnvironment.uat.badgeColor, isNot(equals(AppEnvironment.prod.badgeColor)));
    });

    testWidgets('EnvironmentBadge hides on production by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                EnvironmentBadge(),
              ],
            ),
          ),
        ),
      );

      // Since default test runner has no --dart-define=APP_ENV, it is prod, so badge should be hidden
      expect(find.byType(EnvironmentBadge), findsOneWidget);
      expect(find.textContaining('ENV:'), findsNothing);
    });
  });
}
