import '../../presentation/viewmodels/locale_viewmodel.dart';
import '../models/profile_models.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile([AppLanguage language = AppLanguage.english]);
}
