import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/firestore_profile_repository.dart';
import '../../data/profile_data.dart';
import '../../domain/models/profile_models.dart';
import '../../domain/repositories/profile_repository.dart';
import 'locale_viewmodel.dart';

// ── Repository provider ──────────────────────────────────────────────────────

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return FirestoreProfileRepository(FirebaseFirestore.instance);
});

// ── Async profile provider ───────────────────────────────────────────────────

/// Fetches the [Profile] from Firestore (with static fallback).
///
/// Automatically re-fetches when the selected [AppLanguage] changes.
/// Returns an [AsyncValue<Profile>] so the UI can handle loading/error states.
final profileViewModelProvider =
    FutureProvider.autoDispose.family<Profile, AppLanguage>((ref, language) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfile(language);
});

// ── Convenience sync provider ────────────────────────────────────────────────

/// Always returns a [Profile] synchronously — uses cached Firestore data when
/// available, otherwise falls back to the static data. Safe to use in widgets
/// that cannot handle an [AsyncValue].
final profileSyncProvider = Provider<Profile>((ref) {
  final language = ref.watch(localeProvider);
  final async = ref.watch(profileViewModelProvider(language));
  return async.when(
    data: (p) => p,
    loading: () => ProfileData.getProfile(language),
    error: (_, __) => ProfileData.getProfile(language),
  );
});
