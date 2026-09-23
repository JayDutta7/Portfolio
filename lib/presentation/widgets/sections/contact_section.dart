import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/glass_container.dart';
import '../common/gradient_text.dart';
import '../common/section_wrapper.dart';

/// Upgraded, state-of-the-art 07 / CONTACT section showcasing direct links
/// for GitHub, LinkedIn, Email, and Phone with rich interactive cards and one-click actions.
class ContactSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;

  const ContactSection({
    required this.profile,
    this.sectionKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktopOrWider(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 640;
    final isCompact = width < 380;
    final titleFontSize = isDesktop ? 44.0 : (isCompact ? 26.0 : 32.0);

    return SectionWrapper(
      sectionKey: sectionKey,
      verticalPadding: isDesktop ? 96 : 48,
      child: Center(
        child: GlassContainer(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48 : (isCompact ? 16 : 24),
            vertical: isDesktop ? 64 : (isCompact ? 32 : 44),
          ),
          glowColor: AppColors.primary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Badges: Section Pill & Availability Pulse
              Wrap(
                spacing: 12,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      'CONTACT',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const _LiveAvailabilityBadge(),
                ],
              ),
              const SizedBox(height: 24),

              // Main Section Headline
              GradientText(
                'Have a mobile product\nworth building?',
                textAlign: TextAlign.center,
                colors: isDark
                    ? AppColors.heroTitleGradient
                    : AppColors.heroTitleGradientLight,
                style: GoogleFonts.plusJakartaSans(
                  height: 1.1,
                  letterSpacing: isCompact ? -0.8 : -1.5,
                  fontWeight: FontWeight.w900,
                  fontSize: titleFontSize,
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Text(
                  'Let\'s turn your vision into an exceptional, production-ready Android or Flutter application. Reach out directly through any of the channels below.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                    fontSize: isMobile ? 14.5 : 16.5,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Response info strip
              const _ResponseInfoStrip(),
              SizedBox(height: isMobile ? 32 : 44),

              // 4 Interactive Contact Cards Grid
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: _ContactCardsGrid(profile: profile),
              ),
              SizedBox(height: isMobile ? 36 : 48),

              // Bottom Action: Direct Conversation CTA
              _PrimarySendCTA(email: profile.email),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated live pulsing badge indicating current professional availability
class _LiveAvailabilityBadge extends StatefulWidget {
  const _LiveAvailabilityBadge();

  @override
  State<_LiveAvailabilityBadge> createState() => _LiveAvailabilityBadgeState();
}

class _LiveAvailabilityBadgeState extends State<_LiveAvailabilityBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: const Color(0xFF10B981).withValues(alpha: 0.3),
            width: 1.1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(
                          alpha: 0.4 + (_pulseController.value * 0.5),
                        ),
                        blurRadius: 4 + (_pulseController.value * 6),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              'AVAILABLE FOR OPPORTUNITIES',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact info strip highlighting response metrics and global collaboration
class _ResponseInfoStrip extends StatelessWidget {
  const _ResponseInfoStrip();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _buildInfoChip(
          icon: Icons.bolt_rounded,
          text: 'Response: Within 24h',
          iconColor: const Color(0xFFF59E0B),
          isDark: isDark,
        ),
        _buildInfoChip(
          icon: Icons.schedule_rounded,
          text: 'IST (UTC +5:30) · Kolkata',
          iconColor: const Color(0xFF38BDF8),
          isDark: isDark,
        ),
        _buildInfoChip(
          icon: Icons.public_rounded,
          text: 'Remote & Worldwide',
          iconColor: const Color(0xFF10B981),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color iconColor,
    required bool isDark,
  }) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Responsive grid displaying the 4 dedicated contact channels:
/// 1. GitHub (https://github.com/JayDutta7)
/// 2. LinkedIn (https://www.linkedin.com/in/jayajit-dutta-7124b9125/)
/// 3. Email (jayajitdutta7@gmail.com)
/// 4. Phone (+91 7980726164)
class _ContactCardsGrid extends StatelessWidget {
  final Profile profile;

  const _ContactCardsGrid({required this.profile});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        final cardWidth = isWide ? (constraints.maxWidth - 20) / 2 : constraints.maxWidth;

        final githubCard = _ContactChannelCard(
          category: 'CODE & ARCHITECTURE',
          icon: Icons.code_rounded,
          accentColor: const Color(0xFF818CF8),
          title: 'GitHub',
          value: profile.githubUrl,
          displayValue: 'github.com/JayDutta7',
          description: 'Explore 9+ enterprise case studies, packages & open-source projects',
          primaryActionLabel: 'Open GitHub',
          primaryActionIcon: Icons.open_in_new_rounded,
          onPrimaryAction: () => LaunchHelper.openUrl(profile.githubUrl),
          copyValue: profile.githubUrl,
          copySuccessMessage: 'GitHub URL copied to clipboard!',
        );

        final linkedInCard = _ContactChannelCard(
          category: 'PROFESSIONAL NETWORK',
          icon: Icons.work_rounded,
          accentColor: const Color(0xFF38BDF8),
          title: 'LinkedIn',
          value: profile.linkedInUrl,
          displayValue: 'linkedin.com/in/jayajit-dutta-7124b9125',
          description: 'Enterprise recommendations, professional journey & InMail',
          primaryActionLabel: 'View Profile',
          primaryActionIcon: Icons.open_in_new_rounded,
          onPrimaryAction: () => LaunchHelper.openUrl(profile.linkedInUrl),
          copyValue: profile.linkedInUrl,
          copySuccessMessage: 'LinkedIn profile link copied to clipboard!',
        );

        final emailCard = _ContactChannelCard(
          category: 'DIRECT INBOX',
          icon: Icons.alternate_email_rounded,
          accentColor: const Color(0xFF10B981),
          title: 'Email',
          value: profile.email,
          displayValue: profile.email,
          description: 'Direct inquiries for senior roles, architecture audits & consulting',
          primaryActionLabel: 'Compose Mail',
          primaryActionIcon: Icons.send_rounded,
          onPrimaryAction: () => LaunchHelper.sendEmail(
            profile.email,
            subject: 'Mobile Engineering Inquiry - Jayajit Dutta',
          ),
          copyValue: profile.email,
          copySuccessMessage: 'Email address copied to clipboard!',
        );

        final phoneCard = _ContactChannelCard(
          category: 'PHONE & WHATSAPP',
          icon: Icons.phone_in_talk_rounded,
          accentColor: const Color(0xFFF59E0B),
          title: 'Phone',
          value: profile.phone,
          displayValue: profile.phone,
          description: 'Direct voice calls or quick conversation via WhatsApp messaging',
          primaryActionLabel: 'Call Now',
          primaryActionIcon: Icons.call_rounded,
          onPrimaryAction: () => LaunchHelper.makeCall(profile.phone),
          extraActionLabel: 'WhatsApp',
          extraActionIcon: Icons.chat_bubble_outline_rounded,
          onExtraAction: () => LaunchHelper.openWhatsApp(
            profile.phone,
            text: 'Hi Jayajit, saw your portfolio and would like to connect!',
          ),
          copyValue: profile.phone,
          copySuccessMessage: 'Phone number copied to clipboard!',
        );

        if (isWide) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: cardWidth, child: githubCard),
                  const SizedBox(width: 20),
                  SizedBox(width: cardWidth, child: linkedInCard),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: cardWidth, child: emailCard),
                  const SizedBox(width: 20),
                  SizedBox(width: cardWidth, child: phoneCard),
                ],
              ),
            ],
          );
        }

        return Column(
          children: [
            githubCard,
            const SizedBox(height: 16),
            linkedInCard,
            const SizedBox(height: 16),
            emailCard,
            const SizedBox(height: 16),
            phoneCard,
          ],
        );
      },
    );
  }
}

