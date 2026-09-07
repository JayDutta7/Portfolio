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
    final isMobile = Responsive.isMobile(context);
    final hPad = Responsive.pagePadding(context);
    final year = DateTime.now().year;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment:
            isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© $year ${profile.name}. All rights reserved.',
            style: theme.textTheme.bodyMedium,
          ),
          if (isMobile) const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () => LaunchHelper.openUrl(profile.githubUrl),
                child: const Text('GitHub'),
              ),
              TextButton(
                onPressed: () => LaunchHelper.openUrl(profile.linkedInUrl),
                child: const Text('LinkedIn'),
              ),
              TextButton(
                onPressed: () => LaunchHelper.sendEmail(profile.email),
                child: const Text('Email'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
