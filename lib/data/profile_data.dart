import '../domain/models/profile_models.dart';

/// ---------------------------------------------------------------------
/// SINGLE SOURCE OF TRUTH for all personal / resume content.
///
/// Edit ONLY this file to update the site's content — no UI code needs
/// to change. Every value below is taken directly from
/// `Jayajit_Dutta_CV.pdf`. Placeholders are clearly marked with
/// "TODO:" and must be filled in before the links will work.
/// ---------------------------------------------------------------------
class ProfileData {
  ProfileData._();

  // ---- Identity -------------------------------------------------------
  static const String name = 'Jayajit Dutta';
  static const String title = 'Senior Mobile Application Developer';
  static const String subtitle = 'Android & Flutter Specialist';
  static const String experienceBadge = '9+ Years Experience';
  static const String location = 'Serampore, West Bengal, India';
  static const String phone = '+91 7980726164';
  static const String email = 'jayajit1989@gmail.com';

  // TODO: Replace with your real profile URLs.
  static const String linkedInUrl = 'www.linkedin.com/in/jayajit-dutta-7124b9125';
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

  // ---- Resume file ------------------------------------------------------
  static const String resumeAssetPath = 'assets/resume/Jayajit_Dutta_CV.pdf';
  static const String resumeDownloadFileName = 'Jayajit_Dutta_CV.pdf';

  // ---- SEO ----------------------------------------------------------
  static const String seoTitle =
      'Jayajit Dutta | Senior Android & Flutter Developer';
  static const String seoDescription =
      'Senior Android & Flutter Developer with 9+ years of experience '
      'building scalable mobile and cross-platform applications using '
      'Kotlin, Jetpack Compose, Flutter and Clean Architecture.';

