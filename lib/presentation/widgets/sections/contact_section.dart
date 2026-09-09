import 'package:flutter/material.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/resume_download/resume_download.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../common/app_buttons.dart';
import '../common/hover_card.dart';
import '../common/section_wrapper.dart';

class ContactSection extends StatelessWidget {
  final Profile profile;
  final GlobalKey? sectionKey;
  const ContactSection({required this.profile, this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Contact',
            title: 'Let\'s build something reliable together',
            description:
                'Open to Senior Android / Flutter roles and impactful '
                'mobile engineering opportunities.',
          ),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              SizedBox(
                width: isMobile ? double.infinity : 320,
                child: _ContactCard(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email',
                  value: profile.email,
                  onTap: () => LaunchHelper.sendEmail(profile.email),
                ),
              ),
              SizedBox(
                width: isMobile ? double.infinity : 320,
                child: _ContactCard(
                  icon: Icons.business_center_outlined,
                  label: 'LinkedIn',
                  value: 'Connect with me',
                  onTap: () => LaunchHelper.openUrl(profile.linkedInUrl),
                ),
              ),
              SizedBox(
                width: isMobile ? double.infinity : 320,
                child: _ContactCard(
                  icon: Icons.code_rounded,
                  label: 'GitHub',
                  value: 'View my repositories',
                  onTap: () => LaunchHelper.openUrl(profile.githubUrl),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          GradientButton(
            label: 'Download Resume (PDF)',
            icon: Icons.download_rounded,
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
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HoverCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelLarge),
                const SizedBox(height: 3),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
