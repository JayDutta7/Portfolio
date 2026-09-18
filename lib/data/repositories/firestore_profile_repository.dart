import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../core/config/firebase_config.dart';
import '../../domain/models/profile_models.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../presentation/viewmodels/locale_viewmodel.dart';
import '../profile_data.dart';

/// Firestore-backed implementation of [ProfileRepository].
///
/// Fetches profile data from:
///   - `portfolio/profile/{languageCode}` — per-language profile document
///   - `portfolio/projects/{projectId}` — shared project collection
///
/// Falls back to the static [ProfileData] when:
///   - Firebase is not configured (no credentials at compile-time)
///   - A Firestore error occurs (network unavailable, permission denied, etc.)
///
/// Firestore SDK's built-in offline cache ensures instant loads even without
/// a network connection after the first successful fetch.
class FirestoreProfileRepository implements ProfileRepository {
  final FirebaseFirestore _db;

  FirestoreProfileRepository(this._db) {
    // Enable offline persistence (web uses IndexedDB, mobile uses SQLite).
    _db.settings = const Settings(persistenceEnabled: true);
  }

  // ── Language code mapping ────────────────────────────────────────
  static String _langCode(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.bengali:
        return 'bn';
      case AppLanguage.hindi:
        return 'hi';
    }
  }

  // ── Public API ───────────────────────────────────────────────────
  @override
  Future<Profile> getProfile([AppLanguage language = AppLanguage.english]) async {
    if (!FirebaseConfig.isConfigured) {
      debugPrint('[FirestoreProfileRepo] Firebase not configured, using static fallback.');
      return ProfileData.getProfile(language);
    }

    try {
      final langCode = _langCode(language);

      // Run both fetches in parallel for speed.
      final results = await Future.wait([
        _db.collection('portfolio').doc('profile').collection('locales').doc(langCode).get(),
        _db.collection('portfolio').doc('projects').collection('items').orderBy('order').get(),
      ]);

      final profileSnap = results[0] as DocumentSnapshot<Map<String, dynamic>>;
      final projectsSnap = results[1] as QuerySnapshot<Map<String, dynamic>>;

      if (!profileSnap.exists || profileSnap.data() == null) {
        debugPrint('[FirestoreProfileRepo] Profile doc "$langCode" not found, using static fallback.');
        return ProfileData.getProfile(language);
      }

      final projects = projectsSnap.docs
          .map((doc) => Project.fromJson(doc.data()))
          .toList();

      // If no projects in Firestore yet, use static projects as fallback.
      final effectiveProjects = projects.isNotEmpty
          ? projects
          : ProfileData.getProfile(language).projects;

      return Profile.fromJson(profileSnap.data()!, effectiveProjects);
    } catch (e, st) {
      debugPrint('[FirestoreProfileRepo] Error fetching from Firestore: $e\n$st');
      return ProfileData.getProfile(language);
    }
  }

  // ── Streaming variant (real-time updates) ────────────────────────
  /// Returns a [Stream] that emits a new [Profile] whenever any profile
  /// document changes in Firestore. Useful for live-preview of edits.
  Stream<Profile> profileStream(AppLanguage language) {
    if (!FirebaseConfig.isConfigured) {
      return Stream.value(ProfileData.getProfile(language));
    }

    final langCode = _langCode(language);
    return _db
        .collection('portfolio')
        .doc('profile')
        .collection('locales')
        .doc(langCode)
        .snapshots()
        .asyncMap((snap) async {
      if (!snap.exists || snap.data() == null) {
        return ProfileData.getProfile(language);
      }
      try {
        final projectsSnap = await _db
            .collection('portfolio')
            .doc('projects')
            .collection('items')
            .orderBy('order')
            .get();
        final projects = projectsSnap.docs
            .map((doc) => Project.fromJson(doc.data()))
            .toList();
        final effectiveProjects = projects.isNotEmpty
            ? projects
            : ProfileData.getProfile(language).projects;
        return Profile.fromJson(snap.data()!, effectiveProjects);
      } catch (_) {
        return ProfileData.getProfile(language);
      }
    });
  }
}
