import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/responsive.dart';
import '../../viewmodels/theme_viewmodel.dart';

class NavItem {
  final String label;
  final GlobalKey sectionKey;
  const NavItem(this.label, this.sectionKey);
}

class NavBar extends ConsumerWidget implements PreferredSizeWidget {
  final List<NavItem> items;
  final ValueChanged<GlobalKey> onNavTap;

  const NavBar({
    required this.items,
    required this.onNavTap,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);
    final hPad = Responsive.pagePadding(context);
    final themeController = ref.watch(themeProvider);

    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5), width: 0.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                const _Logo(),
                const Spacer(),
                if (isDesktop) ...[
                  for (final item in items)
                    _NavLink(
                      label: item.label.toUpperCase(),
                      onTap: () => onNavTap(item.sectionKey),
                    ),
                  const SizedBox(width: 12),
                  _ThemeToggle(
                    isDark: themeController.isDark,
                    onToggle: themeController.toggle,
                  ),
                  const SizedBox(width: 12),
                  const _ResumeAction(),
                ] else ...[
                  _ThemeToggle(
                    isDark: themeController.isDark,
                    onToggle: themeController.toggle,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.menu_rounded, size: 24),
                    onPressed: () => _openMobileMenu(context),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (sheetContext) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              for (final item in items)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  title: Text(
                    item.label.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onNavTap(item.sectionKey);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      'JAYAJIT',
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0,
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const _ThemeToggle({required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggle,
      icon: Icon(
        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        size: 20,
      ),
    );
  }
}

class _ResumeAction extends StatelessWidget {
  const _ResumeAction();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: theme.colorScheme.onSurface,
        foregroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      child: Text(
        'RESUME',
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          color: theme.colorScheme.surface,
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: theme.textTheme.labelSmall!.copyWith(
              fontWeight: _hovering ? FontWeight.w900 : FontWeight.w700,
              color: _hovering
                  ? theme.colorScheme.primary
                  : theme.textTheme.labelSmall?.color?.withValues(alpha: 0.6),
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
