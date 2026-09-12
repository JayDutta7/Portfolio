import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/resume_download/resume_download.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../../viewmodels/profile_viewmodel.dart';
import 'pulse_badge.dart';

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
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktopOrWider(context);
    final hPad = Responsive.pagePadding(context);
    final themeController = ref.watch(themeProvider);
    final profileState = ref.watch(profileViewModelProvider);

    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 14),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface.withValues(alpha: 0.75)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder.withValues(alpha: 0.8)
                        : AppColors.lightBorder,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    const _Logo(),
                    if (isDesktop) ...[
                      const SizedBox(width: 20),
                      const PulseBadge(
                        label: '9+ YRS • AVAILABLE FOR PROJECTS',
                        dotColor: AppColors.emerald,
                      ),
                    ],
                    const Spacer(),
                    if (isDesktop) ...[
                      for (final item in items)
                        _NavLink(
                          label: item.label.toUpperCase(),
                          onTap: () => onNavTap(item.sectionKey),
                        ),
                      const SizedBox(width: 16),
                      _ThemeToggle(
                        isDark: themeController.isDark,
                        onToggle: themeController.toggle,
                      ),
                      const SizedBox(width: 16),
                      profileState.when(
                        data: (profile) => _ResumeAction(
                          assetPath: profile.resumeAssetPath,
                          fileName: profile.resumeDownloadFileName,
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
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
        final isDark = theme.brightness == Brightness.dark;

        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface.withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(color: theme.dividerColor, width: 1),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const PulseBadge(
                    label: '9+ YRS • AVAILABLE FOR PROJECTS',
                    dotColor: AppColors.emerald,
                  ),
                  const SizedBox(height: 20),
                  for (final item in items)
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      title: Text(
                        item.label.toUpperCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        onNavTap(item.sectionKey);
                      },
                    ),
                ],
              ),
            ),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'J',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'JAYAJIT DUTTA',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const _ThemeToggle({required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => RotationTransition(
        turns: anim,
        child: ScaleTransition(scale: anim, child: child),
      ),
      child: IconButton(
        key: ValueKey(isDark),
        onPressed: onToggle,
        icon: Icon(
          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          size: 20,
          color: isDark ? AppColors.amber : AppColors.primary,
        ),
        tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      ),
    );
  }
}

class _ResumeAction extends StatelessWidget {
  final String assetPath;
  final String fileName;

  const _ResumeAction({
    required this.assetPath,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.primaryGradient),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () async {
          try {
            await downloadResume(assetPath, fileName);
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Download failed: $e')),
              );
            }
          }
        },
        icon: const Icon(Icons.download_rounded, size: 16, color: Colors.white),
        label: const Text(
          'RESUME',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
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
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: theme.textTheme.labelSmall!.copyWith(
                  fontWeight: _hovering ? FontWeight.w900 : FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: _hovering
                      ? theme.colorScheme.primary
                      : theme.textTheme.labelSmall?.color?.withValues(alpha: 0.7),
                ),
                child: Text(widget.label),
              ),
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _hovering ? 16 : 0,
                height: 2,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
