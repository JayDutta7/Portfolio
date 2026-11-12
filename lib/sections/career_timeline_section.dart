import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/hover_bento_card.dart';

/// Component 4: Interactive Career Timeline
///
/// Features:
/// - Vertical glowing timeline spine with gradient (Electric Cyan -> Emerald)
/// - Interactive nodes with glowing halos that illuminate on hover
/// - Showcasing 9+ years progression across:
///   - Shyam Steel Industries Ltd. (Active Role)
///   - DCC Services Pvt Ltd.
///   - Matrix Media Solution Pvt. Ltd.
///   - Nat IT Solved Pvt. Ltd.
class CareerTimelineSection extends StatelessWidget {
  final GlobalKey? sectionKey;

  const CareerTimelineSection({this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.emerald.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.emerald.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              'CAREER EVOLUTION & TIMELINE',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: AppColors.emerald,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '9+ Years of Architectural Leadership & Mobile Mastery',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Text(
              'A chronological track record of modernizing codebases, scaling high-throughput apps, '
              'and leading mobile squads from requirement gathering to Play Store & App Store deployments.',
              style: GoogleFonts.inter(
                fontSize: 15,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Timeline items
          for (int i = 0; i < _timelineItems.length; i++)
            _TimelineRow(
              item: _timelineItems[i],
              isFirst: i == 0,
              isLast: i == _timelineItems.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineMilestoneData {
  final String company;
  final String role;
  final String period;
  final bool isCurrent;
  final List<String> achievements;
  final List<String> techStack;
  final Color accentColor;

  const _TimelineMilestoneData({
    required this.company,
    required this.role,
    required this.period,
    this.isCurrent = false,
    required this.achievements,
    required this.techStack,
    required this.accentColor,
  });
}

final List<_TimelineMilestoneData> _timelineItems = [
  const _TimelineMilestoneData(
    company: 'Shyam Steel Industries Ltd.',
    role: 'Senior Android & Flutter Developer / Squad Lead',
    period: 'Sep 2020 – Present',
    isCurrent: true,
    accentColor: AppColors.emerald,
    achievements: [
      'Architected, deployed, and scaled 5 flagship mobile applications: Ghareka Consumer App, Ghareka PMT, Retail CRM, Buildistan, and Pariwar.',
      'Spearheaded enterprise codebase modernization from legacy Java to modern Kotlin & Jetpack Compose, improving runtime speeds by 20% and slashing crash rates by 20%.',
      'Engineered Easebuzz payment checkout flows, Google ML Kit barcode & QR scanning, resilient offline Room sync, and battery-optimized GPS tracking.',
      'Mentored cross-functional mobile squads, establishing Clean Architecture standards, Riverpod/BLoC conventions, and automated CI/CD releases.',
    ],
    techStack: [
      'Kotlin',
      'Jetpack Compose',
      'Flutter',
      'Riverpod',
      'BLoC',
      'Clean Arch',
      'Room DB',
      'WorkManager',
      'ML Kit',
      'Easebuzz',
    ],
  ),
  const _TimelineMilestoneData(
    company: 'DCC Services Pvt Ltd.',
    role: 'Android Engineer / Consultant',
    period: 'Jan 2020 – Sep 2020',
    accentColor: AppColors.electricCyan,
    achievements: [
      'Engineered "DrLife" Native Android telemedicine app in Kotlin with MVVM and LiveData.',
      'Delivered WebRTC peer-to-peer ultra-low-latency encrypted video/audio consultation streams with dynamic bitrate adaptation.',
      'Integrated SQLCipher 256-bit AES encrypted local databases, enforcing strict HIPAA regulatory privacy standards.',
    ],
    techStack: [
      'Native Android',
      'Kotlin',
      'WebRTC C++',
      'SQLCipher AES-256',
      'MVVM',
      'LiveData',
      'Retrofit',
      'HIPAA Compliance',
    ],
  ),
  const _TimelineMilestoneData(
    company: 'Matrix Media Solution Pvt. Ltd.',
    role: 'Android Developer',
    period: 'Nov 2018 – Dec 2019',
    accentColor: Color(0xFFA855F7),
    achievements: [
      'Architected "Staffer" Native Android workforce scheduling app using Kotlin, MVVM, and LiveData.',
      'Designed dynamic shift conflict resolution algorithm across multiple time zones.',
      'Engineered bidirectional calendar synchronization using Android CalendarProvider ContentResolver API and Room DB offline caching.',
    ],
    techStack: [
      'Native Android',
      'Kotlin',
      'MVVM',
      'LiveData',
      'Room DB',
      'CalendarProvider',
      'WorkManager',
      'Retrofit',
    ],
  ),
  const _TimelineMilestoneData(
    company: 'Nat IT Solved Pvt. Ltd.',
    role: 'Android Application Developer',
    period: 'Apr 2017 – Oct 2018',
    accentColor: AppColors.electricCyan,
    achievements: [
      'Developed "Captain Logistics" Native Android fleet dispatch app in Kotlin with MVVM, LiveData, and real-time WebSocket GPS telemetry.',
      'Built "Message Club" Native Android broadcast messaging platform with Kotlin, MVVM, LiveData, Retrofit, and batch Room DB queues.',
      'Achieved sub-200ms telemetry latency and dispatched 5M+ monthly notifications with 99.95% delivery receipt accuracy.',
    ],
    techStack: [
      'Native Android',
      'Kotlin',
      'MVVM',
      'WebSockets',
      'Google Maps SDK',
      'Foreground Services',
      'Room DB',
      'FCM Batch',
    ],
  ),
];

class _TimelineRow extends StatefulWidget {
  final _TimelineMilestoneData item;
  final bool isFirst;
  final bool isLast;

  const _TimelineRow({
    required this.item,
    required this.isFirst,
    required this.isLast,
  });

  @override
  State<_TimelineRow> createState() => _TimelineRowState();
}

class _TimelineRowState extends State<_TimelineRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 900;
    final accent = widget.item.accentColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Period Column (Desktop)
            if (isDesktop)
              SizedBox(
                width: 140,
                child: Padding(
                  padding: const EdgeInsets.only(top: 26, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.item.period,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _isHovered ? accent : AppColors.textSecondary,
                        ),
                      ),
                      if (widget.item.isCurrent) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.emerald.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppColors.emerald.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            'CURRENT',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.emerald,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // Timeline Spine with Node
            SizedBox(
              width: 38,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Vertical Line
                  Positioned(
                    top: widget.isFirst ? 32 : 0,
                    bottom: widget.isLast ? null : 0,
                    height: widget.isLast ? 32 : null,
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _isHovered
                                ? accent
                                : AppColors.cardBorder.withValues(alpha: 0.8),
                            AppColors.cardBorder.withValues(alpha: 0.5),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // Node Circle
                  Positioned(
                    top: 26,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _isHovered ? 18 : 14,
                      height: _isHovered ? 18 : 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isHovered ? accent : AppColors.cardSurfaceSolid,
                        border: Border.all(
                          color: _isHovered ? Colors.white : accent,
                          width: _isHovered ? 3 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: _isHovered ? 0.6 : 0.25),
                            blurRadius: _isHovered ? 16 : 8,
                            spreadRadius: _isHovered ? 2 : 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Card Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: HoverBentoCard(
                  accentGlowColor: accent,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mobile period header
                      if (!isDesktop) ...[
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Text(
                              widget.item.period,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: accent,
                              ),
                            ),
                            if (widget.item.isCurrent)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.emerald.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: AppColors.emerald.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Text(
                                  'CURRENT',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.emerald,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Role
                      Text(
                        widget.item.role,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Company
                      Text(
                        widget.item.company,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Achievements list
                      for (final point in widget.item.achievements)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  point,
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    height: 1.55,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Tech Stack Chips
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final tech in widget.item.techStack)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.cardSurfaceElevated,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: Text(
                                tech,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary.withValues(alpha: 0.9),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
