import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';

class SiteFooter extends StatelessWidget {
  final Profile profile;
  const SiteFooter({required this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hPad = Responsive.pagePadding(context);
    final year = DateTime.now().year;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 80),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'JAYAJIT DUTTA',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                '© $year / DESIGNED TO SHIP',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
