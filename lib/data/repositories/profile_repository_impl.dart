import '../../domain/models/profile_models.dart';
import '../../domain/repositories/profile_repository.dart';
import '../profile_data.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Profile> getProfile() async {
    // Simulating network delay if needed, but for now just returning the hardcoded data
    return const Profile(
      name: ProfileData.name,
      title: ProfileData.title,
      subtitle: ProfileData.subtitle,
      experienceBadge: ProfileData.experienceBadge,
      location: ProfileData.location,
      phone: ProfileData.phone,
      email: ProfileData.email,
      linkedInUrl: ProfileData.linkedInUrl,
      githubUrl: ProfileData.githubUrl,
      heroIntro: ProfileData.heroIntro,
      aboutMe: ProfileData.aboutMe,
      profilePicture: ProfileData.profilePicture,
      resumeAssetPath: ProfileData.resumeAssetPath,
      resumeDownloadFileName: ProfileData.resumeDownloadFileName,
      seoTitle: ProfileData.seoTitle,
      seoDescription: ProfileData.seoDescription,
      skillCategories: ProfileData.skillCategories,
      experience: ProfileData.experience,
      projects: ProfileData.projects,
      stats: ProfileData.stats,
      education: ProfileData.education,
      flutterArchitecturePipeline: ProfileData.flutterArchitecturePipeline,
      androidArchitecturePipeline: ProfileData.androidArchitecturePipeline,
    );
  }
}
