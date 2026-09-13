import '../domain/models/profile_models.dart';
import '../presentation/viewmodels/locale_viewmodel.dart';

class ProfileData {
  ProfileData._();

  static const String name = 'Jayajit Dutta';
  static const String phone = '+91 7980726164';
  static const String email = 'jayajit1989@gmail.com';
  static const String linkedInUrl = 'https://www.linkedin.com/in/jayajit-dutta-7124b9125';
  static const String githubUrl = 'https://github.com/JayDutta7';
  static const String profilePicture = 'assets/images/picture.jpg';
  static const String resumeAssetPath = 'assets/resume/Jayajit_Dutta_CV.pdf';
  static const String resumeDownloadFileName = 'Jayajit_Dutta_CV.pdf';
  static const String releaseApkAssetPath = 'assets/apk/JayajitDutta_Portfolio.apk';
  static const String releaseApkFileName = 'JayajitDutta_Portfolio.apk';

  static Profile getProfile(AppLanguage language) {
    switch (language) {
      case AppLanguage.bengali:
        return _bengaliProfile;
      case AppLanguage.hindi:
        return _hindiProfile;
      case AppLanguage.english:
        return _englishProfile;
    }
  }

  // 9 Verified Enterprise & Client Projects with Case Study Architecture
  static const List<Project> _verifiedProjects = [
    // 1. Shyam Steel - Ghareka Consumer App
    Project(
      title: 'Ghareka Consumer App',
      period: '2025 – Present',
      company: 'Shyam Steel Industries Ltd.',
      category: ProjectCategory.shyamSteel,
      stackSummary: 'Flutter · Dart · Riverpod · Clean Architecture · REST APIs · Firebase',
      techStack: [
        'Flutter',
        'Dart',
        'Riverpod',
        'Clean Architecture',
        'Estimation Engine',
        'REST APIs',
        'Firebase FCM',
        'Razorpay',
      ],
      overview:
          'Direct-to-consumer construction procurement application written in Flutter using Riverpod, featuring dynamic structural material estimators, milestone tracking, and secured digital payments.',
      myRole:
          'Lead Flutter Developer responsible for Flutter client architecture, Riverpod state orchestration, and material estimation algorithm.',
      problemScope:
          'Homeowners face opacity and high price variance when sourcing raw construction materials. The product required an intuitive mobile experience capable of calculating accurate structural reinforcement bar quantities based on floor plans while enabling direct-to-consumer order fulfillment.',
      technicalArchitecture:
          'Written in Flutter using Riverpod state management and Clean Architecture. Implemented an algorithmic material estimation engine that computes load-bearing steel requirements with zero UI thread jank, paired with resilient Dio interceptors and Firebase cloud messaging.',
      hardChallenges:
          'Executing complex geometric material calculations concurrently without dropping frames on budget Android devices. Solved by offloading heavy bar-bending mathematical matrix operations to Dart background Isolates, maintaining a sustained 60 FPS.',
      quantifiableImpact:
          'Reduced customer pre-sales inquiries by 40% and increased direct-to-consumer material bookings by 35% within the first two quarters.',
      platforms: ['Android', 'iOS'],
      screenshotUrl: 'assets/images/ghareka.jpeg',
      links: [
        ProjectLink(
          label: 'Play Store',
          url: 'https://play.google.com/store/apps/details?id=com.ghreka.consumerapp',
          type: ProjectLinkType.playStore,
        ),
        ProjectLink(
          label: 'App Store',
          url: 'https://apps.apple.com/app/id6467111338',
          type: ProjectLinkType.appStore,
        ),
      ],
    ),

    // 2. Shyam Steel - Ghareka PMT
    Project(
      title: 'Ghareka PMT',
      period: '2025 – Present',
      company: 'Shyam Steel Industries Ltd.',
      category: ProjectCategory.shyamSteel,
      stackSummary: 'Native Android · Kotlin · Jetpack Compose · Clean Arch · Room · WorkManager',
      techStack: [
        'Android SDK',
        'Kotlin',
        'Jetpack Compose',
        'Clean Architecture',
        'Room DB',
        'Coroutines/Flow',
        'WorkManager',
        'Retrofit',
      ],
      overview:
          'Enterprise field project management tool for civil site engineers, featuring offline inspection logs, automated GPS site check-ins, and photographic milestone validations.',
      myRole:
          'Principal Native Android Architect owning 100% Jetpack Compose UI architecture, offline-first Room data persistence, and background sync pipelines.',
      problemScope:
          'Construction sites operate in high-interference or zero-connectivity cellular dead zones. Site supervisors needed an infallible mobile tool to capture complex engineering inspection logs, safety audits, and photo evidence without losing data during connectivity loss.',
      technicalArchitecture:
          'Single-Activity architecture built with declarative Jetpack Compose and MVI/MVVM. Room SQLite database serves as the single source of truth (SSOT). Background synchronization is managed via Android Jetpack WorkManager with exponential backoff and battery/network constraints.',
      hardChallenges:
          'Eliminating concurrent write race conditions and memory leaks when capturing 10+ high-resolution site progress photos in low-RAM field devices. Solved via scoped Coroutines, asynchronous bitmap compression, and multi-table atomic Room transactions.',
      quantifiableImpact:
          '100% elimination of paper inspection logs, zero data loss reports across 500+ active enterprise project sites, and 25% faster site clearance turnaround.',
      platforms: ['Android'],
      screenshotUrl: 'assets/images/ghareka_pmt.jpeg',
      links: [
        ProjectLink(
          label: 'pmt.ghareka.com',
          url: 'https://pmt.ghareka.com',
          type: ProjectLinkType.web,
        ),
      ],
    ),

    // 3. Shyam Steel - Retail CRM
    Project(
      title: 'Retail CRM',
      period: '2021 – 2024',
      company: 'Shyam Steel Industries Ltd.',
      category: ProjectCategory.shyamSteel,
      stackSummary: 'Native Android · Kotlin · MVVM · Clean Arch · Room · WorkManager · Background GPS',
      techStack: [
        'Android SDK',
        'Kotlin',
        'MVVM',
        'Clean Architecture',
        'Room DB',
        'WorkManager',
        'RxJava',
        'Coroutines',
        'Foreground Services',
        'FusedLocationProvider',
      ],
      overview:
          'Full-scale retail field sales force automation app featuring offline data caching & synchronization, dealer check-ins, and battery-optimized GPS workflow automation.',
      myRole:
          'Lead Android Developer responsible for offline-first sync architecture, geo-fenced visit validation, and battery-optimized background route telemetry.',
      problemScope:
          'A distributed sales force of hundreds of field executives required automated verification of physical dealer visits and real-time order bookings across rural retail corridors with patchy network coverage.',
      technicalArchitecture:
          'Tiered Clean Architecture leveraging Room DB, Kotlin Coroutines, and RxJava event streaming. Designed an adaptive background geolocation service that shifts GPS polling frequency based on accelerometer activity and geofence proximity.',
      hardChallenges:
          'Preventing aggressive OEM battery-killing algorithms (Xiaomi, Samsung, Oppo) from terminating background location tracking while keeping 8-hour shift battery drain under 4%. Solved via high-priority Foreground Services with persistent notification channels and batch sensor buffering.',
      quantifiableImpact:
          'Boosted daily dealer visit compliance by 45%, reduced battery consumption by 38% compared to legacy tracking, and processed over ₹100M+ in quarterly dealer orders.',
      platforms: ['Android'],
      screenshotUrl: 'assets/images/crm.jpeg',
    ),

    // 4. Shyam Steel - Buildistan
    Project(
      title: 'Buildistan',
      period: '2023 – Present',
      company: 'Shyam Steel Industries Ltd.',
      category: ProjectCategory.shyamSteel,
      stackSummary: 'Flutter · Dart · BLoC · Clean Architecture · Multi-Vendor Cart · Easebuzz Gateway',
      techStack: [
        'Flutter',
        'Dart',
        'BLoC',
        'Clean Architecture',
        'Multi-Vendor Cart',
        'Easebuzz Payment Gateway',
        'REST APIs',
        'Dio',
        'B2B Marketplace',
      ],
      overview:
          'High-throughput B2B building materials procurement marketplace connecting bulk contractors, suppliers, and distributors with dynamic multi-vendor cart management and secure Easebuzz payment gateway processing.',
      myRole:
          'Senior Flutter Engineer leading cross-platform client development, multi-vendor cart state machines, Easebuzz payment checkout flows, and real-time trade quotation workflows.',
      problemScope:
          'B2B building procurement entails complex purchasing rules: tiered volume pricing, split distributor shipments, credit limit approvals, instant GST invoices, and secure digital payments that standard e-commerce architectures cannot support.',
      technicalArchitecture:
          'Clean Architecture with BLoC (Business Logic Component) pattern. Integrated Easebuzz payment gateway with secure server-to-server webhook reconciliation and cryptographic payment hash verification. Event-driven multi-vendor cart state machine with optimistic UI reconciliation, persistent local cart caching via SQLite, and robust Dio network interceptors with token auto-refresh.',
      hardChallenges:
          'Handling atomic state updates across complex multi-vendor order splits with distinct delivery lead-times, while managing asynchronous Easebuzz payment gateway callbacks, webhook retries, and transaction settlement without double-charge risk or state drift. Solved with immutable event-driven BLoC state streams and sequential event transformers.',
      quantifiableImpact:
          '5K+ downloads, 99.9% crash-free sessions across Android and iOS, and processing over 1,500 daily bulk B2B construction material RFQs and digital transactions via Easebuzz.',
      platforms: ['Android', 'iOS'],
      screenshotUrl: 'assets/images/buildistan.jpeg',
      links: [
        ProjectLink(
          label: 'Play Store',
          url: 'https://play.google.com/store/apps/details?id=com.buildistan.b2b',
          type: ProjectLinkType.playStore,
        ),
        ProjectLink(
          label: 'App Store',
          url: 'https://apps.apple.com/app/id6472875216',
          type: ProjectLinkType.appStore,
        ),
      ],
    ),

    // 5. Shyam Steel - Pariwar
    Project(
      title: 'Pariwar',
      period: '2024 – 2025',
      company: 'Shyam Steel Industries Ltd.',
      category: ProjectCategory.shyamSteel,
      stackSummary: 'Flutter · Dart · Riverpod · Barcode & QR Scanner · ML Kit · HMAC Fraud Engine',
      techStack: [
        'Flutter',
        'Dart',
        'Riverpod',
        'Barcode & QR Scanning',
        'CameraX / ML Kit',
        'Method Channels',
        'HMAC Cryptography',
        'Offline Ledger',
        'Firebase Push',
      ],
      overview:
          'Trade partner loyalty rewards application written in Flutter using Riverpod, featuring high-speed industrial barcode & QR coupon scanning on steel bundles, cryptographic fraud prevention, and instant reward redemption.',
      myRole:
          'Senior Flutter Engineer delivering the partner engagement client using Riverpod, barcode & QR coupon scanning, and cryptographic fraud detection engine.',
      problemScope:
          'Fabricators, masons, and trade partners scan 1D barcodes and 2D QR coupons printed on industrial steel bundles in outdoor stockyards. The app required millisecond barcode/QR scan recognition under glare, poor lighting, and dirty labels, while preventing coupon replay attacks.',
      technicalArchitecture:
          'Written in Flutter using Riverpod state management. Integrated Google ML Kit Barcode Scanning API with hardware-accelerated autofocus, HMAC-SHA256 signature verification on coupons, and an offline-first transactional ledger.',
      hardChallenges:
          'Mitigating counterfeit coupon injection and replay attacks in remote yards without internet connectivity. Solved by storing encrypted rolling nonces in SQLCipher and verifying cryptographic barcode hashes locally before queueing atomic sync.',
      quantifiableImpact:
          'Achieved a 4.5★ rating with 5K+ downloads, 100,000+ barcodes and QR coupons scanned monthly with 0 fraud incidents, and reduced scanning latency from 1.8s to 120ms.',
      platforms: ['Android', 'iOS'],
      screenshotUrl: 'assets/images/pariwar.webp',
      links: [
        ProjectLink(
          label: 'Play Store',
          url: 'https://play.google.com/store/apps/details?id=com.shyamsteel.pariwar',
          type: ProjectLinkType.playStore,
        ),
        ProjectLink(
          label: 'App Store',
          url: 'https://apps.apple.com/app/id1635952518',
          type: ProjectLinkType.appStore,
        ),
      ],
    ),

    // 6. Nat IT Solved - Captain Logistics
    Project(
      title: 'Captain Logistics',
      period: '2022 – 2024',
      company: 'Nat IT Solved Pvt. Ltd.',
      category: ProjectCategory.clientSolutions,
      stackSummary: 'Native Android · Kotlin · MVVM · LiveData · WebSockets · Google Maps SDK · Foreground Telemetry',
      techStack: [
        'Native Android',
        'Kotlin',
        'MVVM',
        'LiveData',
        'WebSockets',
        'Google Maps SDK',
        'FusedLocationProvider',
        'Foreground Services',
        'Coroutines & Flow',
        'Room DB',
      ],
      overview:
          'Enterprise fleet logistics and supply chain Android application enabling live WebSocket GPS telemetry, automated driver dispatch, and real-time route tracking.',
      myRole:
          'Lead Android Developer architecting the real-time WebSocket telemetry pipeline, MVVM state flows with LiveData, custom Google Maps overlay rendering, and driver dispatch UX.',
      problemScope:
          'Commercial fleet operators required sub-second vehicle telemetry tracking, geo-fenced arrival notifications, and live traffic turn-by-turn routing for delivery drivers concurrently in challenging connectivity environments.',
      technicalArchitecture:
          'Clean Architecture and MVVM pattern utilizing LiveData for lifecycle-safe reactive UI updates. High-throughput WebSocket streams combined with an Android Foreground Service gathering continuous GPS breadcrumbs and buffering points locally in Room DB.',
      hardChallenges:
          'Rendering hundreds of dynamically updating vehicle markers, route polylines, and geofence polygons on lower-tier Android hardware without dropping below 60 FPS or causing memory leaks in location callbacks.',
      quantifiableImpact:
          'Achieved sub-200ms telemetry latency, decreased fleet idle time by 30%, and delivered 99.8% operational uptime during high-volume peak logistics dispatches.',
      platforms: ['Android'],
      screenshotUrl: null,
      links: [
        ProjectLink(
          label: 'GitHub',
          url: 'https://github.com/JayDutta7',
          type: ProjectLinkType.github,
        ),
      ],
    ),

    // 7. Nat IT Solved - Message Club
    Project(
      title: 'Message Club',
      period: '2017 – 2019',
      company: 'Nat IT Solved Pvt. Ltd.',
      category: ProjectCategory.clientSolutions,
      stackSummary: 'Native Android · Kotlin · MVVM · LiveData · Room DB · Retrofit · FCM Batch Dispatch',
      techStack: [
        'Native Android',
        'Kotlin',
        'MVVM',
        'LiveData',
        'Room DB',
        'Retrofit',
        'WorkManager',
        'Firebase FCM',
        'Coroutines',
      ],
      overview:
          'High-throughput broadcast SMS and CRM messaging Android application engineered to deliver multi-channel notification campaigns, transactional alerts, and customer engagement communications.',
      myRole:
          'Android Application Developer implementing the MVVM architecture with LiveData, asynchronous batch dispatch pipeline, local Room DB message deduplication engine, and campaign preview UI.',
      problemScope:
          'Enterprise organizations needed to broadcast millions of time-sensitive transactional and marketing alerts simultaneously without message starvation, thread locks, or notification delivery failure.',
      technicalArchitecture:
          'Clean Architecture with MVVM and Android Architecture Components (LiveData, ViewModel). Integrated Room DB for prioritized message queues, Retrofit for adaptive HTTP connection pooling, and WorkManager for reliable background sync.',
      hardChallenges:
          'Processing burst notification payloads of up to 10,000 incoming alerts in quick succession while maintaining sub-15ms local Room query response times and zero UI freeze.',
      quantifiableImpact:
          'Successfully dispatched 5M+ monthly notifications with a 99.95% delivery receipt accuracy, reducing UI rendering latency by 40%.',
      platforms: ['Android'],
      screenshotUrl: 'assets/images/massageclub.jpg',
      links: [
        ProjectLink(
          label: 'Play Store',
          url: 'https://play.google.com/store/apps/details?id=com.massageclub&hl=en',
          type: ProjectLinkType.playStore,
        ),
      ],
    ),

    // 8. Matrix Media Solution - Staffer
    Project(
      title: 'Staffer',
      period: '2018 – 2019',
      company: 'Matrix Media Solution Pvt. Ltd.',
      category: ProjectCategory.clientSolutions,
      stackSummary: 'Native Android · Kotlin · MVVM · LiveData · Room DB · CalendarProvider · WorkManager',
      techStack: [
        'Native Android',
        'Kotlin',
        'MVVM',
        'LiveData',
        'Room DB',
        'CalendarProvider',
        'WorkManager',
        'Coroutines',
        'Retrofit',
      ],
      overview:
          'Workforce shift scheduling and roster management Android app enabling healthcare and retail teams to manage shift availability, resolve scheduling conflicts, and sync rosters with native Android calendars.',
      myRole:
          'Android Engineer responsible for implementing the MVVM architecture with LiveData, conflict resolution engine, Android CalendarProvider two-way synchronization, and offline Room caching.',
      problemScope:
          'Shift workers often missed unscheduled roster changes due to disconnected scheduling systems. The product required real-time shift conflict resolution with two-way synchronization to the native Android Calendar.',
      technicalArchitecture:
          'MVVM Clean Architecture using Android Jetpack ViewModel & LiveData for state management. Integrated Android CalendarProvider ContentResolver API, Room DB for local shift caching, and WorkManager for periodic background roster sync.',
      hardChallenges:
          'Managing two-way synchronization between cloud shift updates and Android CalendarProvider without creating duplicate entries, calendar permission crashes, or race conditions across different time zones.',
      quantifiableImpact:
          'Eliminated 80% of workforce scheduling disputes, automated shift reminders for 15,000+ frontline workers, and attained a 4.7★ store rating.',
      platforms: ['Android'],
      screenshotUrl: null,
      links: [
        ProjectLink(
          label: 'GitHub',
          url: 'https://github.com/JayDutta7',
          type: ProjectLinkType.github,
        ),
      ],
    ),

    // 9. DCC Services - DrLife
    Project(
      title: 'DrLife',
      period: '2020 – 2020',
      company: 'DCC Services Pvt Ltd.',
      category: ProjectCategory.clientSolutions,
      stackSummary: 'Native Android · Kotlin · MVVM · LiveData · WebRTC · HIPAA Compliant · SQLCipher · Coroutines',
      techStack: [
        'Native Android',
        'Kotlin',
        'MVVM',
        'LiveData',
        'WebRTC',
        'SQLCipher',
        'HIPAA Compliance',
        'Coroutines & Flow',
        'Clean Architecture',
        'Retrofit',
      ],
      overview:
          'Telemedicine consultation Android app featuring low-latency encrypted video consultations, digital prescription issuance, and HIPAA-compliant patient medical records.',
      myRole:
          'Lead Native Android Developer designing the MVVM architecture with LiveData state management, WebRTC peer-to-peer audio/video streaming pipeline, and 256-bit AES SQLCipher patient record storage.',
      problemScope:
          'Remote medical consultations required ultra-low-latency, crystal-clear video streaming over variable mobile networks, while adhering to strict HIPAA regulatory privacy standards for electronic health records.',
      technicalArchitecture:
          'Clean Architecture with MVVM and LiveData. Native WebRTC C++ wrapper bindings for hardware-accelerated video codecs (H.264/VP8), combined with SQLCipher 256-bit AES local database encryption and lifecycle-aware reactive UI observation.',
      hardChallenges:
          'Maintaining call stability with dynamic video bitrate downsampling during sudden packet loss on 3G/4G rural networks, while preventing plaintext logging of patient medical notes.',
      quantifiableImpact:
          'Enabled 20,000+ secure remote teleconsultations, maintained a 99.4% call connection success rate, and achieved 100% compliance during third-party HIPAA security audits.',
      platforms: ['Android'],
      screenshotUrl: null,
      links: [
        ProjectLink(
          label: 'GitHub',
          url: 'https://github.com/JayDutta7',
          type: ProjectLinkType.github,
        ),
      ],
    ),
  ];

