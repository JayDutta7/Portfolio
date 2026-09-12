import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../common/glass_container.dart';
import '../common/gradient_text.dart';
import '../common/section_wrapper.dart';

class SetupSection extends StatelessWidget {
  const SetupSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final specs = [
      {'label': 'MACHINE', 'value': 'MacBook M3 Max · 64GB RAM · 1TB SSD', 'icon': Icons.laptop_mac_rounded},
      {'label': 'DISPLAY', 'value': '32" 4K LG UltraFine + 27" Dell Vertical', 'icon': Icons.desktop_windows_rounded},
      {'label': 'PERIPHERALS', 'value': 'Keychron Q1 Pro · Logitech MX Master 3S', 'icon': Icons.keyboard_rounded},
      {'label': 'NETWORK', 'value': '300 Mbps Fiber · Wi-Fi 6 Mesh', 'icon': Icons.wifi_rounded},
      {'label': 'ENVIRONMENT', 'value': 'Serampore, India · Optimized for Deep Work', 'icon': Icons.place_rounded},
    ];

    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'WFH SETUP & WORKSTATION',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GradientText(
            'Hardware I use to build\nhigh-performance apps.',
            colors: isDark
                ? [Colors.white, AppColors.secondary, AppColors.primary]
                : [AppColors.lightTextPrimary, AppColors.primary],
            style: theme.textTheme.displaySmall?.copyWith(
              height: 1.1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 48),
          GlassContainer(
            padding: const EdgeInsets.all(32),
            glowColor: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IDE Header bar
                Row(
                  children: [
                    Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF5F56))),
                    const SizedBox(width: 8),
                    Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFBD2E))),
                    const SizedBox(width: 8),
                    Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF27C93F))),
                    Expanded(
                      child: Text(
                        'jayajit@macbook-pro ~ % neofetch',
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontFamily: 'monospace',
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Divider(height: 1),
                const SizedBox(height: 24),
                for (int i = 0; i < specs.length; i++) ...[
                  _SpecRow(
                    label: specs[i]['label'] as String,
                    value: specs[i]['value'] as String,
                    icon: specs[i]['icon'] as IconData,
                  ),
                  if (i < specs.length - 1) ...[
                    const SizedBox(height: 16),
                    Divider(color: theme.dividerColor.withValues(alpha: 0.3), height: 1),
                    const SizedBox(height : 16),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SpecRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    return Flex(
      direction: isDesktop ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            SizedBox(
              width: 140,
              child: Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        if (isDesktop) const SizedBox(width: 32),
        if (!isDesktop) const SizedBox(height: 6),
        if (isDesktop)
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          )
        else
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
      ],
    );
  }
}
