import '../domain/models/profile_models.dart';

class ProfileData {
  ProfileData._();

  static const String name = 'Jayajit Dutta';
  static const String title = 'Senior Mobile Application Developer';
  static const String subtitle = 'Android & Flutter Specialist';
  static const String experienceBadge = '9+ Years Experience';
  static const String location = 'Serampore, West Bengal, India';
  static const String phone = '+91 7980726164';
  static const String email = 'jayajit1989@gmail.com';

  static const String linkedInUrl = 'https://www.linkedin.com/in/jayajit-dutta-7124b9125';
  static const String githubUrl = 'https://github.com/JayDutta7';

  static const String heroIntro =
      'Results-driven Senior Mobile Application Developer with 9+ years of '
      'hands-on experience designing, architecting, and deploying scalable '
      'Native Android (Kotlin, Jetpack Compose) and cross-platform (Flutter) '
      'applications for high-impact enterprise products.';

  static const String aboutMe =
      'I\'m a Senior Mobile Application Developer with over 9 years of '
      'experience building Native Android and cross-platform Flutter '
      'applications end-to-end — from architecture to production release. '
      'My background spans modernizing legacy Java codebases to Kotlin, '
      'improving app runtime performance by up to 20%, and reducing crash '
      'rates through disciplined Clean Architecture and MVVM practices.\n\n'
      'I\'ve led and mentored a 3-developer Agile/Scrum engineering squad, '
      'owning sprint planning, code reviews and on-time delivery, while '
      'partnering closely with product and design teams to ship features '
      'that measurably move user engagement. Recently, I\'ve extended that '
      'expertise into Flutter to deliver cross-platform apps faster without '
      'compromising on native-quality architecture — integrating REST APIs, '
      'Firebase, offline-first data sync and real-time GPS tracking across '
      'enterprise field-operations products.';

  static const String profilePicture = 'assets/images/picture.png';
  static const String resumeAssetPath = 'assets/resume/Jayajit_Dutta_CV.pdf';
  static const String resumeDownloadFileName = 'Jayajit_Dutta_CV.pdf';

  static const String seoTitle = 'Jayajit Dutta | Senior Android & Flutter Developer';
  static const String seoDescription = 'Senior Android & Flutter Developer with 9+ years of experience.';

  static const List<SkillCategory> skillCategories = [
    SkillCategory(title: 'Mobile', iconAsset: 'mobile', skills: ['Kotlin', 'Android', 'Flutter', 'Dart', 'Jetpack Compose']),
    SkillCategory(title: 'Architecture', iconAsset: 'architecture', skills: ['MVVM', 'Clean Architecture', 'Repository Pattern', 'Dependency Injection']),
    SkillCategory(title: 'State Management', iconAsset: 'state', skills: ['Riverpod', 'Provider', 'StateFlow', 'SharedFlow']),
    SkillCategory(title: 'Networking', iconAsset: 'networking', skills: ['Dio', 'Retrofit', 'REST APIs', 'Postman']),
    SkillCategory(title: 'Storage', iconAsset: 'storage', skills: ['Room DB', 'SQLite', 'sqflite', 'ObjectBox']),
    SkillCategory(title: 'Specialized', iconAsset: 'other', skills: ['WorkManager', 'CameraX', 'ML Kit', 'OpenCV', 'Firebase']),
  ];

  static const List<ExperienceItem> experience = [
    ExperienceItem(
      company: 'Shyam Steel Industries Ltd.',
      role: 'Android Developer',
      period: 'Sep 2020 – Present',
      isCurrent: true,
      highlights: [
        'Architected and delivered multiple high-traffic flagship mobile applications, improving overall app runtime performance by 20%.',
        'Spearheaded code migration from legacy Java to modern Kotlin, reducing application crash rates by 20% and improving codebase maintainability.',
        'Led and mentored a 3-developer Agile/Scrum engineering squad, driving sprint planning, code reviews, and on-time delivery.',
      ],
    ),
    ExperienceItem(
      company: 'DCC Services Pvt Ltd.',
      role: 'Associate Consultant',
      period: 'Jan 2020 – Sep 2020',
      highlights: ['Developed customized Android solutions for small-to-medium businesses.'],
    ),
    ExperienceItem(
      company: 'Matrix Media Solution Pvt. Ltd.',
      role: 'Android Developer',
      period: 'Nov 2018 – Dec 2019',
      highlights: ['Engineered third-party REST API integrations and core Android libraries.'],
    ),
  ];

