import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/responsive.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../../viewmodels/profile_viewmodel.dart';

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
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);
    final hPad = Responsive.pagePadding(context);
    final themeController = ref.watch(themeProvider);
    final profileAsync = ref.watch(profileViewModelProvider);

    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: theme.dividerColor, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _Logo(),
                const Spacer(),
                if (isDesktop) ...[
                  for (final item in items)
                    _NavLink(
                      label: item.label,
                      onTap: () => onNavTap(item.sectionKey),
                    ),
                  const SizedBox(width: 20),
                ],
                IconButton(
                  tooltip: themeController.isDark
                      ? 'Light Mode'
                      : 'Dark Mode',
                  onPressed: themeController.toggle,
                  icon: Icon(
                    themeController.isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    size: 20,
                  ),
                ),
                if (isDesktop && profileAsync.hasValue) ...[
                  const SizedBox(width: 12),
                  _ResumeButton(resumeUrl: profileAsync.value!.resumeAssetPath),
                ],
                if (!isDesktop) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Menu',
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
                    item.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'JD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        if (Responsive.isDesktopOrWider(context))
          Text(
            'Jayajit Dutta',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
      ],
    );
  }
}

class _ResumeButton extends StatelessWidget {
  final String resumeUrl;
  const _ResumeButton({required this.resumeUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {
        // Handle resume download/view
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        textStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      child: const Text('Resume'),
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
            style: theme.textTheme.titleSmall!.copyWith(
              fontWeight: _hovering ? FontWeight.w700 : FontWeight.w500,
              color: _hovering
                  ? theme.colorScheme.primary
                  : theme.textTheme.bodyMedium?.color,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
