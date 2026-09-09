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
              'Have a mobile product\nworth building?',
              textAlign: TextAlign.center,
              style: theme.textTheme.displayMedium?.copyWith(
                height: 1.0,
                letterSpacing: -2.0,
              ),
            ),
            const SizedBox(height: 32),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Text(
                'Let\'s turn the idea into something people can actually use.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 80),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                _CTAButton(
                  label: 'LET\'S TALK',
                  onPressed: () => LaunchHelper.sendEmail(profile.email),
                  primary: true,
                ),
                _CTAButton(
                  label: 'DOWNLOAD RESUME',
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
            const SizedBox(height: 80),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SocialAction(label: 'GITHUB', onTap: () => LaunchHelper.openUrl(profile.githubUrl)),
                _ActionDivider(),
                _SocialAction(label: 'LINKEDIN', onTap: () => LaunchHelper.openUrl(profile.linkedInUrl)),
                _ActionDivider(),
                _SocialAction(label: 'EMAIL', onTap: () => LaunchHelper.sendEmail(profile.email)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CTAButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool primary;

  const _CTAButton({
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
        backgroundColor: primary ? theme.colorScheme.onSurface : Colors.transparent,
        foregroundColor: primary ? theme.colorScheme.surface : theme.colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: primary ? BorderSide.none : BorderSide(color: theme.dividerColor, width: 1.5),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

class _SocialAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SocialAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _ActionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