  // ---- Skills ---------------------------------------------------------
  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      title: 'Android',
      iconAsset: 'android',
      skills: [
        'Kotlin',
        'Java',
        'Android SDK',
        'Jetpack Compose',
        'Coroutines',
        'Flow',
        'MVVM',
        'Clean Architecture',
        'Dagger-Hilt',
        'Koin',
      ],
    ),
    SkillCategory(
      title: 'Flutter',
      iconAsset: 'flutter',
      skills: [
        'Flutter',
        'Dart',
        'REST APIs',
        'Firebase',
        'Riverpod',
        'Provider',
        'Cross-platform development',
      ],
    ),
    SkillCategory(
      title: 'Database',
      iconAsset: 'database',
      skills: [
        'Room DB',
        'SQLite',
        'Firebase Realtime Database',
        'Shared Preferences',
        'EncryptedSharedPreferences',
      ],
    ),
    SkillCategory(
      title: 'Networking & Tools',
      iconAsset: 'tools',
      skills: [
        'Retrofit',
        'RESTful APIs',
        'Git',
        'GitHub',
        'Bitbucket',
        'Postman',
        'Android Studio',
        'Linear',
      ],
    ),
    SkillCategory(
      title: 'Other',
      iconAsset: 'other',
      skills: [
        'GPS & Location Tracking',
        'Material Design 3',
        'CI/CD Pipelines',
        'Agile / Scrum',
      ],
    ),
  ];

  // ---- Experience -------------------------------------------------------
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
        'Integrated complex RESTful APIs, background push notifications, and real-time GPS location tracking for field workforce operations.',
        'Partnered closely with UI/UX designers to implement modern Material Design components, driving a 15% increase in user engagement.',
      ],
    ),
    ExperienceItem(
      company: 'DCC Services Pvt Ltd.',
      role: 'Associate Consultant',
      period: 'Jan 2020 – Sep 2020',
      highlights: [
        'Developed customized Android solutions for small-to-medium businesses, focusing on intuitive navigation and responsive layout rendering.',
        'Collaborated with product managers to transform functional requirements into reliable UI components with reduced memory footprint.',
      ],
    ),
    ExperienceItem(
      company: 'Matrix Media Solution Pvt. Ltd.',
      role: 'Android Developer',
      period: 'Nov 2018 – Dec 2019',
      highlights: [
        'Engineered third-party REST API integrations and core Android libraries across diverse Android OS versions and hardware form factors.',
        'Optimized application execution speed and minimized memory leaks across low-to-mid range mobile hardware models.',
      ],
    ),
    ExperienceItem(
      company: 'Natit Solved Pvt Ltd.',
      role: 'Junior Android Developer',
      period: 'Apr 2017 – Nov 2018',
      highlights: [
        'Resolved critical production bugs, refined layout UI performance, and contributed to continuous app build testing.',
      ],
    ),
  ];

  // ---- Projects -----------------------------------------------------
  static const List<Project> projects = [
    Project(
      title: 'Ghareka PMT',
      period: '2025 – Present',
      stackSummary:
          'Native Android · Kotlin · Jetpack Compose · Clean Architecture · Room · Retrofit',
      techStack: [
        'Native Android',
        'Kotlin',
        'Jetpack Compose',
        'Clean Architecture',
        'Room',
        'Retrofit',
      ],
      overview:
          'An enterprise field CRM for project site check-ins, automated '
          'check-outs, GPS tracking, and daily attendance management.',
      myRole:
          'Sole/lead Android developer responsible for architecture, '
          'implementation and delivery.',
      architecture: 'Clean Architecture with Jetpack Compose UI layer, '
          'Room for local persistence and Retrofit for API integration.',
      keyFeatures: [
        'Automated project site check-in / check-out',
        'Real-time GPS tracking for field workforce',
        'Daily attendance management',
      ],
      platforms: ['Android'],
      links: [
        ProjectLink(
          label: 'pmt.ghareka.com',
          url: 'https://pmt.ghareka.com',
          type: ProjectLinkType.web,
        ),
      ],
    ),
    Project(
      title: 'Ghareka Consumer App',
      period: '2025 – Present',
      stackSummary: 'Flutter · Cross-Platform · Riverpod · REST APIs · Firebase',
      techStack: ['Flutter', 'Riverpod', 'Cross-Platform', 'REST APIs', 'Firebase'],
      overview:
          'An end-to-end home construction tracking mobile app providing '
          'accurate progress updates and timeline tracking for homeowners.',
      myRole: 'Flutter developer building the cross-platform consumer '
          'experience, backed by REST APIs and Firebase.',
      keyFeatures: [
        'Real-time construction progress updates',
        'Timeline tracking for homeowners',
      ],
      platforms: ['Android', 'iOS'],
      links: [
        ProjectLink(
          label: 'Play Store',
          url:
              'https://play.google.com/store/apps/details?id=com.ghreka.consumerapp',
          type: ProjectLinkType.playStore,
        ),
        ProjectLink(
          label: 'App Store',
          url: 'https://apps.apple.com/app/id6467111338',
          type: ProjectLinkType.appStore,
        ),
      ],
    ),
    Project(
      title: 'Pariwar App',
      period: '2024 – 2025',
      stackSummary: 'Flutter · Dart · Riverpod · REST APIs · Firebase Push Notifications',
      techStack: [
        'Flutter',
        'Dart',
        'Riverpod',
        'REST APIs',
        'Firebase Push Notifications',
      ],
      overview:
          'A multi-tier distributor & dealer collaboration app with live '
          'inventory management, order placement, and reward point tracking.',
      myRole: 'Flutter developer delivering the distributor/dealer facing '
          'application and its push-notification driven workflows.',
      keyFeatures: [
        'Live inventory management',
        'Order placement workflow',
        'Reward point tracking',
        'Firebase push notifications',
      ],
      platforms: ['Android', 'iOS'],
      links: [
        ProjectLink(
          label: 'Play Store',
          url:
              'https://play.google.com/store/apps/details?id=com.shyamsteel.pariwar',
          type: ProjectLinkType.playStore,
        ),
        ProjectLink(
          label: 'App Store',
          url: 'https://apps.apple.com/app/id1635952518',
          type: ProjectLinkType.appStore,
        ),
      ],
    ),
    Project(
      title: 'Retail CRM',
      period: '2021 – 2024',
      stackSummary: 'Kotlin · MVVM · Clean Architecture · Room · Retrofit',
      techStack: [
        'Kotlin',
        'MVVM',
        'Clean Architecture',
        'Room',
        'Retrofit',
      ],
      overview:
          'A full-scale retail field management app featuring offline data '
          'caching & synchronization, dealer check-ins, and GPS workflow '
          'automation.',
      myRole: 'Android developer responsible for the offline-first sync '
          'architecture and field workflow automation.',
      architecture:
          'MVVM with a Clean Architecture layering; Room used as the '
          'offline cache with background synchronization against REST APIs.',
      keyFeatures: [
        'Offline-first data caching & synchronization',
        'Dealer check-in workflow',
        'GPS-based workflow automation',
      ],
      technicalChallenge:
          'Keeping field data reliable and consistent when devices operate '
          'with intermittent or no network connectivity.',
      solution:
          'Implemented an offline-first caching layer with Room and a '
          'background synchronization strategy against the Retrofit-backed '
          'API layer.',
      platforms: ['Android'],
    ),
    Project(
      title: 'Buildistan',
      period: '2023 – Present',
      stackSummary: 'Flutter · Provider · Clean Architecture',
      techStack: ['Flutter', 'Provider', 'Clean Architecture'],
      overview:
          'A procurement marketplace connecting buyers and sellers for '
          'streamlined B2B trade management.',
      myRole: 'Flutter developer building the marketplace app with '
          'Provider-based state management on a Clean Architecture base.',
      keyFeatures: [
        'Buyer/seller procurement marketplace',
        'B2B trade management workflow',
      ],
      platforms: ['Android', 'iOS'],
      links: [
        ProjectLink(
          label: 'Play Store',
          url:
              'https://play.google.com/store/apps/details?id=com.buildistan.b2b',
          type: ProjectLinkType.playStore,
        ),
        ProjectLink(
          label: 'App Store',
          url: 'https://apps.apple.com/app/id6472875216',
          type: ProjectLinkType.appStore,
        ),
      ],
    ),
    Project(
      title: 'Staffer',
      period: '2018 – 2019',
      stackSummary: 'Android · Java · MVC',
      techStack: ['Android SDK', 'Java', 'MVC'],
      overview: 'Staffer is your go-to application for connecting job seekers '
          'with employers in a seamless and efficient manner. Designed for '
          'both candidates and hiring managers, our app streamlines the job '
          'search and recruitment process.',
      myRole: 'Android developer responsible for feature implementation and '
          'MVC architecture alignment.',
      platforms: ['Android'],
    ),
    Project(
      title: 'Massage Club',
      period: '2017 – 2019',
      stackSummary: 'Android · Java · MVP',
      techStack: ['Android SDK', 'Java', 'MVP'],
      overview: 'Massage Club app—your ultimate destination for relaxation '
          'and rejuvenation! Our app connects you with top-rated massage '
          'therapists and wellness centers, making it easy to book your '
          'next session at the touch of a button.',
      myRole: 'Android developer implementing core booking features and '
          'maintaining the MVP architectural pattern.',
      platforms: ['Android'],
      links: [
        ProjectLink(
          label: 'Play Store',
          url: 'https://play.google.com/store/apps/details?id=com.massageclub&hl=en',
          type: ProjectLinkType.playStore,
        ),
      ],
    ),
    Project(
      title: 'Captain Logistic',
      period: '2017 – 2019',
      stackSummary: 'Android · Java · MVC',
      techStack: ['Android SDK', 'Java', 'MVC'],
      overview: 'A reliable and convenient taxi booking app for instant or '
          'scheduled rides. Enjoy real-time tracking, multiple vehicle '
          'options, fare estimates, secure payments, and easy access to ride '
          'history—all in just a few taps.',
      myRole: 'Android developer focused on real-time tracking and '
          'booking workflows for both User and Driver applications.',
      platforms: ['Android'],
    ),
  ];

  // ---- Career statistics ---------------------------------------------
  static const List<StatItem> stats = [
    StatItem(value: '9+', label: 'Years Experience'),
    StatItem(value: '2', label: 'Platforms — Android + Flutter'),
    StatItem(value: '8', label: 'Enterprise Applications'),
    StatItem(value: '4', label: 'Companies'),
  ];

  // ---- Education ------------------------------------------------------
  static const List<EducationItem> education = [
    EducationItem(
      title: 'Master of Computer Applications (MCA)',
      institution: 'Brainware Group of Institution',
      period: '2012 – 2015',
      detail: 'CGPA: 7.23',
    ),
    EducationItem(
      title: 'Bachelor of Computer Applications (BCA)',
      institution: 'Meghnad Saha Institute of Technology',
      period: '2008 – 2011',
      detail: 'CGPA: 7.21',
    ),
    EducationItem(
      title: 'Professional Android Developer',
      institution: 'Ejob India',
      period: '2016 – 2017',
      isCertification: true,
    ),
  ];

  // ---- Architecture pipeline visualizations --------------------------
  static const List<String> flutterArchitecturePipeline = [
    'Flutter UI',
    'MVVM / Clean Architecture',
    'State Management (Riverpod / Provider)',
    'Repository Layer',
    'REST APIs',
    'Local Database',
    'Firebase',
    'Production Application',
  ];

  static const List<String> androidArchitecturePipeline = [
    'Jetpack Compose UI',
    'MVVM / Clean Architecture',
    'Dependency Injection (Hilt / Koin)',
    'Coroutines & Flow',
    'Repository Layer',
    'Retrofit (REST APIs)',
    'Room / SQLite',
    'Production Application',
  ];
}
