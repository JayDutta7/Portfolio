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
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);
    final hPad = Responsive.pagePadding(context);
    final themeController = ref.watch(themeProvider);

    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.symmetric(horizontal: hPad),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.88),
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          Text(
            'Resume',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
          const Spacer(),
          if (isDesktop) ...[
            for (final item in items)
              _NavLink(label: item.label, onTap: () => onNavTap(item.sectionKey)),
            const SizedBox(width: 12),
          ],
          IconButton(
            tooltip: themeController.isDark
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            onPressed: themeController.toggle,
            icon: Icon(
              themeController.isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
          if (!isDesktop)
            Builder(
              builder: (context) => IconButton(
                tooltip: 'Menu',
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => _openMobileMenu(context),
              ),
            ),
        ],
      ),
    );
  }

  void _openMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final item in items)
                  ListTile(
                    title: Text(
                      item.label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      onNavTap(item.sectionKey);
                    },
                  ),
              ],
            ),
          ),
        );
      },
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: theme.textTheme.titleMedium!.copyWith(
              color: _hovering
                  ? theme.colorScheme.primary
                  : theme.textTheme.bodyLarge?.color,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
