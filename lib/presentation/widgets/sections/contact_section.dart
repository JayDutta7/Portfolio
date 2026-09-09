import 'package:flutter/material.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/resume_download/resume_download.dart';
import '../../../domain/models/profile_models.dart';
import '../common/section_wrapper.dart';

class ContactSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ContactSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      verticalPadding: 160,
      child: Center(
        child: Column(
          children: [
            Text(
              'Let\'s build something\nworth shipping.',
              textAlign: TextAlign.center,
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -2.0,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 32),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                'Open to interesting mobile, Flutter and product engineering opportunities.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 64),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                _BigButton(
                  label: 'Let\'s Connect',
                  onPressed: () => LaunchHelper.sendEmail(profile.email),
                  primary: true,
                ),
                _BigButton(
                  label: 'Download Resume',
                  onPressed: () async {
                    try {
                      await downloadResume(
                        profile.resumeAssetPath,
                        profile.resumeDownloadFileName,
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Download failed: ${e.toString()}')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SocialLink(
                  label: 'GitHub',
                  onTap: () => LaunchHelper.openUrl(profile.githubUrl),
                ),
                _Dot(),
                _SocialLink(
                  label: 'LinkedIn',
                  onTap: () => LaunchHelper.openUrl(profile.linkedInUrl),
                ),
                _Dot(),
                _SocialLink(
                  label: 'Email',
                  onTap: () => LaunchHelper.sendEmail(profile.email),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool primary;

  const _BigButton({
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? theme.colorScheme.primary : theme.colorScheme.surface,
        foregroundColor: primary ? Colors.white : theme.colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: primary ? BorderSide.none : BorderSide(color: theme.dividerColor, width: 1.5),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
      ),
    );
  }
}

class _SocialLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SocialLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