  static const List<Project> projects = [
    Project(
      title: 'Ghareka PMT',
      period: '2025 – Present',
      stackSummary: 'Native Android · Kotlin · Jetpack Compose · Clean Architecture · Room · Retrofit',
      techStack: ['Native Android', 'Kotlin', 'Jetpack Compose', 'Clean Architecture', 'Room', 'Retrofit'],
      overview: 'An enterprise field CRM for project site check-ins, automated check-outs, GPS tracking, and daily attendance management.',
      myRole: 'Sole/lead Android developer responsible for architecture, implementation and delivery.',
      platforms: ['Android'],
      screenshotUrl: 'assets/images/ghareka_pmt.jpeg',
      links: [ProjectLink(label: 'pmt.ghareka.com', url: 'https://pmt.ghareka.com', type: ProjectLinkType.web)],
    ),
    Project(
      title: 'Retail CRM',
      period: '2021 – 2024',
      stackSummary: 'Kotlin · MVVM · Clean Architecture · Room · Retrofit',
      techStack: ['Kotlin', 'MVVM', 'Clean Architecture', 'Room', 'Retrofit'],
      overview: 'A full-scale retail field management app featuring offline data caching & synchronization, dealer check-ins, and GPS workflow automation.',
      myRole: 'Android developer responsible for the offline-first sync architecture and field workflow automation.',
      platforms: ['Android'],
      screenshotUrl: 'assets/images/crm.jpeg',
    ),
    Project(
      title: 'Ghareka Consumer App',
      period: '2025 – Present',
      stackSummary: 'Flutter · Cross-Platform · Riverpod · REST APIs · Firebase',
      techStack: ['Flutter', 'Riverpod', 'Cross-Platform', 'REST APIs', 'Firebase'],
      overview: 'An end-to-end home construction tracking mobile app providing accurate progress updates and timeline tracking for homeowners.',
      myRole: 'Flutter developer building the cross-platform consumer experience, backed by REST APIs and Firebase.',
      platforms: ['Android', 'iOS'],
      screenshotUrl: 'assets/images/ghareka.jpeg',
      links: [
        ProjectLink(label: 'Play Store', url: 'https://play.google.com/store/apps/details?id=com.ghreka.consumerapp', type: ProjectLinkType.playStore),
        ProjectLink(label: 'App Store', url: 'https://apps.apple.com/app/id6467111338', type: ProjectLinkType.appStore),
      ],
    ),
    Project(
      title: 'Pariwar App',
      period: '2024 – 2025',
      stackSummary: 'Flutter · Dart · Riverpod · REST APIs · Firebase Push Notifications',
      techStack: ['Flutter', 'Dart', 'Riverpod', 'REST APIs', 'Firebase Push Notifications'],
      overview: 'A multi-tier distributor & dealer collaboration app with live inventory management, order placement, and reward point tracking.',
      myRole: 'Flutter developer delivering the distributor/dealer facing application and its push-notification driven workflows.',
      platforms: ['Android', 'iOS'],
      screenshotUrl: 'assets/images/pariwar.webp',
      links: [
        ProjectLink(label: 'Play Store', url: 'https://play.google.com/store/apps/details?id=com.shyamsteel.pariwar', type: ProjectLinkType.playStore),
        ProjectLink(label: 'App Store', url: 'https://apps.apple.com/app/id1635952518', type: ProjectLinkType.appStore),
      ],
    ),
    Project(
      title: 'Buildistan',
      period: '2023 – Present',
      stackSummary: 'Flutter · Provider · Clean Architecture',
      techStack: ['Flutter', 'Provider', 'Clean Architecture'],
      overview: 'A procurement marketplace connecting buyers and sellers for streamlined B2B trade management.',
      myRole: 'Flutter developer building the marketplace app with Provider-based state management on a Clean Architecture base.',
      platforms: ['Android', 'iOS'],
      screenshotUrl: 'assets/images/buildistan.jpeg',
      links: [
        ProjectLink(label: 'Play Store', url: 'https://play.google.com/store/apps/details?id=com.buildistan.b2b', type: ProjectLinkType.playStore),
        ProjectLink(label: 'App Store', url: 'https://apps.apple.com/app/id6472875216', type: ProjectLinkType.appStore),
      ],
    ),
    Project(
      title: 'Massage Club',
      period: '2017 – 2019',
      stackSummary: 'Android · Java · MVP',
      techStack: ['Android SDK', 'Java', 'MVP'],
      overview: 'Massage Club app—your ultimate destination for relaxation and rejuvenation!',
      myRole: 'Android developer implementing core booking features.',
      platforms: ['Android'],
      screenshotUrl: 'assets/images/massageclub.png',
      links: [ProjectLink(label: 'Play Store', url: 'https://play.google.com/store/apps/details?id=com.massageclub&hl=en', type: ProjectLinkType.playStore)],
    ),
  ];

  static const List<StatItem> stats = [
    StatItem(value: '9+', label: 'Years Experience'),
    StatItem(value: '2', label: 'Platforms — Android + Flutter'),
    StatItem(value: '10', label: 'Enterprise Applications'),
    StatItem(value: '4', label: 'Companies'),
  ];

  static const List<EducationItem> education = [
    EducationItem(title: 'Master of Computer Applications (MCA)', institution: 'Brainware Group of Institution', period: '2012 – 2015', detail: 'CGPA: 7.23'),
    EducationItem(title: 'Bachelor of Computer Applications (BCA)', institution: 'Meghnad Saha Institute of Technology', period: '2008 – 2011', detail: 'CGPA: 7.21'),
  ];

  static const List<String> flutterArchitecturePipeline = ['Flutter UI', 'MVVM', 'State Management (Riverpod)', 'Repository Layer', 'REST APIs', 'Local Database', 'Firebase', 'Production Application'];
  static const List<String> androidArchitecturePipeline = ['Jetpack Compose UI', 'MVVM', 'Clean Architecture', 'Dependency Injection (Hilt / Koin)', 'Coroutines & Flow', 'Repository Layer', 'Retrofit (REST APIs)', 'Room / SQLite', 'Production Application'];
}
