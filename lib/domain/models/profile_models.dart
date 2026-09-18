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

  factory ExperienceItem.fromJson(Map<String, dynamic> json) => ExperienceItem(
        company: json['company'] as String? ?? '',
        role: json['role'] as String? ?? '',
        period: json['period'] as String? ?? '',
        highlights: List<String>.from(json['highlights'] as List? ?? []),
        isCurrent: json['isCurrent'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'company': company,
        'role': role,
        'period': period,
        'highlights': highlights,
        'isCurrent': isCurrent,
      };
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

  factory SkillCategory.fromJson(Map<String, dynamic> json) => SkillCategory(
        title: json['title'] as String? ?? '',
        iconAsset: json['iconAsset'] as String? ?? '',
        skills: List<String>.from(json['skills'] as List? ?? []),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'iconAsset': iconAsset,
        'skills': skills,
      };
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

  factory ProjectLink.fromJson(Map<String, dynamic> json) => ProjectLink(
        label: json['label'] as String? ?? '',
        url: json['url'] as String? ?? '',
        type: ProjectLinkType.values.firstWhere(
          (e) => e.name == (json['type'] as String? ?? 'web'),
          orElse: () => ProjectLinkType.web,
        ),
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'url': url,
        'type': type.name,
      };
}

enum ProjectLinkType { playStore, appStore, web, github }
enum ProjectCategory { shyamSteel, clientSolutions }

/// A featured project card + its detail view content.
class Project {
  final String title;
  final String period;
  final String company;
  final ProjectCategory category;
  final String stackSummary;
  final List<String> techStack;
  final String overview;
  final String myRole;
  final String? problemScope;
  final String? technicalArchitecture;
  final String? hardChallenges;
  final String? quantifiableImpact;
  final List<String> keyFeatures;
  final List<String> platforms;
  final List<ProjectLink> links;
  final String? screenshotUrl;

  String get effectiveProblemScope =>
      (problemScope != null && problemScope!.isNotEmpty) ? problemScope! : overview;

  String get effectiveTechnicalArchitecture =>
      (technicalArchitecture != null && technicalArchitecture!.isNotEmpty)
          ? technicalArchitecture!
          : overview;

  String get effectiveHardChallenges =>
      (hardChallenges != null && hardChallenges!.isNotEmpty) ? hardChallenges! : '';

  String get effectiveQuantifiableImpact =>
      (quantifiableImpact != null && quantifiableImpact!.isNotEmpty)
          ? quantifiableImpact!
          : '';

  // Backwards compatibility getters
  String? get architecture => technicalArchitecture;
  String? get technicalChallenge => hardChallenges;
  String? get solution => quantifiableImpact;