  static const Profile _englishProfile = Profile(
    name: name,
    title: 'Senior Android & Flutter Engineer',
    subtitle: 'Principal Mobile Architect · 9+ Years Production Experience',
    experienceBadge: '9+ Years Experience',
    location: 'Serampore, West Bengal, India',
    phone: phone,
    email: email,
    linkedInUrl: linkedInUrl,
    githubUrl: githubUrl,
    heroIntro:
        'Senior Android & Flutter Engineer — 9+ years building, deploying, and scaling mission-critical mobile systems, with deep expertise across Native Android and Flutter.',
    aboutMe:
        'I am a Senior Android & Flutter Engineer with over 9 years of production experience building native Android and cross-platform Flutter applications end-to-end — from system architecture to store releases.\n\nMy core technical stack includes Native Android (Kotlin, Java), Jetpack Compose, MVVM, LiveData, Flutter (Dart), Clean Architecture, BLoC, Riverpod, Room, SQLite, Retrofit, Dio, and Coroutines/Flow.\n\nMy native specializations include Method Channels, Foreground Services, Background Geolocation, BLE/Bluetooth, WebRTC low-latency streaming, SQLCipher database encryption, and resilient offline-first synchronization.\n\nOver the course of my career across Shyam Steel Industries, Nat IT Solved, Matrix Media Solution, and DCC Services, I have engineered 9 verified production apps across Google Play Store and Apple App Store, modernizing architectures, slashing crash rates by 20%, and improving runtime speeds by 20%.',
    profilePicture: profilePicture,
    resumeAssetPath: resumeAssetPath,
    resumeDownloadFileName: resumeDownloadFileName,
    seoTitle: 'Jayajit Dutta | Senior Android & Flutter Engineer (9+ Years)',
    seoDescription:
        'Senior Android & Flutter Engineer with 9+ years of production experience building enterprise and client mobile apps.',
    skillCategories: [
      SkillCategory(
        title: 'Mobile Engineering',
        iconAsset: 'mobile',
        skills: ['Kotlin', 'Android SDK', 'Flutter', 'Dart', 'Jetpack Compose', 'Coroutines', 'Dagger / Hilt', 'Java'],
      ),
      SkillCategory(
        title: 'Architecture & State',
        iconAsset: 'architecture',
        skills: ['Clean Architecture', 'MVVM', 'LiveData', 'BLoC', 'Riverpod', 'Repository Pattern', 'Dependency Injection'],
      ),
      SkillCategory(
        title: 'Native Specializations',
        iconAsset: 'other',
        skills: ['Method Channels', 'Barcode & QR Scanning (ML Kit)', 'Foreground Services', 'Background Geolocation', 'BLE / Bluetooth', 'WebRTC'],
      ),
      SkillCategory(
        title: 'Data & Sync',
        iconAsset: 'storage',
        skills: ['Offline-First Sync', 'Room DB', 'SQLCipher', 'SQLite', 'WorkManager'],
      ),
      SkillCategory(
        title: 'Networking & Telemetry',
        iconAsset: 'networking',
        skills: ['Easebuzz Payment Gateway', 'Retrofit', 'Dio', 'Coroutines & Flow', 'REST APIs', 'WebSockets', 'RxJava'],
      ),
      SkillCategory(
        title: 'Cloud & Quality',
        iconAsset: 'state',
        skills: ['Firebase Auth & FCM', 'CI/CD Pipelines', 'Crashlytics', 'Unit & Widget Testing'],
      ),
    ],
    experience: [
      ExperienceItem(
        company: 'Shyam Steel Industries Ltd.',
        role: 'Senior Android & Flutter Developer',
        period: 'Sep 2020 – Present',
        isCurrent: true,
        highlights: [
          'Architected and delivered 5 flagship enterprise mobile apps: Ghareka Consumer App, Ghareka PMT, Retail CRM, Buildistan, and Pariwar.',
          'Spearheaded codebase modernization from legacy Java to modern Kotlin & Jetpack Compose, improving runtime speeds by 20% and slashing crash rates by 20%.',
          'Engineered Easebuzz payment gateway checkout flows, Google ML Kit barcode & QR coupon scanning, resilient offline Room sync, and battery-optimized GPS tracking.',
          'Mentored an Agile engineering squad, owning sprint planning, automated testing, and CI/CD releases.',
        ],
      ),
      ExperienceItem(
        company: 'DCC Services Pvt Ltd.',
        role: 'Android Engineer / Consultant',
        period: 'Jan 2020 – Sep 2020',
        highlights: [
          'Engineered "DrLife" Native Android telemedicine app in Kotlin with MVVM and LiveData, featuring WebRTC peer-to-peer low-latency streaming and SQLCipher encrypted health records.',
          'Enforced rigorous HIPAA compliance standards and eliminated data leakage risks.',
        ],
      ),
      ExperienceItem(
        company: 'Matrix Media Solution Pvt. Ltd.',
        role: 'Android Developer',
        period: 'Nov 2018 – Dec 2019',
        highlights: [
          'Architected "Staffer" Native Android workforce scheduling app using Kotlin, MVVM, and LiveData with dynamic shift conflict resolution.',
          'Engineered two-way calendar synchronization using Android CalendarProvider ContentResolver API and Room DB offline caching.',
        ],
      ),
      ExperienceItem(
        company: 'Nat IT Solved Pvt. Ltd.',
        role: 'Android Application Developer',
        period: 'Apr 2017 – Oct 2018',
        highlights: [
          'Developed "Captain Logistics" Native Android fleet dispatch app in Kotlin using MVVM, LiveData, and real-time WebSocket GPS telemetry.',
          'Built "Message Club" Native Android broadcast messaging platform with Kotlin, MVVM, LiveData, Retrofit, and batch Room DB queues.',
        ],
      ),
    ],
    projects: _verifiedProjects,
    stats: [
      StatItem(value: '9+', label: 'Years Experience'),
      StatItem(value: '9', label: 'Verified Production Apps'),
      StatItem(value: '4', label: 'Companies'),
      StatItem(value: '2', label: 'Platforms (Android + Flutter)'),
    ],
    education: [
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
    ],
    flutterArchitecturePipeline: [
      'Flutter UI (Declarative)',
      'BLoC / Riverpod State',
      'Clean Architecture Use Cases',
      'Repository Pattern',
      'REST APIs & WebSockets',
      'Offline Database (SQLite / Room)',
      'Firebase & Push Notifications',
      'Production Release',
    ],
    androidArchitecturePipeline: [
      'Jetpack Compose / XML UI',
      'MVVM Architecture',
      'Clean Architecture (Domain/Data)',
      'ViewModel & LiveData / StateFlow',
      'Dependency Injection (Hilt / Koin)',
      'Coroutines & Flow',
      'Repository Layer',
      'Retrofit & WebRTC',
      'Room DB & SQLCipher',
      'Production Release',
    ],
  );

