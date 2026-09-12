import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
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
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 60),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor, width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColors.primaryGradient),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'J',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'JAYAJIT DUTTA',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
              Text(
                '© $year • BUILT WITH FLUTTER WEB',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