/// Rich interactive channel card with elevation, glowing icon, and dedicated action triggers
class _ContactChannelCard extends StatefulWidget {
  final String category;
  final IconData icon;
  final Color accentColor;
  final String title;
  final String value;
  final String displayValue;
  final String description;
  final String primaryActionLabel;
  final IconData primaryActionIcon;
  final VoidCallback onPrimaryAction;
  final String? extraActionLabel;
  final IconData? extraActionIcon;
  final VoidCallback? onExtraAction;
  final String copyValue;
  final String copySuccessMessage;

  const _ContactChannelCard({
    required this.category,
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.value,
    required this.displayValue,
    required this.description,
    required this.primaryActionLabel,
    required this.primaryActionIcon,
    required this.onPrimaryAction,
    this.extraActionLabel,
    this.extraActionIcon,
    this.onExtraAction,
    required this.copyValue,
    required this.copySuccessMessage,
  });

  @override
  State<_ContactChannelCard> createState() => _ContactChannelCardState();
}

class _ContactChannelCardState extends State<_ContactChannelCard> {
  bool _isHovered = false;

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.copyValue));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: widget.accentColor.withValues(alpha: 0.8), width: 1.2),
        ),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: widget.accentColor, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.copySuccessMessage,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF131B2E).withValues(alpha: _isHovered ? 0.95 : 0.75)
              : const Color(0xFFFFFFFF).withValues(alpha: _isHovered ? 1.0 : 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.accentColor.withValues(alpha: _isHovered ? 0.6 : 0.2),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withValues(alpha: _isHovered ? 0.2 : 0.04),
              blurRadius: _isHovered ? 24 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Category tag + Floating Icon Badge + Quick Copy Icon
            Row(
              children: [
                // Floating Glowing Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.accentColor.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(widget.icon, size: 20, color: widget.accentColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                          color: widget.accentColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                // Quick Copy Icon Button
                Tooltip(
                  message: 'Copy to clipboard',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _copyToClipboard(context),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.content_copy_rounded,
                          size: 15,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Prominent Display Value (Link, email, or phone)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (isDark ? const Color(0xFF0A0F1D) : const Color(0xFFF1F5F9))
                    .withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                ),
              ),
              child: SelectableText(
                widget.displayValue,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Brief Description
            Text(
              widget.description,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Primary Action Button (Open / Send / Call)
                ElevatedButton.icon(
                  onPressed: widget.onPrimaryAction,
                  icon: Icon(widget.primaryActionIcon, size: 14, color: Colors.white),
                  label: Text(
                    widget.primaryActionLabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // Optional Extra Action (e.g. WhatsApp for phone)
                if (widget.extraActionLabel != null && widget.onExtraAction != null)
                  OutlinedButton.icon(
                    onPressed: widget.onExtraAction,
                    icon: Icon(
                      widget.extraActionIcon ?? Icons.chat_rounded,
                      size: 14,
                      color: const Color(0xFF10B981),
                    ),
                    label: Text(
                      widget.extraActionLabel!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: const Color(0xFF10B981).withValues(alpha: 0.4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                // Copy Action Button
                OutlinedButton.icon(
                  onPressed: () => _copyToClipboard(context),
                  icon: Icon(
                    Icons.copy_rounded,
                    size: 13,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  label: Text(
                    'Copy',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.18),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Prominent elevated CTA button to start direct email dialogue
class _PrimarySendCTA extends StatefulWidget {
  final String email;

  const _PrimarySendCTA({required this.email});

  @override
  State<_PrimarySendCTA> createState() => _PrimarySendCTAState();
}

class _PrimarySendCTAState extends State<_PrimarySendCTA> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _isHovered ? 1.04 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _isHovered ? 0.45 : 0.25),
                blurRadius: _isHovered ? 30 : 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () => LaunchHelper.sendEmail(
              widget.email,
              subject: 'Engineering Collaboration - Jayajit Dutta',
            ),
            icon: const Icon(Icons.send_rounded, size: 17, color: Colors.white),
            label: Text(
              'START A CONVERSATION',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.2,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
