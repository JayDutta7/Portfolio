import '../../presentation/viewmodels/locale_viewmodel.dart';
import '../models/profile_models.dart';

abstract class ProfileRepository {
  Profile getProfile([AppLanguage language = AppLanguage.english]);
}