  static const Profile _bengaliProfile = Profile(
    name: name,
    title: 'সিনিয়র অ্যান্ড্রয়েড ও ফ্ল্যাটার ইঞ্জিনিয়ার',
    subtitle: 'প্রিন্সিপাল মোবাইল আর্কিটেক্ট · ৯+ বছরের অভিজ্ঞতা',
    experienceBadge: '৯+ বছরের অভিজ্ঞতা',
    location: 'শ্রীরামপুর, পশ্চিমবঙ্গ, ভারত',
    phone: phone,
    email: email,
    linkedInUrl: linkedInUrl,
    githubUrl: githubUrl,
    heroIntro:
        '৯+ বছরের উৎপাদন অভিজ্ঞতা সম্পন্ন সিনিয়র অ্যান্ড্রয়েড ও ফ্ল্যাটার ইঞ্জিনিয়ার। নেটিভ অ্যান্ড্রয়েড (Kotlin, Jetpack Compose), ফ্ল্যাটার (Dart, BLoC, Riverpod), এবং ক্লিন আর্কিটেকচার সিস্টেমে পারদর্শী।',
    aboutMe:
        'আমি ৯ বছরেরও বেশি অভিজ্ঞতাসম্পন্ন সিনিয়র অ্যান্ড্রয়েড ও ফ্ল্যাটার ইঞ্জিনিয়ার। আর্কিটেকচার থেকে প্রোডাকশন রিলিজ পর্যন্ত ৯টি যাচাইকৃত প্রোডাকশন অ্যাপ তৈরি করেছি। আমার কাজের মূল শক্তি হল ক্লিন আর্কিটেকচার, অফলাইন-ফার্স্ট সিঙ্ক, এবং উচ্চ পারফরম্যান্স নিশ্চিত করা।',
    profilePicture: profilePicture,
    resumeAssetPath: resumeAssetPath,
    resumeDownloadFileName: resumeDownloadFileName,
    seoTitle: 'জয়জিৎ দত্ত | সিনিয়র অ্যান্ড্রয়েড ও ফ্ল্যাটার ইঞ্জিনিয়ার',
    seoDescription: '৯+ বছরের অভিজ্ঞতাসম্পন্ন সিনিয়র অ্যান্ড্রয়েড ও ফ্ল্যাটার ইঞ্জিনিয়ার।',
    skillCategories: [
      SkillCategory(
        title: 'মোবাইল ইঞ্জিনিয়ারিং',
        iconAsset: 'mobile',
        skills: ['Kotlin', 'Android SDK', 'Flutter', 'Dart', 'Jetpack Compose', 'Coroutines', 'Dagger / Hilt', 'Java'],
      ),
      SkillCategory(
        title: 'আর্কিটেকচার ও স্টেট',
        iconAsset: 'architecture',
        skills: ['Clean Architecture', 'MVVM', 'LiveData', 'BLoC', 'Riverpod', 'Repository Pattern'],
      ),
      SkillCategory(
        title: 'নেটিভ স্পেশালাইজেশন',
        iconAsset: 'other',
        skills: ['Method Channels', 'Barcode & QR Scanning', 'Foreground Services', 'Background Geolocation', 'BLE', 'WebRTC'],
      ),
      SkillCategory(
        title: 'ডাটা ও সিঙ্ক',
        iconAsset: 'storage',
        skills: ['Offline-First Sync', 'Room DB', 'SQLCipher', 'SQLite', 'WorkManager'],
      ),
      SkillCategory(
        title: 'নেটওয়ার্কিং ও ক্লাউড',
        iconAsset: 'networking',
        skills: ['Easebuzz Payment Gateway', 'Retrofit', 'Dio', 'Coroutines & Flow', 'REST APIs', 'WebSockets', 'Firebase'],
      ),
    ],
    experience: [
      ExperienceItem(
        company: 'শ্যাম স্টিল ইন্ডাস্ট্রিজ লিমিটেড',
        role: 'সিনিয়র অ্যান্ড্রয়েড ও ফ্ল্যাটার ডেভেলপার',
        period: 'সেপ্টেম্বর ২০২০ – বর্তমান',
        isCurrent: true,
        highlights: [
          'ঘরেকা কনজিউমার অ্যাপ, ঘরেকা পিএমটি, রিটেল সিআরএম, বিল্ডিস্টান এবং পরিবার অ্যাপ আর্কিটেক্ট ও তৈরি করেছেন।',
          'লেগ্যাসি জাভা থেকে কোটলিনে মাইগ্রেশনের মাধ্যমে ক্র্যাশ রেট ২০% কমিয়েছেন এবং পারফরম্যান্স ২০% বাড়িয়েছেন।',
        ],
      ),
      ExperienceItem(
        company: 'ডিসিসি সার্ভিসেস প্রাইভেট লিমিটেড',
        role: 'অ্যাসোসিয়েট কনসালটেন্ট',
        period: 'জানুয়ারি ২০২০ – সেপ্টেম্বর ২০২০',
        highlights: ['ডক্টরলাইফ টেলিমেডিসিন অ্যাপ্লিকেশনে WebRTC স্ট্রিমিং ও SQLCipher তৈরি করেছেন।'],
      ),
      ExperienceItem(
        company: 'ম্যাট্রিক্স মিডিয়া সলিউশন প্রাইভেট লিমিটেড',
        role: 'অ্যান্ড্রয়েড ও ফ্ল্যাটার ডেভেলপার',
        period: 'নভেম্বর ২০১৮ – ডিসেম্বর ২০১৯',
        highlights: ['স্টাফার শিডিউলিং অ্যাপে ক্যালেন্ডার সিঙ্ক ও মেথড চ্যানেল ইঞ্জিনিয়ারিং করেছেন।'],
      ),
      ExperienceItem(
        company: 'ন্যাট আইটি সলভড প্রাইভেট লিমিটেড',
        role: 'মোবাইল অ্যাপ্লিকেশন ডেভেলপার',
        period: 'এপ্রিল ২০১৭ – অক্টোবর ২০১৮',
        highlights: ['ক্যাপ্টেন লজিস্টিক্সে রিয়েল-টাইম জিপিএস এবং মেসেজ ক্লাবে ব্যাচ নোটিফিকেশন তৈরি করেছেন।'],
      ),
    ],
    projects: _verifiedProjects,
    stats: [
      StatItem(value: '৯+', label: 'বছরের অভিজ্ঞতা'),
      StatItem(value: '৯', label: 'যাচাইকৃত প্রোডাকশন অ্যাপ'),
      StatItem(value: '৪', label: 'কোম্পানি'),
      StatItem(value: '২', label: 'প্ল্যাটফর্ম (Android + Flutter)'),
    ],
    education: [
      EducationItem(
        title: 'মাস্টার অফ কম্পিউটার অ্যাপ্লিকেশন (MCA)',
        institution: 'ব্রেনওয়্যার গ্রুপ অফ ইনস্টিটিউশন',
        period: '২০১২ – ২০১৫',
        detail: 'CGPA: 7.23',
      ),
      EducationItem(
        title: 'ব্যাচেলর অফ কম্পিউটার অ্যাপ্লিকেশন (BCA)',
        institution: 'মেঘনাদ সাহা ইনস্টিটিউট অফ টেকনোলজি',
        period: '২০০৮ – ২০১১',
        detail: 'CGPA: 7.21',
      ),
    ],
    flutterArchitecturePipeline: [
      'ফ্ল্যাটার ইউআই',
      'বিএলওসি / রিভারপোড',
      'ক্লিন আর্কিটেকচার',
      'রেস্ট এপিআই ও ওয়েবসকেট',
      'অফলাইন ডাটাবেস',
      'প্রোডাকশন রিলিজ',
    ],
    androidArchitecturePipeline: [
      'জেটপ্যাক কম্পোজ ইউআই',
      'এমভিভিএম আর্কিটেকচার',
      'ক্লিন আর্কিটেকচার',
      'কোরুটিন্স ও ফ্লো',
      'রুম ডিবি ও এসকিউএলসাইফার',
      'প্রোডাকশন রিলিজ',
    ],
  );