  const Project({
    required this.title,
    required this.period,
    this.company = 'Shyam Steel',
    this.category = ProjectCategory.shyamSteel,
    required this.stackSummary,
    required this.techStack,
    required this.overview,
    required this.myRole,
    this.problemScope,
    this.technicalArchitecture,
    this.hardChallenges,
    this.quantifiableImpact,
    this.keyFeatures = const [],
    this.platforms = const [],
    this.links = const [],
    this.screenshotUrl,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        title: json['title'] as String? ?? '',
        period: json['period'] as String? ?? '',
        company: json['company'] as String? ?? 'Shyam Steel',
        category: ProjectCategory.values.firstWhere(
          (e) => e.name == (json['category'] as String? ?? 'shyamSteel'),
          orElse: () => ProjectCategory.shyamSteel,
        ),
        stackSummary: json['stackSummary'] as String? ?? '',
        techStack: List<String>.from(json['techStack'] as List? ?? []),
        overview: json['overview'] as String? ?? '',
        myRole: json['myRole'] as String? ?? '',
        problemScope: json['problemScope'] as String?,
        technicalArchitecture: json['technicalArchitecture'] as String?,
        hardChallenges: json['hardChallenges'] as String?,
        quantifiableImpact: json['quantifiableImpact'] as String?,
        keyFeatures: List<String>.from(json['keyFeatures'] as List? ?? []),
        platforms: List<String>.from(json['platforms'] as List? ?? []),
        links: (json['links'] as List? ?? [])
            .map((l) => ProjectLink.fromJson(l as Map<String, dynamic>))
            .toList(),
        screenshotUrl: json['screenshotUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'period': period,
        'company': company,
        'category': category.name,
        'stackSummary': stackSummary,
        'techStack': techStack,
        'overview': overview,
        'myRole': myRole,
        if (problemScope != null) 'problemScope': problemScope,
        if (technicalArchitecture != null) 'technicalArchitecture': technicalArchitecture,
        if (hardChallenges != null) 'hardChallenges': hardChallenges,
        if (quantifiableImpact != null) 'quantifiableImpact': quantifiableImpact,
        'keyFeatures': keyFeatures,
        'platforms': platforms,
        'links': links.map((l) => l.toJson()).toList(),
        if (screenshotUrl != null) 'screenshotUrl': screenshotUrl,
      };
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

  factory EducationItem.fromJson(Map<String, dynamic> json) => EducationItem(
        title: json['title'] as String? ?? '',
        institution: json['institution'] as String? ?? '',
        period: json['period'] as String? ?? '',
        detail: json['detail'] as String?,
        isCertification: json['isCertification'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'institution': institution,
        'period': period,
        if (detail != null) 'detail': detail,
        'isCertification': isCertification,
      };
}

/// A single highlighted career statistic.
class StatItem {
  final String value;
  final String label;

  const StatItem({required this.value, required this.label});

  factory StatItem.fromJson(Map<String, dynamic> json) => StatItem(
        value: json['value'] as String? ?? '',
        label: json['label'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'value': value, 'label': label};
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

  factory Profile.fromJson(
    Map<String, dynamic> profileDoc,
    List<Project> projects,
  ) =>
      Profile(
        name: profileDoc['name'] as String? ?? '',
        title: profileDoc['title'] as String? ?? '',
        subtitle: profileDoc['subtitle'] as String? ?? '',
        experienceBadge: profileDoc['experienceBadge'] as String? ?? '',
        location: profileDoc['location'] as String? ?? '',
        phone: profileDoc['phone'] as String? ?? '',
        email: profileDoc['email'] as String? ?? '',
        linkedInUrl: profileDoc['linkedInUrl'] as String? ?? '',
        githubUrl: profileDoc['githubUrl'] as String? ?? '',
        heroIntro: profileDoc['heroIntro'] as String? ?? '',
        aboutMe: profileDoc['aboutMe'] as String? ?? '',
        profilePicture: profileDoc['profilePicture'] as String? ?? '',
        resumeAssetPath: profileDoc['resumeAssetPath'] as String? ?? '',
        resumeDownloadFileName: profileDoc['resumeDownloadFileName'] as String? ?? '',
        seoTitle: profileDoc['seoTitle'] as String? ?? '',
        seoDescription: profileDoc['seoDescription'] as String? ?? '',
        skillCategories: (profileDoc['skillCategories'] as List? ?? [])
            .map((s) => SkillCategory.fromJson(s as Map<String, dynamic>))
            .toList(),
        experience: (profileDoc['experience'] as List? ?? [])
            .map((e) => ExperienceItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        projects: projects,
        stats: (profileDoc['stats'] as List? ?? [])
            .map((s) => StatItem.fromJson(s as Map<String, dynamic>))
            .toList(),
        education: (profileDoc['education'] as List? ?? [])
            .map((e) => EducationItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        flutterArchitecturePipeline:
            List<String>.from(profileDoc['flutterArchitecturePipeline'] as List? ?? []),
        androidArchitecturePipeline:
            List<String>.from(profileDoc['androidArchitecturePipeline'] as List? ?? []),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'subtitle': subtitle,
        'experienceBadge': experienceBadge,
        'location': location,
        'phone': phone,
        'email': email,
        'linkedInUrl': linkedInUrl,
        'githubUrl': githubUrl,
        'heroIntro': heroIntro,
        'aboutMe': aboutMe,
        'profilePicture': profilePicture,
        'resumeAssetPath': resumeAssetPath,
        'resumeDownloadFileName': resumeDownloadFileName,
        'seoTitle': seoTitle,
        'seoDescription': seoDescription,
        'skillCategories': skillCategories.map((s) => s.toJson()).toList(),
        'experience': experience.map((e) => e.toJson()).toList(),
        'stats': stats.map((s) => s.toJson()).toList(),
        'education': education.map((e) => e.toJson()).toList(),
        'flutterArchitecturePipeline': flutterArchitecturePipeline,
        'androidArchitecturePipeline': androidArchitecturePipeline,
      };
}
