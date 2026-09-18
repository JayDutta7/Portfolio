import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jayajit_portfolio/presentation/widgets/hero_avatar/hero_avatar_ring.dart';
import 'package:jayajit_portfolio/presentation/widgets/hero_avatar/orbiting_tech_badges.dart';
import 'package:jayajit_portfolio/presentation/widgets/hero_avatar/pulsing_avatar_hero.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HeroAvatarRing tests', () {
    testWidgets('renders child and responds to hover with 3D tilt scale', (tester) async {
      bool hovered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: HeroAvatarRing(
                size: 200,
                onHoverChanged: (val) => hovered = val,
                child: const Text('AvatarContent'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('AvatarContent'), findsOneWidget);
      expect(hovered, isFalse);

      // Simulate mouse hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(HeroAvatarRing)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(hovered, isTrue);

      // Exit mouse hover
      await gesture.moveTo(const Offset(5, 5));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(hovered, isFalse);
    });
  });

  group('OrbitingTechBadges tests', () {
    testWidgets('renders inner and outer orbit badges with upright counter-rotation', (tester) async {
      final innerBadges = [
        const OrbitBadgeItem(
          name: 'Flutter',
          icon: Icon(Icons.flutter_dash),
          color: Colors.blue,
          glowColor: Colors.blueAccent,
          tooltip: 'Flutter Master',
        ),
        const OrbitBadgeItem(
          name: 'Android',
          icon: Icon(Icons.android),
          color: Colors.green,
          glowColor: Colors.greenAccent,
          tooltip: 'Android Expert',
        ),
      ];

      final outerBadges = [
        const OrbitBadgeItem(
          name: 'Firebase',
          icon: Icon(Icons.local_fire_department),
          color: Colors.amber,
          glowColor: Colors.orange,
          tooltip: 'Firebase Pro',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: OrbitingTechBadges(
                canvasSize: 400,
                innerRadius: 100,
                outerRadius: 150,
                innerBadges: innerBadges,
                outerBadges: outerBadges,
                centerWidget: const Text('CenterAvatar'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('CenterAvatar'), findsOneWidget);
      expect(find.byIcon(Icons.flutter_dash), findsOneWidget);
      expect(find.byIcon(Icons.android), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);

      // Advance animation frames smoothly
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(OrbitingTechBadges), findsOneWidget);
    });
  });

  group('PulsingAvatarHero tests', () {
    testWidgets('renders ripples, backdrop, child, and anchored status badge', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: PulsingAvatarHero(
                avatarRadius: 80,
                accentColor: Color(0xFF06B6D4),
                secondaryColor: Color(0xFF6366F1),
                badge: Text('9+ YRS • Senior Mobile Dev'),
                child: Icon(Icons.person, size: 80),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('9+ YRS • Senior Mobile Dev'), findsOneWidget);

      // Advance animation cycles
      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.byType(PulsingAvatarHero), findsOneWidget);
    });
  });
}
