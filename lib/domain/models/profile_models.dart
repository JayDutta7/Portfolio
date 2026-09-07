/// A single job in the work-experience timeline.
class ExperienceItem {
  final String company;
  final String role;
  final String period;
  final List<String> highlights;
  final bool isCurrent;

  const ExperienceItem({
    required this.company,
    required this.role,
    required this.period,
    required this.highlights,
    this.isCurrent = false,
  });
}

/// A group of related technical skills, e.g. "Android", "Flutter".
class SkillCategory {
  final String title;
  final String iconAsset; // material icon name resolved in the UI
  final List<String> skills;

  const SkillCategory({
    required this.title,
    required this.iconAsset,
    required this.skills,
  });
}

/// External link associated with a project (store, web, repo).
class ProjectLink {
  final String label;
  final String url;
  final ProjectLinkType type;

  const ProjectLink({
    required this.label,
    required this.url,
    required this.type,
  });
}

enum ProjectLinkType { playStore, appStore, web, github }

/// A featured project card + its detail view content.
class Project {
  final String title;
  final String period;
  final String stackSummary;
  final List<String> techStack;
  final String overview;
  final String myRole;
  final String? architecture;
  final List<String> keyFeatures;
  final String? technicalChallenge;
  final String? solution;
  final List<String> platforms;
  final List<ProjectLink> links;

  const Project({
    required this.title,
    required this.period,
    required this.stackSummary,
    required this.techStack,
    required this.overview,
    required this.myRole,
    this.architecture,
    this.keyFeatures = const [],
    this.technicalChallenge,
    this.solution,
    this.platforms = const [],
    this.links = const [],
  });
}

/// A degree / certification entry.
class EducationItem {
  final String title;
  final String institution;
  final String period;
  final String? detail; // e.g. CGPA
  final bool isCertification;

  const EducationItem({
    required this.title,
    required this.institution,
    required this.period,
    this.detail,
    this.isCertification = false,
  });
}

/// A single highlighted career statistic.
class StatItem {
  final String value;
  final String label;

  const StatItem({required this.value, required this.label});
}

/// The complete profile data entity.
class Profile {
  final String name;
  final String title;
  final String subtitle;
  final String experienceBadge;
  final String location;
  final String phone;
  final String email;
  final String linkedInUrl;
  final String githubUrl;
  final String heroIntro;
  final String aboutMe;
  final String profilePicture;
  final String resumeAssetPath;
  final String resumeDownloadFileName;
  final String seoTitle;
  final String seoDescription;
  final List<SkillCategory> skillCategories;
  final List<ExperienceItem> experience;
  final List<Project> projects;
  final List<StatItem> stats;
  final List<EducationItem> education;
  final List<String> flutterArchitecturePipeline;
  final List<String> androidArchitecturePipeline;

  const Profile({
    required this.name,
    required this.title,
    required this.subtitle,
    required this.experienceBadge,
    required this.location,
    required this.phone,
    required this.email,
    required this.linkedInUrl,
    required this.githubUrl,
    required this.heroIntro,
    required this.aboutMe,
    required this.profilePicture,
    required this.resumeAssetPath,
    required this.resumeDownloadFileName,
    required this.seoTitle,
    required this.seoDescription,
    required this.skillCategories,
    required this.experience,
    required this.projects,
    required this.stats,
    required this.education,
    required this.flutterArchitecturePipeline,
    required this.androidArchitecturePipeline,
  });
}
