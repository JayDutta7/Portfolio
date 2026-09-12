import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../domain/models/profile_models.dart';
import '../common/glass_container.dart';
import '../common/gradient_text.dart';
import '../common/section_wrapper.dart';

class ContactSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ContactSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SectionWrapper(
      sectionKey: sectionKey,
      verticalPadding: 120,
      child: Center(
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 64),
          glowColor: AppColors.primary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '07 / CONTACT',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              GradientText(
                'Have a mobile product\nworth building?',
                textAlign: TextAlign.center,
                colors: isDark
                    ? AppColors.heroTitleGradient
                    : AppColors.heroTitleGradientLight,
                style: theme.textTheme.displayMedium?.copyWith(
                  height: 1.05,
                  letterSpacing: -1.5,
                  fontWeight: FontWeight.w900,
                  fontSize: 44,
                ),
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: Text(
                  'Let\'s turn your vision into an exceptional, production-ready Android or Flutter application.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              _RichCTAButton(
                label: 'START A CONVERSATION',
                email: profile.email,
              ),
              const SizedBox(height: 56),
              Wrap(
                spacing: 24,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _SocialActionRich(
                    icon: Icons.code_rounded,
                    label: 'GITHUB',
                    onTap: () => LaunchHelper.openUrl(profile.githubUrl),
                  ),
                  _SocialActionRich(
                    icon: Icons.work_rounded,
                    label: 'LINKEDIN',
                    onTap: () => LaunchHelper.openUrl(profile.linkedInUrl),
                  ),
                  _SocialActionRich(
                    icon: Icons.email_rounded,
                    label: 'EMAIL',
                    onTap: () => LaunchHelper.sendEmail(profile.email),
                  ),
                  _SocialActionRich(
                    icon: Icons.phone_rounded,
                    label: 'PHONE',
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: profile.phone));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Phone number copied: ${profile.phone}')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RichCTAButton extends StatefulWidget {
  final String label;
  final String email;

  const _RichCTAButton({
    required this.label,
    required this.email,
  });

  @override
  State<_RichCTAButton> createState() => _RichCTAButtonState();
}

class _RichCTAButtonState extends State<_RichCTAButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _isHovered ? 1.05 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _isHovered ? 0.45 : 0.25),
                blurRadius: _isHovered ? 32 : 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () => LaunchHelper.sendEmail(widget.email),
            icon: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
            label: Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialActionRich extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialActionRich({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