  static const Profile _hindiProfile = Profile(
    name: name,
    title: 'सीनियर एंड्रॉइड और फ़्लटर इंजीनियर',
    subtitle: 'प्रिंसिपल मोबाइल आर्किटेक्ट · 9+ वर्षों का अनुभव',
    experienceBadge: '9+ वर्षों का अनुभव',
    location: 'श्रीरामपुर, पश्चिम बंगाल, भारत',
    phone: phone,
    email: email,
    linkedInUrl: linkedInUrl,
    githubUrl: githubUrl,
    heroIntro:
        '9+ वर्षों के उत्पादन अनुभव वाले सीनियर एंड्रॉइड और फ़्लटर इंजीनियर। नेटिव एंड्रॉइड (Kotlin, Jetpack Compose), फ़्लटर (Dart, BLoC, Riverpod) और क्लीन आर्किटेक्चर सिस्टम में विशेषज्ञता।',
    aboutMe:
        'मैं 9+ वर्षों के उत्पादन अनुभव के साथ सीनियर एंड्रॉइड और फ़्लटर इंजीनियर हूं। आर्किटेक्चर से लेकर स्टोर रिलीज तक 9 सत्यापित प्रोडक्शन ऐप्स डिलीवर किए हैं। मेरी मुख्य ताकत क्लीन आर्किटेक्चर, ऑफलाइन-फर्स्ट सिंक, और उच्च प्रदर्शन सुनिश्चित करना है।',
    profilePicture: profilePicture,
    resumeAssetPath: resumeAssetPath,
    resumeDownloadFileName: resumeDownloadFileName,
    seoTitle: 'जयजीत दत्ता | सीनियर एंड्रॉइड और फ़्लटर इंजीनियर',
    seoDescription: '9+ वर्षों के अनुभव वाले सीनियर एंड्रॉइड और फ़्लटर इंजीनियर।',
    skillCategories: [
      SkillCategory(
        title: 'मोबाइल इंजीनियरिंग',
        iconAsset: 'mobile',
        skills: ['Kotlin', 'Android SDK', 'Flutter', 'Dart', 'Jetpack Compose', 'Coroutines', 'Dagger / Hilt', 'Java'],
      ),
      SkillCategory(
        title: 'आर्किटेक्चर और स्टेट',
        iconAsset: 'architecture',
        skills: ['Clean Architecture', 'MVVM', 'LiveData', 'BLoC', 'Riverpod', 'Repository Pattern'],
      ),
      SkillCategory(
        title: 'नेटिव विशेषज्ञता',
        iconAsset: 'other',
        skills: ['Method Channels', 'Barcode & QR Scanning', 'Foreground Services', 'Background Geolocation', 'BLE', 'WebRTC'],
      ),
      SkillCategory(
        title: 'डेटा और सिंक',
        iconAsset: 'storage',
        skills: ['Offline-First Sync', 'Room DB', 'SQLCipher', 'SQLite', 'WorkManager'],
      ),
      SkillCategory(
        title: 'नेटवर्किंग और क्लाउड',
        iconAsset: 'networking',
        skills: ['Easebuzz Payment Gateway', 'Retrofit', 'Dio', 'Coroutines & Flow', 'REST APIs', 'WebSockets', 'Firebase'],
      ),
    ],
    experience: [
      ExperienceItem(
        company: 'श्याम स्टील इंडस्ट्रीज लिमिटेड',
        role: 'सीनियर एंड्रॉइड और फ़्लटर डेवलपर',
        period: 'सितंबर 2020 – वर्तमान',
        isCurrent: true,
        highlights: [
          'घरेका कंज्यूमर ऐप, घरेका पीएमटी, रिटेल सीआरएम, बिल्डिस्तान और परिवार ऐप का निर्माण किया।',
          'जावा से कोटलिन में माइग्रेशन करके क्रैश दर 20% कम की और प्रदर्शन 20% बढ़ाया।',
        ],
      ),
      ExperienceItem(
        company: 'डीसीसी सर्विसेज प्राइवेट लिमिटेड',
        role: 'एसोसिएट कंसल्टेंट',
        period: 'जनवरी 2020 – सितंबर 2020',
        highlights: ['डॉक्टरलाइफ टेलीमेडिसिन एप्लिकेशन में WebRTC और SQLCipher विकसित किया।'],
      ),
      ExperienceItem(
        company: 'मैट्रिक्स मीडिया सॉल्यूशन प्राइवेट लिमिटेड',
        role: 'एंड्रॉइड और फ़्लटर डेवलपर',
        period: 'नवंबर 2018 – दिसंबर 2019',
        highlights: ['स्टाफर ऐप में कैलेंडर सिंक और मेथड चैनल विकसित किए।'],
      ),
      ExperienceItem(
        company: 'नेट आईटी सॉल्व्ड प्राइवेट लिमिटेड',
        role: 'मोबाइल एप्लिकेशन डेवलपर',
        period: 'अप्रैल 2017 – अक्टूबर 2018',
        highlights: ['कैप्टन लॉजिस्टिक्स में रियल-टाइम जीपीएस और मैसेज क्लब में बैच नोटिफिकेशन बनाए।'],
      ),
    ],
    projects: _verifiedProjects,
    stats: [
      StatItem(value: '9+', label: 'वर्षों का अनुभव'),
      StatItem(value: '9', label: 'सत्यापित प्रोडक्शन ऐप्स'),
      StatItem(value: '4', label: 'कंपनियां'),
      StatItem(value: '2', label: 'प्लेटफ़ॉर्म (Android + Flutter)'),
    ],
    education: [
      EducationItem(
        title: 'मास्टर ऑफ कंप्यूटर एप्लीकेशन (MCA)',
        institution: 'ब्रेनवेयर ग्रुप ऑफ इंस्टीट्यूशन',
        period: '2012 – 2015',
        detail: 'CGPA: 7.23',
      ),
      EducationItem(
        title: 'बैचलर ऑफ कंप्यूटर एप्लीकेशन (BCA)',
        institution: 'मेघनाद साहा इंस्टीट्यूट ऑफ टेक्नोलॉजी',
        period: '2008 – 2011',
        detail: 'CGPA: 7.21',
      ),
    ],
    flutterArchitecturePipeline: [
      'फ़्लटर यूआई',
      'बीएलओसी / रिवरपोड',
      'क्लीन आर्किटेक्चर',
      'रेस्ट एपीआई और वेबसॉकेट्स',
      'ऑफलाइन डेटाबेस',
      'प्रोडक्शन रिलीज',
    ],
    androidArchitecturePipeline: [
      'जेटपैक कंपोज़ यूआई',
      'एमवीवीएम आर्किटेक्चर',
      'क्लीन आर्किटेक्चर',
      'कोरुटीन्स और फ्लो',
      'रूम डीबी और एसक्यूएलसाइफर',
      'प्रोडक्शन रिलीज',
    ],
  );
}
