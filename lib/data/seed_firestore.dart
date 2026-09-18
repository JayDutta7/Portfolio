/// One-time Firestore seed script.
///
/// Reads all data from the existing static [ProfileData] and writes it into
/// Cloud Firestore under the `portfolio/` collection structure.
///
/// Run once from your project root (with credentials in .env):
///
///   dart run lib/data/seed_firestore.dart
///
/// It is safe to re-run — all writes use `set(..., SetOptions(merge: true))`,
/// so no data is duplicated or overwritten unintentionally.
///
/// Document structure after seeding:
///   portfolio/profile/locales/en  ← English profile
///   portfolio/profile/locales/bn  ← Bengali profile
///   portfolio/profile/locales/hi  ← Hindi profile
///   portfolio/projects/items/{0…N} ← One doc per project
///
// ignore_for_file: avoid_print
library seed_firestore;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../core/config/firebase_config.dart';
import '../presentation/viewmodels/locale_viewmodel.dart';
import 'profile_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!FirebaseConfig.isConfigured) {
    print('❌ Firebase not configured. Run with --dart-define-from-file=.env');
    return;
  }

  await Firebase.initializeApp(options: FirebaseConfig.options);
  final db = FirebaseFirestore.instance;

  print('🚀 Starting Firestore seed...\n');

  // ── Seed language profiles ────────────────────────────────────────
  for (final lang in AppLanguage.values) {
    final langCode = switch (lang) {
      AppLanguage.english => 'en',
      AppLanguage.bengali => 'bn',
      AppLanguage.hindi => 'hi',
    };

    final profile = ProfileData.getProfile(lang);
    // Exclude projects from profile doc (they live in their own collection).
    final profileJson = profile.toJson();

    await db
        .collection('portfolio')
        .doc('profile')
        .collection('locales')
        .doc(langCode)
        .set(profileJson, SetOptions(merge: true));

    print('✅ Seeded "$langCode" profile (${profile.title})');
  }

  // ── Seed projects (language-agnostic, shared) ─────────────────────
  final projects = ProfileData.getProfile(AppLanguage.english).projects;
  final batch = db.batch();

  for (int i = 0; i < projects.length; i++) {
    final project = projects[i];
    final docId = i.toString().padLeft(2, '0'); // "00", "01", ... for ordering
    final ref = db
        .collection('portfolio')
        .doc('projects')
        .collection('items')
        .doc(docId);

    batch.set(
      ref,
      {
        ...project.toJson(),
        'order': i, // numeric field for orderBy queries
      },
      SetOptions(merge: true),
    );
  }

  await batch.commit();
  print('✅ Seeded ${projects.length} projects');

  print('\n🎉 Firestore seed complete!');
  print('   You can now edit content directly in the Firebase Console:');
  print('   https://console.firebase.google.com/project/${FirebaseConfig.projectId}/firestore');
}
