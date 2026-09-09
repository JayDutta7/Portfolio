import 'package:flutter/material.dart';
import '../../../core/utils/launch_helper.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';

class SiteFooter extends StatelessWidget {
  final Profile profile;
  const SiteFooter({required this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);
    final hPad = Responsive.pagePadding(context);
    final year = DateTime.now().year;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 64),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JD / Jayajit Dutta',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Senior Mobile Application Developer',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              if (isDesktop)
                Text(
                  'Android • Flutter • Kotlin • Jetpack Compose',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 48),
          Divider(color: theme.dividerColor, height: 1),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© $year Jayajit Dutta',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  _FooterLink(
                    label: 'GitHub',
                    onTap: () => LaunchHelper.openUrl(profile.githubUrl),
                  ),
                  const SizedBox(width: 24),
                  _FooterLink(
                    label: 'LinkedIn',
                    onTap: () => LaunchHelper.openUrl(profile.linkedInUrl),
                  ),
                  const SizedBox(width: 24),
                  _FooterLink(
                    label: 'Email',
                    onTap: () => LaunchHelper.sendEmail(profile.email),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
