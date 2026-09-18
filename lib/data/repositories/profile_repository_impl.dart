import '../../domain/models/profile_models.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../presentation/viewmodels/locale_viewmodel.dart';
import '../profile_data.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Profile> getProfile([AppLanguage language = AppLanguage.english]) async {
    return ProfileData.getProfile(language);
  }
}
