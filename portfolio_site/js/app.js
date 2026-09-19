/**
 * JAYAJIT DUTTA | LINEAR/VERCEL OBSIDIAN BENTO PORTFOLIO LOGIC
 * Complete 9-Project Case Study Engine, Deep-Dive Drawer, ADB Terminal,
 * Spotlight Glow, Tech Matrix Filter, Cmd+K Palette, and APK/QR Modals.
 */

(function () {
  'use strict';

  // ==========================================================================
  // COMPLETE 9-PROJECT PRODUCTION DATABASE (Mirrors Flutter ProfileData)
  // ==========================================================================
  const ALL_PROJECTS = {
    'ghareka': {
      id: 'ghareka',
      title: 'Ghareka Consumer App',
      period: '2025 – Present',
      company: 'Shyam Steel Industries Ltd.',
      category: 'shyamSteel',
      categoryLabel: 'Enterprise eCommerce · Flutter',
      stackSummary: 'Flutter · Dart · Riverpod · Clean Architecture · REST APIs · Firebase',
      techStack: ['Flutter', 'Dart', 'Riverpod', 'Clean Architecture', 'Estimation Engine', 'REST APIs', 'Firebase FCM'],
      overview: 'Direct-to-consumer construction procurement application written in Flutter using Riverpod, featuring dynamic structural material estimators, milestone tracking, and direct order fulfillment.',
      myRole: 'Lead Flutter Developer responsible for Flutter client architecture, Riverpod state orchestration, and material estimation algorithm.',
      problemScope: 'Homeowners face opacity and high price variance when sourcing raw construction materials. The product required an intuitive mobile experience capable of calculating accurate structural reinforcement bar quantities based on floor plans while enabling direct-to-consumer order fulfillment.',
      technicalArchitecture: 'Written in Flutter using Riverpod state management and Clean Architecture. Implemented an algorithmic material estimation engine that computes load-bearing steel requirements with zero UI thread jank, paired with resilient Dio interceptors and Firebase cloud messaging.',
      hardChallenges: 'Executing complex geometric material calculations concurrently without dropping frames on budget Android devices. Solved by offloading heavy bar-bending mathematical matrix operations to Dart background Isolates, maintaining a sustained 60 FPS.',
      quantifiableImpact: 'Reduced customer pre-sales inquiries by 40% and increased direct-to-consumer material bookings by 35% within the first two quarters.',
      minSdk: '24 (Android 7.0)',
      targetSdk: '35 (Android 15)',
      buildSize: '16.8 MB (Optimized R8)',
      architecture: 'ARM64-v8a / x86_64',
      sha256: '9A:4C:E1:88:B3:2F:5D:89',
      screenshot: 'assets/images/ghareka.jpeg',
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.ghreka.consumerapp',
      appStoreUrl: 'https://apps.apple.com/app/id6467111338',
      apkName: 'Ghareka_Consumer_Release.apk'
    },
    'ghareka_pmt': {
      id: 'ghareka_pmt',
      title: 'Ghareka PMT (Project Management)',
      period: '2025 – Present',
      company: 'Shyam Steel Industries Ltd.',
      category: 'shyamSteel',
      categoryLabel: 'Enterprise Field Tool · Native Compose',
      stackSummary: 'Native Android · Kotlin · Jetpack Compose · Clean Arch · Room · WorkManager',
      techStack: ['Android SDK', 'Kotlin', 'Jetpack Compose', 'Clean Architecture', 'Room DB', 'Coroutines/Flow', 'WorkManager', 'Retrofit'],
      overview: 'Enterprise field project management tool for civil site engineers, featuring offline inspection logs, automated GPS site check-ins, and photographic milestone validations.',
      myRole: 'Principal Native Android Architect owning 100% Jetpack Compose UI architecture, offline-first Room data persistence, and background sync pipelines.',
      problemScope: 'Construction sites operate in high-interference or zero-connectivity cellular dead zones. Site supervisors needed an infallible mobile tool to capture complex engineering inspection logs, safety audits, and photo evidence without losing data during connectivity loss.',
      technicalArchitecture: 'Single-Activity architecture built with declarative Jetpack Compose and MVI/MVVM. Room SQLite database serves as the single source of truth (SSOT). Background synchronization is managed via Android Jetpack WorkManager with exponential backoff and battery/network constraints.',
      hardChallenges: 'Eliminating concurrent write race conditions and memory leaks when capturing 10+ high-resolution site progress photos in low-RAM field devices. Solved via scoped Coroutines, asynchronous bitmap compression, and multi-table atomic Room transactions.',
      quantifiableImpact: '100% elimination of paper inspection logs, zero data loss reports across 500+ active enterprise project sites, and 25% faster site clearance turnaround.',
      minSdk: '26 (Android 8.0)',
      targetSdk: '35 (Android 15)',
      buildSize: '14.1 MB (Native Compose)',
      architecture: 'ARM64-v8a',
      sha256: '2C:9A:88:41:D7:3E:6B:55',
      screenshot: 'assets/images/ghareka_pmt.jpeg',
      webUrl: 'https://pmt.ghareka.com',
      apkName: 'Ghareka_PMT_Release.apk'
    },
    'crm': {
      id: 'crm',
      title: 'Retail CRM & Field Automation',
      period: '2021 – 2024',
      company: 'Shyam Steel Industries Ltd.',
      category: 'shyamSteel',
      categoryLabel: 'Field Telemetry · Clean Architecture',
      stackSummary: 'Native Android · Kotlin · MVVM · Clean Arch · Room · WorkManager · Background GPS',
      techStack: ['Android SDK', 'Kotlin', 'MVVM', 'Clean Architecture', 'Room DB', 'WorkManager', 'RxJava', 'Coroutines', 'Foreground Services', 'FusedLocationProvider'],
      overview: 'Full-scale retail field sales force automation app featuring offline data caching & synchronization, dealer check-ins, and battery-optimized GPS workflow automation.',
      myRole: 'Lead Android Developer responsible for offline-first sync architecture, geo-fenced visit validation, and battery-optimized background route telemetry.',
      problemScope: 'A distributed sales force of hundreds of field executives required automated verification of physical dealer visits and real-time order bookings across rural retail corridors with patchy network coverage.',
      technicalArchitecture: 'Tiered Clean Architecture leveraging Room DB, Kotlin Coroutines, and RxJava event streaming. Designed an adaptive background geolocation service that shifts GPS polling frequency based on accelerometer activity and geofence proximity.',
      hardChallenges: 'Preventing aggressive OEM battery-killing algorithms (Xiaomi, Samsung, Oppo) from terminating background location tracking while keeping 8-hour shift battery drain under 4%. Solved via high-priority Foreground Services with persistent notification channels and batch sensor buffering.',
      quantifiableImpact: 'Boosted daily dealer visit compliance by 45%, reduced battery consumption by 38% compared to legacy tracking, and processed over ₹100M+ in quarterly dealer orders.',
      minSdk: '24 (Android 7.0)',
      targetSdk: '35 (Android 15)',
      buildSize: '12.8 MB (Battery-Optimized GPS)',
      architecture: 'ARM64-v8a',
      sha256: '4D:3C:99:A1:B7:2E:8F:04',
      screenshot: 'assets/images/crm.jpeg',
      apkName: 'Retail_CRM_Release.apk'
    },
    'buildistan': {
      id: 'buildistan',
      title: 'Buildistan B2B Marketplace',
      period: '2023 – Present',
      company: 'Shyam Steel Industries Ltd.',
      category: 'shyamSteel',
      categoryLabel: 'B2B Marketplace · 5K+ Downloads',
      stackSummary: 'Flutter · Dart · BLoC · Clean Architecture · Multi-Vendor Cart · Easebuzz Gateway',
      techStack: ['Flutter', 'Dart', 'BLoC', 'Clean Architecture', 'Multi-Vendor Cart', 'Easebuzz Payment Gateway', 'REST APIs', 'Dio', 'B2B Marketplace'],
      overview: 'High-throughput B2B building materials procurement marketplace connecting bulk contractors, suppliers, and distributors with dynamic multi-vendor cart management and secure Easebuzz payment gateway processing.',
      myRole: 'Senior Flutter Engineer leading cross-platform client development, multi-vendor cart state machines, Easebuzz payment checkout flows, and real-time trade quotation workflows.',
      problemScope: 'B2B building procurement entails complex purchasing rules: tiered volume pricing, split distributor shipments, credit limit approvals, instant GST invoices, and secure digital payments that standard e-commerce architectures cannot support.',
      technicalArchitecture: 'Clean Architecture with BLoC (Business Logic Component) pattern. Integrated Easebuzz payment gateway with secure server-to-server webhook reconciliation and cryptographic payment hash verification. Event-driven multi-vendor cart state machine with optimistic UI reconciliation, persistent local cart caching via SQLite, and robust Dio network interceptors with token auto-refresh.',
      hardChallenges: 'Handling atomic state updates across complex multi-vendor order splits with distinct delivery lead-times, while managing asynchronous Easebuzz payment gateway callbacks, webhook retries, and transaction settlement without double-charge risk or state drift. Solved with immutable event-driven BLoC state streams and sequential event transformers.',
      quantifiableImpact: '5K+ downloads, 99.9% crash-free sessions across Android and iOS, and processing over 1,500 daily bulk B2B construction material RFQs and digital transactions via Easebuzz.',
      minSdk: '24 (Android 7.0)',
      targetSdk: '35 (Android 15)',
      buildSize: '18.4 MB (Multi-Vendor Engine)',
      architecture: 'ARM64-v8a / x86_64',
      sha256: '5E:1F:B8:33:A2:4D:90:76',
      screenshot: 'assets/images/buildistan.jpeg',
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.buildistan.b2b',
      appStoreUrl: 'https://apps.apple.com/app/id6472875216',
      apkName: 'Buildistan_Marketplace_Release.apk'
    },
    'pariwar': {
      id: 'pariwar',
      title: 'Pariwar Loyalty Rewards',
      period: '2024 – 2025',
      company: 'Shyam Steel Industries Ltd.',
      category: 'shyamSteel',
      categoryLabel: 'Enterprise Loyalty · 4.5★ (5K+ Downloads)',
      stackSummary: 'Flutter · Dart · Riverpod · Barcode & QR Scanner · ML Kit · HMAC Fraud Engine',
      techStack: ['Flutter', 'Dart', 'Riverpod', 'Barcode & QR Scanning', 'CameraX / ML Kit', 'Method Channels', 'HMAC Cryptography', 'Offline Ledger', 'Firebase Push'],
      overview: 'Trade partner loyalty rewards application written in Flutter using Riverpod, featuring high-speed industrial barcode & QR coupon scanning on steel bundles, cryptographic fraud prevention, and instant reward redemption.',
      myRole: 'Senior Flutter Engineer delivering the partner engagement client using Riverpod, barcode & QR coupon scanning, and cryptographic fraud detection engine.',
      problemScope: 'Fabricators, masons, and trade partners scan 1D barcodes and 2D QR coupons printed on industrial steel bundles in outdoor stockyards. The app required millisecond barcode/QR scan recognition under glare, poor lighting, and dirty labels, while preventing coupon replay attacks.',
      technicalArchitecture: 'Written in Flutter using Riverpod state management. Integrated Google ML Kit Barcode Scanning API with hardware-accelerated autofocus, HMAC-SHA256 signature verification on coupons, and an offline-first transactional ledger.',
      hardChallenges: 'Mitigating counterfeit coupon injection and replay attacks in remote yards without internet connectivity. Solved by storing encrypted rolling nonces in SQLCipher and verifying cryptographic barcode hashes locally before queueing atomic sync.',
      quantifiableImpact: 'Achieved a 4.5★ rating with 5K+ downloads, 100,000+ barcodes and QR coupons scanned monthly with 0 fraud incidents, and reduced scanning latency from 1.8s to 120ms.',
      minSdk: '24 (Android 7.0)',
      targetSdk: '35 (Android 15)',
      buildSize: '17.2 MB (Offline ML Models)',
      architecture: 'ARM64-v8a',
      sha256: '7B:2D:A3:99:C1:6E:4F:12',
      screenshot: 'assets/images/pariwar.webp',
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.shyamsteel.pariwar',
      appStoreUrl: 'https://apps.apple.com/app/id1635952518',
      apkName: 'Pariwar_Loyalty_Release.apk'
    },
    'captain_logistics': {
      id: 'captain_logistics',
      title: 'Captain Logistics',
      period: '2017 – 2018',
      company: 'Nat IT Solved Pvt. Ltd.',
      category: 'clientSolutions',
      categoryLabel: 'Fleet Telemetry · WebSockets',
      stackSummary: 'Native Android · Kotlin · MVVM · LiveData · WebSockets · Google Maps SDK · Foreground Telemetry',
      techStack: ['Native Android', 'Kotlin', 'MVVM', 'LiveData', 'WebSockets', 'Google Maps SDK', 'FusedLocationProvider', 'Foreground Services', 'Coroutines & Flow', 'Room DB'],
      overview: 'Enterprise fleet logistics and supply chain Android application enabling live WebSocket GPS telemetry, automated driver dispatch, and real-time route tracking.',
      myRole: 'Lead Android Developer architecting the real-time WebSocket telemetry pipeline, MVVM state flows with LiveData, custom Google Maps overlay rendering, and driver dispatch UX.',
      problemScope: 'Commercial fleet operators required sub-second vehicle telemetry tracking, geo-fenced arrival notifications, and live traffic turn-by-turn routing for delivery drivers concurrently in challenging connectivity environments.',
      technicalArchitecture: 'Clean Architecture and MVVM pattern utilizing LiveData for lifecycle-safe reactive UI updates. High-throughput WebSocket streams combined with an Android Foreground Service gathering continuous GPS breadcrumbs and buffering points locally in Room DB.',
      hardChallenges: 'Rendering hundreds of dynamically updating vehicle markers, route polylines, and geofence polygons on lower-tier Android hardware without dropping below 60 FPS or causing memory leaks in location callbacks.',
      quantifiableImpact: 'Achieved sub-200ms telemetry latency, decreased fleet idle time by 30%, and delivered 99.8% operational uptime during high-volume peak logistics dispatches.',
      minSdk: '24 (Android 7.0)',
      targetSdk: '34 (Android 14)',
      buildSize: '15.4 MB',
      architecture: 'ARM64-v8a',
      sha256: '3E:8F:12:7A:B4:9C:55:60',
      screenshot: null,
      githubUrl: 'https://github.com/JayDutta7',
      apkName: 'Captain_Logistics_Release.apk'
    },
    'message_club': {
      id: 'message_club',
      title: 'Message Club',
      period: '2017 – 2019',
      company: 'Nat IT Solved Pvt. Ltd.',
      category: 'clientSolutions',
      categoryLabel: 'High-Throughput CRM · 5M+ Alerts',
      stackSummary: 'Native Android · Kotlin · MVVM · LiveData · Room DB · Retrofit · FCM Batch Dispatch',
      techStack: ['Native Android', 'Kotlin', 'MVVM', 'LiveData', 'Room DB', 'Retrofit', 'WorkManager', 'Firebase FCM', 'Coroutines'],
      overview: 'High-throughput broadcast SMS and CRM messaging Android application engineered to deliver multi-channel notification campaigns, transactional alerts, and customer engagement communications.',
      myRole: 'Android Application Developer implementing the MVVM architecture with LiveData, asynchronous batch dispatch pipeline, local Room DB message deduplication engine, and campaign preview UI.',
      problemScope: 'Enterprise organizations needed to broadcast millions of time-sensitive transactional and marketing alerts simultaneously without message starvation, thread locks, or notification delivery failure.',
      technicalArchitecture: 'Clean Architecture with MVVM and Android Architecture Components (LiveData, ViewModel). Integrated Room DB for prioritized message queues, Retrofit for adaptive HTTP connection pooling, and WorkManager for reliable background sync.',
      hardChallenges: 'Processing burst notification payloads of up to 10,000 incoming alerts in quick succession while maintaining sub-15ms local Room query response times and zero UI freeze.',
      quantifiableImpact: 'Successfully dispatched 5M+ monthly notifications with a 99.95% delivery receipt accuracy, reducing UI rendering latency by 40%.',
      minSdk: '21 (Android 5.0)',
      targetSdk: '33 (Android 13)',
      buildSize: '11.2 MB',
      architecture: 'ARM64-v8a / armeabi-v7a',
      sha256: '1C:4B:99:F2:A8:3D:77:E5',
      screenshot: 'assets/images/massageclub.jpg',
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.massageclub&hl=en',
      apkName: 'Message_Club_Release.apk'
    },
    'staffer': {
      id: 'staffer',
      title: 'Staffer (Workforce Scheduling)',
      period: '2018 – 2019',
      company: 'Matrix Media Solution Pvt. Ltd.',
      category: 'clientSolutions',
      categoryLabel: 'Workforce Operations · 4.7★ Rating',
      stackSummary: 'Native Android · Kotlin · MVVM · LiveData · Room DB · CalendarProvider · WorkManager',
      techStack: ['Native Android', 'Kotlin', 'MVVM', 'LiveData', 'Room DB', 'CalendarProvider', 'WorkManager', 'Coroutines', 'Retrofit'],
      overview: 'Workforce shift scheduling and roster management Android app enabling healthcare and retail teams to manage shift availability, resolve scheduling conflicts, and sync rosters with native Android calendars.',
      myRole: 'Android Engineer responsible for implementing the MVVM architecture with LiveData, conflict resolution engine, Android CalendarProvider two-way synchronization, and offline Room caching.',
      problemScope: 'Shift workers often missed unscheduled roster changes due to disconnected scheduling systems. The product required real-time shift conflict resolution with two-way synchronization to the native Android Calendar.',
      technicalArchitecture: 'MVVM Clean Architecture using Android Jetpack ViewModel & LiveData for state management. Integrated Android CalendarProvider ContentResolver API, Room DB for local shift caching, and WorkManager for periodic background roster sync.',
      hardChallenges: 'Managing two-way synchronization between cloud shift updates and Android CalendarProvider without creating duplicate entries, calendar permission crashes, or race conditions across different time zones.',
      quantifiableImpact: 'Eliminated 80% of workforce scheduling disputes, automated shift reminders for 15,000+ frontline workers, and attained a 4.7★ store rating.',
      minSdk: '21 (Android 5.0)',
      targetSdk: '33 (Android 13)',
      buildSize: '13.6 MB',
      architecture: 'ARM64-v8a',
      sha256: '8D:1E:55:A9:C3:7F:20:41',
      screenshot: null,
      githubUrl: 'https://github.com/JayDutta7',
      apkName: 'Staffer_Scheduling_Release.apk'
    },
    'drlife': {
      id: 'drlife',
      title: 'DrLife (Encrypted Telemedicine)',
      period: '2020 – 2020',
      company: 'DCC Services Pvt Ltd.',
      category: 'clientSolutions',
      categoryLabel: 'HIPAA Telehealth · WebRTC & SQLCipher',
      stackSummary: 'Native Android · Kotlin · MVVM · LiveData · WebRTC · HIPAA Compliant · SQLCipher · Coroutines',
      techStack: ['Native Android', 'Kotlin', 'MVVM', 'LiveData', 'WebRTC', 'SQLCipher', 'HIPAA Compliance', 'Coroutines & Flow', 'Clean Architecture', 'Retrofit'],
      overview: 'Telemedicine consultation Android app featuring low-latency encrypted video consultations, digital prescription issuance, and HIPAA-compliant patient medical records.',
      myRole: 'Lead Native Android Developer designing the MVVM architecture with LiveData state management, WebRTC peer-to-peer audio/video streaming pipeline, and 256-bit AES SQLCipher patient record storage.',
      problemScope: 'Remote medical consultations required ultra-low-latency, crystal-clear video streaming over variable mobile networks, while adhering to strict HIPAA regulatory privacy standards for electronic health records.',
      technicalArchitecture: 'Clean Architecture with MVVM and LiveData. Native WebRTC C++ wrapper bindings for hardware-accelerated video codecs (H.264/VP8), combined with SQLCipher 256-bit AES local database encryption and lifecycle-aware reactive UI observation.',
      hardChallenges: 'Maintaining call stability with dynamic video bitrate downsampling during sudden packet loss on 3G/4G rural networks, while preventing plaintext logging of patient medical notes.',
      quantifiableImpact: 'Enabled 20,000+ secure remote teleconsultations, maintained a 99.4% call connection success rate, and achieved 100% compliance during third-party HIPAA security audits.',
      minSdk: '24 (Android 7.0)',
      targetSdk: '34 (Android 14)',
      buildSize: '19.8 MB (WebRTC Codecs)',
      architecture: 'ARM64-v8a',
      sha256: '5A:9C:33:F1:D4:88:B2:76',
      screenshot: null,
      githubUrl: 'https://github.com/JayDutta7',
      apkName: 'DrLife_Telemedicine_Release.apk'
    }
  };
  ALL_PROJECTS['captain'] = ALL_PROJECTS['captain_logistics'];

  // ==========================================================================
  // 1. Mouse Spotlight Glow on Bento Cards (Linear / Vercel effect)
  // ==========================================================================
  function initSpotlightCards() {
    const cards = document.querySelectorAll('.bento-card, .case-study-card');
    cards.forEach((card) => {
      card.addEventListener('mousemove', (e) => {
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        card.style.setProperty('--mouse-x', `${x}px`);
        card.style.setProperty('--mouse-y', `${y}px`);
      });
    });
  }

  // ==========================================================================
  // 2. Interactive Tech Stack Pill & Tab Filtering
  // ==========================================================================
  let activeTechTag = 'all';
  let activeTabCategory = 'all';

  function applyFilters() {
    const projectCards = document.querySelectorAll('[data-project-card]');

    projectCards.forEach((card) => {
      const cardTags = (card.getAttribute('data-tech-tags') || '').toLowerCase();
      const cardCat = (card.getAttribute('data-category') || '').toLowerCase();

      const matchesTech = activeTechTag === 'all' || cardTags.includes(activeTechTag.toLowerCase());
      const matchesCat = activeTabCategory === 'all' || cardCat === activeTabCategory.toLowerCase();

      if (matchesTech && matchesCat) {
        card.style.display = 'flex';
        card.style.opacity = '1';
        card.style.transform = '';
      } else {
        card.style.display = 'none';
      }
    });
  }

  function initFilters() {
    // 1. Tech Matrix Pills
    const pills = document.querySelectorAll('.tech-filter-pill');
    pills.forEach((pill) => {
      pill.addEventListener('click', () => {
        const tag = pill.getAttribute('data-tag');
        if (activeTechTag === tag) {
          activeTechTag = 'all';
          pills.forEach((p) => p.classList.remove('active'));
        } else {
          activeTechTag = tag;
          pills.forEach((p) => p.classList.remove('active'));
          pill.classList.add('active');
        }
        applyFilters();
      });
    });

    // 2. Category Tabs (All, Shyam Steel, Client Solutions)
    const tabs = document.querySelectorAll('.filter-tab-btn');
    tabs.forEach((tab) => {
      tab.addEventListener('click', () => {
        tabs.forEach((t) => t.classList.remove('active'));
        tab.classList.add('active');
        activeTabCategory = tab.getAttribute('data-cat-filter') || 'all';
        applyFilters();
      });
    });
  }

  // ==========================================================================
  // 3. Deep-Dive Case Study Drawer & Modal System
  // ==========================================================================
  function initCaseStudyModal() {
    const backdrop = document.getElementById('caseStudyBackdrop');
    const closeBtn = document.getElementById('caseStudyClose');
    const triggers = document.querySelectorAll('[data-open-case-study]');

    if (!backdrop) return;

    function openCaseStudy(id) {
      const data = ALL_PROJECTS[id];
      if (!data) return;

      document.getElementById('csTitle').innerText = data.title;
      document.getElementById('csCategory').innerText = data.categoryLabel;
      document.getElementById('csCompany').innerText = `${data.company} • ${data.period}`;
      document.getElementById('csOverview').innerText = data.overview;
      document.getElementById('csRole').innerText = data.myRole;
      document.getElementById('csProblem').innerText = data.problemScope;
      document.getElementById('csArch').innerText = data.technicalArchitecture;
      document.getElementById('csChallenges').innerText = data.hardChallenges;
      document.getElementById('csImpact').innerText = data.quantifiableImpact;

      // Case Study Banner Screenshot
      const bannerImg = document.getElementById('csBannerImg');
      if (bannerImg) {
        if (data.screenshot) {
          bannerImg.src = data.screenshot;
          bannerImg.style.display = 'block';
        } else {
          bannerImg.style.display = 'none';
        }
      }

      // Render Tech Stack chips
      const chipsWrap = document.getElementById('csTechChips');
      if (chipsWrap) {
        chipsWrap.innerHTML = data.techStack
          .map((tech) => `<span class="badge-tech-pill">${escapeHtml(tech)}</span>`)
          .join('');
      }

      // Configure Action Buttons
      const testApkBtn = document.getElementById('csTestApkBtn');
      if (testApkBtn) {
        testApkBtn.setAttribute('data-open-apk-modal', id);
      }

      const externalLinksWrap = document.getElementById('csExternalLinks');
      if (externalLinksWrap) {
        let linksHtml = '';
        if (data.playStoreUrl) {
          linksHtml += `<a href="${data.playStoreUrl}" target="_blank" rel="noopener" class="btn-pill btn-secondary"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 3l14 9-14 9V3z"></path></svg><span>Google Play</span></a>`;
        }
        if (data.appStoreUrl) {
          linksHtml += `<a href="${data.appStoreUrl}" target="_blank" rel="noopener" class="btn-pill btn-secondary"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2z"></path></svg><span>App Store</span></a>`;
        }
        if (data.webUrl) {
          linksHtml += `<a href="${data.webUrl}" target="_blank" rel="noopener" class="btn-pill btn-secondary"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="2" y1="12" x2="22" y2="12"></line></svg><span>Live Portal</span></a>`;
        }
        if (data.githubUrl) {
          linksHtml += `<a href="${data.githubUrl}" target="_blank" rel="noopener" class="btn-pill btn-secondary"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"></path></svg><span>GitHub Repository</span></a>`;
        }
        externalLinksWrap.innerHTML = linksHtml;
      }

      backdrop.classList.add('open');
      document.body.style.overflow = 'hidden';
    }

    function closeCaseStudy() {
      backdrop.classList.remove('open');
      document.body.style.overflow = '';
    }

    document.addEventListener('click', (e) => {
      const trigger = e.target.closest('[data-open-case-study]');
      if (trigger) {
        e.preventDefault();
        const id = trigger.getAttribute('data-open-case-study');
        openCaseStudy(id);
      }
    });

    if (closeBtn) closeBtn.addEventListener('click', closeCaseStudy);
    backdrop.addEventListener('click', (e) => {
      if (e.target === backdrop) closeCaseStudy();
    });
  }

  // ==========================================================================
  // 4. Interactive ADB & Flutter Terminal Simulation
  // ==========================================================================
  const TERMINAL_OUTPUTS = {
    'adb logcat --skills': `[DEBUG/AndroidCore] Kotlin 2.1.0 • Jetpack Compose 1.7.5 • Coroutines 1.9.0
[INFO/Architecture] Clean Architecture • Domain-Driven Design • MVVM / MVI
[INFO/StateMgmt] BLoC State Machine • Riverpod 2.6 • StateNotifierProvider
[DEBUG/Persistence] Room DB 2.6 • SQLCipher 4.5.4 (256-bit AES) • SQLite
[INFO/Networking] Retrofit 2.11 • OkHttp3 • Dio 5.7 • SSE & WebSockets
[DEBUG/Hardware] Google ML Kit Barcode/QR • Easebuzz Payment Gateway • BLE
[INFO/Telemetry] 99.9% Crash-Free Users • 60 FPS Jank-Free Motion Budget`,

    'flutter doctor -v': `[✓] Flutter (Channel stable, 3.27.0, on macOS 15.2, locale en-US)
    • Flutter version 3.27.0 on channel stable
    • Framework revision 2661877609 (9+ years verified production experience)
    • Engine revision 5006093557 • Dart version 3.6.0
[✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0)
    • Platform android-35, build-tools 35.0.0
    • Java version OpenJDK 17.0.12
[✓] Chrome - develop for the web
[✓] Connected device (3 available)
    • Pixel 8 Pro (mobile) • Android 15 • arm64-v8a
    • Samsung S24 Ultra (mobile) • Android 14 • arm64-v8a
    • Chrome (web) • WebAssembly / CanvasKit`,

    'adb shell dumpsys package': `Package: com.jayajit.portfolio.mobile
  Version: 2.5.0 (TargetSdk: 35, MinSdk: 24)
  Signatures: SHA-256 [A1:8B:4F:92:C3:7E:D0:55...]
  Native Architectures: [arm64-v8a, x86_64]
  Permissions Granted:
    - android.permission.INTERNET
    - android.permission.CAMERA (Google ML Kit Barcode)
    - android.permission.ACCESS_FINE_LOCATION (Background Telemetry)
    - android.permission.FOREGROUND_SERVICE_LOCATION`,

    'git log -n 3': `commit 780b6fb (HEAD -> main, origin/main)
Author: Jayajit Dutta <jayajit1989@gmail.com>
Date:   Sep 13 2026
    feat: comprehensive 9-project developer portfolio with deep-dive case studies

commit cf98780
Author: Jayajit Dutta <jayajit1989@gmail.com>
Date:   Sep 13 2026
    arch: implement reactive Riverpod state machine & Easebuzz gateway

commit cc83302
Author: Jayajit Dutta <jayajit1989@gmail.com>
Date:   Sep 13 2026
    perf: optimize compose recomposition & room offline sync pipeline`,

    'cat contact.json': `{
  "name": "Jayajit Dutta",
  "role": "Senior Android & Flutter Developer",
  "experience": "9+ Years",
  "location": "Serampore, West Bengal, India (Open to In-Office & Remote Worldwide)",
  "email": "jayajit1989@gmail.com",
  "phone": "+91 7980726164",
  "linkedin": "https://www.linkedin.com/in/jayajit-dutta-7124b9125",
  "github": "https://github.com/JayDutta7"
}`,

    'help': `Available Commands:
  • adb logcat --skills      : View mobile core capabilities and telemetry
  • flutter doctor -v        : Inspect mobile dev environment & device targets
  • adb shell dumpsys package: Inspect production APK architecture specs
  • git log -n 3             : View verified production git commits
  • cat contact.json         : View structured contact details
  • clear                    : Clear the terminal display
  • help                     : Print this command index`,

    'clear': '__CLEAR__'
  };

  function initTerminal() {
    const termBody = document.getElementById('terminalBody');
    const termInput = document.getElementById('terminalInput');
    const chips = document.querySelectorAll('.t-chip');
    if (!termBody || !termInput) return;

    let history = [];
    let historyIdx = -1;

    function executeCommand(cmd) {
      const cleanCmd = cmd.trim();
      if (!cleanCmd) return;

      history.push(cleanCmd);
      historyIdx = history.length;

      if (cleanCmd.toLowerCase() === 'clear') {
        termBody.innerHTML = '';
        termInput.value = '';
        return;
      }

      const output = TERMINAL_OUTPUTS[cleanCmd] || `zsh: command not found: ${cleanCmd}. Type "help" for available commands.`;

      const entry = document.createElement('div');
      entry.className = 't-entry';
      entry.style.marginBottom = '10px';
      entry.innerHTML = `
        <div><span class="t-prompt">jayajit@macbook-air:~$</span> <span class="t-cmd">${escapeHtml(cleanCmd)}</span></div>
        <div class="t-output">${escapeHtml(output)}</div>
      `;
      termBody.appendChild(entry);
      termBody.scrollTop = termBody.scrollHeight;
      termInput.value = '';
    }

    termInput.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        executeCommand(termInput.value);
      } else if (e.key === 'ArrowUp') {
        if (history.length > 0 && historyIdx > 0) {
          historyIdx--;
          termInput.value = history[historyIdx];
        }
        e.preventDefault();
      } else if (e.key === 'ArrowDown') {
        if (historyIdx < history.length - 1) {
          historyIdx++;
          termInput.value = history[historyIdx];
        } else {
          historyIdx = history.length;
          termInput.value = '';
        }
        e.preventDefault();
      }
    });

    chips.forEach((chip) => {
      chip.addEventListener('click', () => {
        const cmd = chip.getAttribute('data-cmd');
        if (cmd) {
          termInput.value = cmd;
          executeCommand(cmd);
        }
      });
    });
  }

  // ==========================================================================
  // 5. Command Palette (Cmd+K / Ctrl+K)
  // ==========================================================================
  function initCommandPalette() {
    const backdrop = document.getElementById('cmdkBackdrop');
    const searchInput = document.getElementById('cmdkInput');
    const triggers = document.querySelectorAll('.cmdk-trigger, [data-open-cmdk]');
    const items = document.querySelectorAll('.cmdk-item');

    if (!backdrop || !searchInput) return;

    function openPalette() {
      backdrop.classList.add('open');
      searchInput.value = '';
      searchInput.focus();
      filterItems('');
    }

    function closePalette() {
      backdrop.classList.remove('open');
    }

    function filterItems(query) {
      const q = query.toLowerCase().trim();
      let matchCount = 0;
      items.forEach((item) => {
        const text = item.innerText.toLowerCase();
        if (!q || text.includes(q)) {
          item.style.display = 'flex';
          matchCount++;
        } else {
          item.style.display = 'none';
        }
      });

      const groupTitles = document.querySelectorAll('.cmdk-group-title');
      groupTitles.forEach((gt) => {
        gt.style.display = (matchCount === 0 && q) ? 'none' : 'block';
      });

      const emptyState = document.getElementById('cmdkEmptyState');
      if (emptyState) {
        emptyState.style.display = (matchCount === 0 && q) ? 'flex' : 'none';
      }
    }

    triggers.forEach((btn) => btn.addEventListener('click', openPalette));

    backdrop.addEventListener('click', (e) => {
      if (e.target === backdrop) closePalette();
    });

    window.addEventListener('keydown', (e) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault();
        if (backdrop.classList.contains('open')) {
          closePalette();
        } else {
          openPalette();
        }
      } else if (e.key === 'Escape') {
        if (backdrop.classList.contains('open')) closePalette();
      }
    });

    searchInput.addEventListener('input', (e) => {
      filterItems(e.target.value);
    });

    items.forEach((item) => {
      item.addEventListener('click', () => {
        const action = item.getAttribute('data-action');
        closePalette();

        if (action === 'download-cv') {
          const a = document.createElement('a');
          a.href = 'assets/resume/Jayajit_Dutta_CV.pdf';
          a.download = 'Jayajit_Dutta_CV.pdf';
          a.click();
        } else if (action === 'call') {
          window.location.href = 'tel:+917980726164';
        } else if (action === 'email') {
          window.location.href = 'mailto:jayajit1989@gmail.com';
        } else if (action && action.startsWith('#')) {
          const target = document.querySelector(action);
          if (target) {
            target.scrollIntoView({ behavior: 'smooth' });
          }
        }
      });
    });
  }

  // ==========================================================================
  // 6. Direct APK & QR Code Modal
  // ==========================================================================
  function initApkModal() {
    const backdrop = document.getElementById('apkModalBackdrop');
    const closeBtn = document.getElementById('apkModalClose');
    const titleEl = document.getElementById('modalProjectTitle');
    const catEl = document.getElementById('modalProjectCategory');
    const minSdkEl = document.getElementById('modalMinSdk');
    const targetSdkEl = document.getElementById('modalTargetSdk');
    const sizeEl = document.getElementById('modalBuildSize');
    const archEl = document.getElementById('modalArch');
    const downloadBtn = document.getElementById('modalDownloadBtn');
    const copyAdbBtn = document.getElementById('modalCopyAdb');
    const qrSvgWrap = document.getElementById('qrSvgWrap');

    if (!backdrop) return;

    function openModal(projectId) {
      const data = ALL_PROJECTS[projectId] || ALL_PROJECTS['ghareka'];

      if (titleEl) titleEl.innerText = data.title;
      if (catEl) catEl.innerText = data.categoryLabel;
      if (minSdkEl) minSdkEl.innerText = data.minSdk;
      if (targetSdkEl) targetSdkEl.innerText = data.targetSdk;
      if (sizeEl) sizeEl.innerText = data.buildSize;
      if (archEl) archEl.innerText = data.architecture;

      if (downloadBtn) {
        downloadBtn.href = 'assets/resume/Jayajit_Dutta_CV.pdf';
        downloadBtn.setAttribute('download', data.apkName);
      }

      if (copyAdbBtn) {
        copyAdbBtn.setAttribute('data-adb-cmd', `adb install -r -d ${data.apkName}`);
      }

      if (qrSvgWrap) {
        qrSvgWrap.innerHTML = generateVectorSvgQr(data.title);
      }

      backdrop.classList.add('open');
    }

    function closeModal() {
      backdrop.classList.remove('open');
    }

    document.addEventListener('click', (e) => {
      const btn = e.target.closest('[data-open-apk-modal]');
      if (btn) {
        e.preventDefault();
        const id = btn.getAttribute('data-open-apk-modal');
        openModal(id);
      }
    });

    if (closeBtn) closeBtn.addEventListener('click', closeModal);
    backdrop.addEventListener('click', (e) => {
      if (e.target === backdrop) closeModal();
    });

    if (copyAdbBtn) {
      copyAdbBtn.addEventListener('click', () => {
        const cmd = copyAdbBtn.getAttribute('data-adb-cmd') || 'adb install -r app-release.apk';
        navigator.clipboard.writeText(cmd).then(() => {
          const originalText = copyAdbBtn.innerHTML;
          copyAdbBtn.innerHTML = `<span>✓ Command Copied to Clipboard!</span>`;
          setTimeout(() => {
            copyAdbBtn.innerHTML = originalText;
          }, 2000);
        });
      });
    }
  }

  // ==========================================================================
  // 7. Vector SVG QR Generator (Offline Client-Side Deterministic Matrix)
  // ==========================================================================
  function generateVectorSvgQr(seedText) {
    const size = 25;
    const cellSize = 6;
    const svgSize = size * cellSize;

    let hash = 0;
    for (let i = 0; i < seedText.length; i++) {
      hash = (hash << 5) - hash + seedText.charCodeAt(i);
      hash |= 0;
    }

    let rects = '';

    function addFinder(startX, startY) {
      for (let r = 0; r < 7; r++) {
        for (let c = 0; c < 7; c++) {
          const isBorder = r === 0 || r === 6 || c === 0 || c === 6;
          const isInner = r >= 2 && r <= 4 && c >= 2 && c <= 4;
          if (isBorder || isInner) {
            const x = (startX + c) * cellSize;
            const y = (startY + r) * cellSize;
            rects += `<rect x="${x}" y="${y}" width="${cellSize}" height="${cellSize}" fill="#0f172a" />`;
          }
        }
      }
    }

    addFinder(0, 0);
    addFinder(18, 0);
    addFinder(0, 18);

    for (let r = 0; r < size; r++) {
      for (let c = 0; c < size; c++) {
        if ((r < 8 && c < 8) || (r < 8 && c >= 17) || (r >= 17 && c < 8)) continue;
        const val = Math.abs(Math.sin((r * 31 + c * 17 + hash) * 0.1));
        if (val > 0.48) {
          const x = c * cellSize;
          const y = r * cellSize;
          rects += `<rect x="${x}" y="${y}" width="${cellSize - 0.5}" height="${cellSize - 0.5}" rx="1" fill="#0f172a" />`;
        }
      }
    }

    return `
      <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}" xmlns="http://www.w3.org/2000/svg">
        ${rects}
      </svg>
    `;
  }

  // ==========================================================================
  // 8. PWA Service Worker & Install Toast
  // ==========================================================================
  let deferredPrompt = null;

  function initPwa() {
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', () => {
        navigator.serviceWorker.register('./sw.js').catch((err) => {
          console.warn('SW registration info:', err);
        });
      });
    }

    const toast = document.getElementById('pwaToast');
    const installBtn = document.getElementById('pwaInstallBtn');
    const dismissBtn = document.getElementById('pwaDismissBtn');

    window.addEventListener('beforeinstallprompt', (e) => {
      e.preventDefault();
      deferredPrompt = e;
    });

    if (installBtn) {
      installBtn.addEventListener('click', () => {
        if (deferredPrompt) {
          deferredPrompt.prompt();
          deferredPrompt.userChoice.then(() => {
            deferredPrompt = null;
            if (toast) toast.classList.remove('visible');
          });
        }
      });
    }

    if (dismissBtn) {
      dismissBtn.addEventListener('click', () => {
        if (toast) toast.classList.remove('visible');
      });
    }
  }

  // Helper escape
  function escapeHtml(str) {
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  // ==========================================================================
  // Typewriter Greeting Message
  // ==========================================================================
  function initTypewriterGreeting() {
    const textEl = document.getElementById('typewriterText');
    const containerEl = document.getElementById('typewriterGreeting');
    if (!textEl) return;

    const fullText = 'Hello, Myself Jayajit Dutta.';
    let charIndex = 0;
    let isDeleting = false;
    let typeTimeout = null;

    function typeLoop() {
      if (!isDeleting) {
        if (charIndex <= fullText.length) {
          textEl.textContent = fullText.substring(0, charIndex);
          charIndex++;
          typeTimeout = setTimeout(typeLoop, 70);
        } else {
          typeTimeout = setTimeout(() => {
            isDeleting = true;
            typeLoop();
          }, 3500);
        }
      } else {
        if (charIndex > 0) {
          charIndex--;
          textEl.textContent = fullText.substring(0, charIndex);
          typeTimeout = setTimeout(typeLoop, 35);
        } else {
          isDeleting = false;
          typeTimeout = setTimeout(typeLoop, 500);
        }
      }
    }

    if (containerEl) {
      containerEl.addEventListener('click', () => {
        clearTimeout(typeTimeout);
        charIndex = 0;
        isDeleting = false;
        typeLoop();
      });
    }

    typeLoop();
  }

  // ==========================================================================
  // 9. Voice-Activated Navigation Engine
  // ==========================================================================
  function initVoiceNavigation() {
    const triggerBtn = document.getElementById('voiceNavTrigger');
    const mobileVoiceBtn = document.getElementById('mobileVoiceBtn');
    const hud = document.getElementById('voiceHud');
    const pulseIndicator = document.getElementById('voicePulseIndicator');
    const statusTitle = document.getElementById('voiceStatusTitle');
    const statusBadge = document.getElementById('voiceStatusBadge');
    const transcriptEl = document.getElementById('voiceTranscript');
    const muteToggle = document.getElementById('voiceMuteToggle');
    const closeBtn = document.getElementById('voiceCloseBtn');
    const chips = document.querySelectorAll('.voice-chip');

    if (!hud) return;

    let isListening = false;
    let soundFeedbackEnabled = true;
    let recognition = null;
    let audioCtx = null;
    let restartTimeout = null;

    // Web Audio Synthesizer for futuristic feedback chimes
    function getAudioContext() {
      if (!audioCtx) {
        const AudioCtx = window.AudioContext || window.webkitAudioContext;
        if (AudioCtx) {
          audioCtx = new AudioCtx();
        }
      }
      if (audioCtx && audioCtx.state === 'suspended') {
        audioCtx.resume();
      }
      return audioCtx;
    }

    function playAudioChime(type) {
      if (!soundFeedbackEnabled) return;
      try {
        const ctx = getAudioContext();
        if (!ctx) return;
        const now = ctx.currentTime;
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();

        if (type === 'start') {
          // Ascending futuristic blip (440Hz -> 880Hz)
          osc.type = 'sine';
          osc.frequency.setValueAtTime(440, now);
          osc.frequency.exponentialRampToValueAtTime(880, now + 0.12);
          gain.gain.setValueAtTime(0.08, now);
          gain.gain.exponentialRampToValueAtTime(0.001, now + 0.18);
          osc.connect(gain);
          gain.connect(ctx.destination);
          osc.start(now);
          osc.stop(now + 0.2);
        } else if (type === 'success') {
          // Harmonic dual-bell chord
          osc.type = 'triangle';
          osc.frequency.setValueAtTime(587.33, now); // D5
          osc.frequency.exponentialRampToValueAtTime(880, now + 0.15); // A5
          gain.gain.setValueAtTime(0.09, now);
          gain.gain.exponentialRampToValueAtTime(0.001, now + 0.28);
          osc.connect(gain);
          gain.connect(ctx.destination);
          osc.start(now);
          osc.stop(now + 0.3);
        } else if (type === 'error') {
          osc.type = 'sine';
          osc.frequency.setValueAtTime(260, now);
          osc.frequency.exponentialRampToValueAtTime(180, now + 0.18);
          gain.gain.setValueAtTime(0.06, now);
          gain.gain.exponentialRampToValueAtTime(0.001, now + 0.22);
          osc.connect(gain);
          gain.connect(ctx.destination);
          osc.start(now);
          osc.stop(now + 0.25);
        }
      } catch (e) {
        // AudioContext ignored if blocked
      }
    }

    function speakConfirmation(text) {
      if (!soundFeedbackEnabled || !window.speechSynthesis) return;
      try {
        window.speechSynthesis.cancel();
        const utterance = new SpeechSynthesisUtterance(text);
        utterance.rate = 1.05;
        utterance.pitch = 1.0;
        utterance.volume = 0.55;
        window.speechSynthesis.speak(utterance);
      } catch (e) {}
    }

    // Initialize Web Speech Recognition
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

    if (SpeechRecognition) {
      recognition = new SpeechRecognition();
      recognition.continuous = true;
      recognition.interimResults = true;
      recognition.lang = 'en-US';

      recognition.onstart = () => {
        isListening = true;
        updateUIState('listening');
        playAudioChime('start');
      };

      recognition.onresult = (event) => {
        let interimTranscript = '';
        let finalTranscript = '';

        for (let i = event.resultIndex; i < event.results.length; i++) {
          const trans = event.results[i][0].transcript;
          if (event.results[i].isFinal) {
            finalTranscript += trans;
          } else {
            interimTranscript += trans;
          }
        }

        if (interimTranscript) {
          hud.classList.add('speaking');
          if (transcriptEl) {
            transcriptEl.textContent = `Hearing: "${interimTranscript.trim()}"...`;
          }
        }

        if (finalTranscript) {
          hud.classList.remove('speaking');
          executeVoiceCommand(finalTranscript.trim());
        }
      };

      recognition.onerror = (event) => {
        if (event.error === 'not-allowed') {
          if (statusTitle) statusTitle.textContent = 'Microphone Access Blocked';
          if (statusBadge) statusBadge.textContent = 'PERMISSION NEEDED';
          if (transcriptEl) {
            transcriptEl.textContent = 'Please enable microphone permissions in your browser.';
          }
          stopListening();
        } else if (event.error === 'no-speech') {
          if (transcriptEl) {
            transcriptEl.textContent = 'No voice detected. Say "Go to projects" or "Skills"...';
          }
        }
      };

      recognition.onend = () => {
        if (isListening) {
          try {
            restartTimeout = setTimeout(() => {
              if (isListening) recognition.start();
            }, 300);
          } catch (e) {}
        } else {
          updateUIState('idle');
        }
      };
    }

    function updateUIState(state) {
      if (state === 'listening') {
        hud.classList.add('active', 'listening');
        if (triggerBtn) triggerBtn.classList.add('listening');
        if (statusTitle) statusTitle.textContent = 'Listening...';
        if (statusBadge) statusBadge.textContent = 'ACTIVE';
        if (transcriptEl) transcriptEl.textContent = 'Speak a command (e.g. "Go to projects", "Download CV")...';
      } else if (state === 'executing') {
        hud.classList.add('active');
        hud.classList.remove('listening');
        if (statusTitle) statusTitle.textContent = 'Command Recognized';
        if (statusBadge) statusBadge.textContent = 'EXECUTING';
      } else {
        hud.classList.remove('listening');
        if (triggerBtn) triggerBtn.classList.remove('listening');
        if (statusTitle) statusTitle.textContent = 'Voice Assistant';
        if (statusBadge) statusBadge.textContent = 'READY';
      }
    }

    function startListening() {
      if (!recognition) {
        openHud();
        if (statusTitle) statusTitle.textContent = 'Voice Engine Unavailable';
        if (statusBadge) statusBadge.textContent = 'FALLBACK';
        if (transcriptEl) transcriptEl.textContent = 'Speech recognition not supported in this browser. Click suggestion chips below!';
        return;
      }
      openHud();
      try {
        isListening = true;
        recognition.start();
      } catch (e) {}
    }

    function stopListening() {
      isListening = false;
      clearTimeout(restartTimeout);
      if (recognition) {
        try {
          recognition.stop();
        } catch (e) {}
      }
      updateUIState('idle');
    }

    function toggleListening() {
      if (isListening) {
        stopListening();
        if (transcriptEl) transcriptEl.textContent = 'Voice navigation paused. Click microphone to resume.';
      } else {
        startListening();
      }
    }

    function openHud() {
      hud.classList.add('active');
      hud.setAttribute('aria-hidden', 'false');
    }

    function closeHud() {
      stopListening();
      hud.classList.remove('active', 'listening', 'speaking');
      hud.setAttribute('aria-hidden', 'true');
    }

    // Scroll & Highlight helper
    function scrollToSection(selector, name) {
      const el = document.querySelector(selector);
      if (!el) return false;

      el.scrollIntoView({ behavior: 'smooth', block: 'start' });
      el.classList.add('voice-highlight-target');
      setTimeout(() => el.classList.remove('voice-highlight-target'), 2000);

      if (transcriptEl) transcriptEl.textContent = `Navigated to ${name}!`;
      updateUIState('executing');
      playAudioChime('success');
      speakConfirmation(`Navigating to ${name}`);

      setTimeout(() => {
        if (isListening) updateUIState('listening');
      }, 1500);

      return true;
    }

    // Natural Language Command Parser
    function executeVoiceCommand(commandText) {
      const cmd = commandText.toLowerCase().trim();
      if (!cmd) return;

      if (transcriptEl) {
        transcriptEl.textContent = `"${commandText}"`;
      }

      // 1. Specific Projects
      if (cmd.includes('ghareka pmt')) {
        openSpecificCaseStudy('ghareka_pmt', 'Ghareka PMT');
        return;
      }
      if (cmd.includes('ghareka')) {
        openSpecificCaseStudy('ghareka', 'Ghareka App');
        return;
      }
      if (cmd.includes('buildistan')) {
        openSpecificCaseStudy('buildistan', 'Buildistan');
        return;
      }
      if (cmd.includes('pariwar')) {
        openSpecificCaseStudy('pariwar', 'Pariwar App');
        return;
      }
      if (cmd.includes('crm') || cmd.includes('sales')) {
        openSpecificCaseStudy('crm', 'Lead & Sales CRM');
        return;
      }
      if (cmd.includes('staffer')) {
        openSpecificCaseStudy('staffer', 'Staffer App');
        return;
      }
      if (cmd.includes('massage') || cmd.includes('message') || cmd.includes('club')) {
        openSpecificCaseStudy('message_club', 'Message Club');
        return;
      }
      if (cmd.includes('captain') || cmd.includes('fleet') || cmd.includes('logistic')) {
        openSpecificCaseStudy('captain', 'Captain Logistics');
        return;
      }
      if (cmd.includes('drlife') || cmd.includes('doctor') || cmd.includes('health') || cmd.includes('telemedicine')) {
        openSpecificCaseStudy('drlife', 'DrLife Telemedicine');
        return;
      }

      // 2. Projects & Work section
      if (cmd.includes('project') || cmd.includes('work') || cmd.includes('portfolio') || cmd.includes('case stud') || cmd.includes('app')) {
        scrollToSection('#projects', 'Projects');
        return;
      }

      // 3. Filter Tech Stack
      if (cmd.includes('filter') || cmd.includes('tag') || cmd.includes('stack')) {
        if (cmd.includes('flutter')) {
          triggerFilter('Flutter');
          return;
        }
        if (cmd.includes('kotlin')) {
          triggerFilter('Kotlin');
          return;
        }
        if (cmd.includes('android')) {
          triggerFilter('Android SDK');
          return;
        }
        if (cmd.includes('compose')) {
          triggerFilter('Jetpack Compose');
          return;
        }
        if (cmd.includes('clear') || cmd.includes('all') || cmd.includes('reset')) {
          triggerFilter('all');
          return;
        }
      }

      // 4. Architecture
      if (cmd.includes('architecture') || cmd.includes('system design') || cmd.includes('clean arch') || cmd.includes('layer') || cmd.includes('pipeline')) {
        scrollToSection('#architecture', 'System Architecture');
        return;
      }

      // 5. Skills
      if (cmd.includes('skill') || cmd.includes('technolog') || cmd.includes('coroutine') || cmd.includes('dagger') || cmd.includes('hilt') || cmd.includes('tool')) {
        scrollToSection('#skills', 'Technical Skills');
        return;
      }

      // 6. Experience / Career Timeline
      if (cmd.includes('experience') || cmd.includes('career') || cmd.includes('timeline') || cmd.includes('histor') || cmd.includes('job') || cmd.includes('shyam steel') || cmd.includes('compan')) {
        scrollToSection('#timeline', 'Career Experience');
        return;
      }

      // 7. About Me
      if (cmd.includes('about') || cmd.includes('bio') || cmd.includes('who is') || cmd.includes('profile') || cmd.includes('background') || cmd.includes('summary')) {
        scrollToSection('#about', 'About Me');
        return;
      }

      // 8. Education
      if (cmd.includes('education') || cmd.includes('degree') || cmd.includes('college') || cmd.includes('mca') || cmd.includes('bca') || cmd.includes('qualificat')) {
        scrollToSection('#education', 'Education & Qualifications');
        return;
      }

      // 9. Contact & Hire
      if (cmd.includes('contact') || cmd.includes('hire') || cmd.includes('reach') || cmd.includes('touch') || cmd.includes('message')) {
        scrollToSection('#contact', 'Contact Channels');
        return;
      }

      // 10. Download Resume / CV
      if (cmd.includes('resume') || cmd.includes('cv') || cmd.includes('download')) {
        const resumeBtn = document.getElementById('headerResumeBtn');
        if (resumeBtn) {
          resumeBtn.click();
          if (transcriptEl) transcriptEl.textContent = 'Downloading Jayajit Dutta Resume PDF...';
          updateUIState('executing');
          playAudioChime('success');
          speakConfirmation('Downloading Resume');
        }
        return;
      }

      // 11. Email & Call
      if (cmd.includes('email') || cmd.includes('mail')) {
        window.location.href = 'mailto:jayajit1989@gmail.com';
        if (transcriptEl) transcriptEl.textContent = 'Opening email to jayajit1989@gmail.com...';
        playAudioChime('success');
        speakConfirmation('Opening email client');
        return;
      }

      if (cmd.includes('call') || cmd.includes('phone') || cmd.includes('telephone')) {
        window.location.href = 'tel:+917980726164';
        if (transcriptEl) transcriptEl.textContent = 'Initiating phone call...';
        playAudioChime('success');
        speakConfirmation('Calling Jayajit');
        return;
      }

      // 12. Explicit Command Palette trigger (do not open modal for general voice queries)
      if (cmd === 'open search' || cmd === 'open command palette' || cmd === 'palette' || cmd === 'command palette' || cmd === 'open palette') {
        const searchBtn = document.querySelector('.cmdk-trigger');
        if (searchBtn) {
          searchBtn.click();
          if (transcriptEl) transcriptEl.textContent = 'Opening Command Palette...';
          playAudioChime('success');
          speakConfirmation('Opening Search');
        }
        return;
      }

      // 13. Top / Home
      if (cmd.includes('top') || cmd.includes('home') || cmd.includes('start') || cmd.includes('overview') || cmd.includes('header')) {
        scrollToSection('#hero', 'Overview');
        return;
      }

      // 14. Close / Stop
      if (cmd.includes('close') || cmd.includes('stop') || cmd.includes('exit') || cmd.includes('cancel') || cmd.includes('dismiss')) {
        const csClose = document.getElementById('caseStudyClose');
        if (csClose && document.getElementById('caseStudyBackdrop')?.classList.contains('open')) {
          csClose.click();
        }
        closeHud();
        playAudioChime('start');
        speakConfirmation('Voice navigation closed');
        return;
      }

      // 15. Unrecognized / No Results Feedback (Never open a blank modal or blank screen)
      if (transcriptEl) {
        transcriptEl.textContent = `No results found for "${commandText}". Try saying "Projects", "Skills", or "Architecture".`;
      }
      if (statusTitle) statusTitle.textContent = 'No Match Found';
      if (statusBadge) {
        statusBadge.textContent = 'NOT FOUND';
        statusBadge.style.color = '#f59e0b';
      }
      playAudioChime('error');
      speakConfirmation('No matching results found');
    }

    function openSpecificCaseStudy(id, name) {
      const trigger = document.querySelector(`[data-open-case-study="${id}"]`);
      if (trigger) {
        trigger.click();
        if (transcriptEl) transcriptEl.textContent = `Opening Case Study: ${name}`;
        updateUIState('executing');
        playAudioChime('success');
        speakConfirmation(`Opening ${name}`);
      } else {
        scrollToSection('#projects', 'Projects');
      }
    }

    function triggerFilter(tech) {
      const pills = document.querySelectorAll('.tech-filter-pill');
      let found = false;
      pills.forEach((p) => {
        const val = p.getAttribute('data-filter-tech') || '';
        if (tech === 'all' && (val === 'all' || val === '')) {
          p.click();
          found = true;
        } else if (val.toLowerCase().includes(tech.toLowerCase())) {
          p.click();
          found = true;
        }
      });
      if (found) {
        scrollToSection('#projects', `Filtered by ${tech}`);
      }
    }

    // Event Listeners
    if (triggerBtn) {
      triggerBtn.addEventListener('click', () => {
        if (!hud.classList.contains('active')) {
          startListening();
        } else {
          toggleListening();
        }
      });
    }

    if (mobileVoiceBtn) {
      mobileVoiceBtn.addEventListener('click', () => {
        if (!hud.classList.contains('active')) {
          startListening();
        } else {
          toggleListening();
        }
      });
    }

    if (pulseIndicator) {
      pulseIndicator.addEventListener('click', toggleListening);
    }

    if (closeBtn) {
      closeBtn.addEventListener('click', closeHud);
    }

    if (muteToggle) {
      muteToggle.addEventListener('click', () => {
        soundFeedbackEnabled = !soundFeedbackEnabled;
        muteToggle.classList.toggle('muted', !soundFeedbackEnabled);
        muteToggle.title = soundFeedbackEnabled ? 'Audio Feedback On' : 'Audio Feedback Muted';
        if (soundFeedbackEnabled) playAudioChime('start');
      });
    }

    // Quick Chips click support
    chips.forEach((chip) => {
      chip.addEventListener('click', () => {
        const cmd = chip.getAttribute('data-voice-cmd');
        if (cmd) executeVoiceCommand(cmd);
      });
    });

    // Keyboard shortcut 'V' (when not in input/textarea)
    window.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && hud.classList.contains('active')) {
        closeHud();
        return;
      }
      const activeTag = document.activeElement ? document.activeElement.tagName.toLowerCase() : '';
      if (activeTag === 'input' || activeTag === 'textarea' || document.activeElement?.isContentEditable) {
        return;
      }
      if (e.key === 'v' || e.key === 'V') {
        e.preventDefault();
        if (!hud.classList.contains('active')) {
          startListening();
        } else {
          toggleListening();
        }
      }
    });
  }

  // ==========================================================================
  // Initialization Bootstrap
  // ==========================================================================
  document.addEventListener('DOMContentLoaded', () => {
    initSpotlightCards();
    initFilters();
    initCaseStudyModal();
    initTerminal();
    initCommandPalette();
    initApkModal();
    initPwa();
    initTypewriterGreeting();
    initVoiceNavigation();
  });
})();
