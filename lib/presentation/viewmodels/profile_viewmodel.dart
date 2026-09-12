import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/models/profile_models.dart';
import '../../domain/repositories/profile_repository.dart';
import 'locale_viewmodel.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl();
});

final profileViewModelProvider = Provider<Profile>((ref) {
  final language = ref.watch(localeProvider);
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfile(language);
});
