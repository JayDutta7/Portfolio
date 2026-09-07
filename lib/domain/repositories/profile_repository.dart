import '../models/profile_models.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
}
