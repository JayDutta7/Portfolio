import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/resume_download/resume_download.dart';
import '../../viewmodels/locale_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../../../domain/models/profile_models.dart';
import 'pulse_badge.dart';

class NavItem {
  final String label;
  final GlobalKey sectionKey;
  const NavItem(this.label, this.sectionKey);
}

class NavBar extends ConsumerWidget implements PreferredSizeWidget {
  final List<NavItem> items;
  final ValueChanged<GlobalKey> onNavTap;
  final VoidCallback? onLogoTap;
  final VoidCallback? onVoiceTap;

  const NavBar({
    required this.items,
    required this.onNavTap,
    this.onLogoTap,
    this.onVoiceTap,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = Responsive.isDesktopNavBar(context);
    final hPad = Responsive.pagePadding(context);
    final themeController = ref.watch(themeProvider);
    final profile = ref.watch(profileViewModelProvider);
    final currentLanguage = ref.watch(localeProvider);

    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? hPad : (width < 360 ? 6 : 10),
          vertical: 8,
        ),
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
                        ? AppColors.darkSurface.withValues(alpha: 0.8)
                        : Colors.white.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder.withValues(alpha: 0.8)
                          : AppColors.lightBorder,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.3)
                            : const Color(0xFF0F172A).withValues(alpha: 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                      if (!isDark)
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 18 : (width < 360 ? 6 : 10),
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Flexible(child: _Logo(onTap: onLogoTap)),
                      if (isDesktop && width >= 1150) ...[
                        const SizedBox(width: 14),
                        Flexible(
                          child: PulseBadge(
                            label: currentLanguage.navBadge,
                            dotColor: AppColors.emerald,
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (isDesktop) ...[
                        for (final item in items)
                          _NavLink(
                            label: item.label.toUpperCase(),
                            onTap: () => onNavTap(item.sectionKey),
                          ),
                        if (onVoiceTap != null) ...[
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.mic_rounded, size: 20),
                            color: AppColors.secondary,
                            tooltip: 'Voice Navigation',
                            onPressed: onVoiceTap,
                          ),
                        ],
                        const SizedBox(width: 6),
                        const _LanguageSelector(),
                        const SizedBox(width: 6),
                        _ThemeToggle(
                          isDark: themeController.isDark,
                          onToggle: themeController.toggle,
                        ),
                        const SizedBox(width: 8),
                        _ResumeAction(
                          assetPath: profile.resumeAssetPath,
                          fileName: profile.resumeDownloadFileName,
                        ),
                      ] else ...[
                        if (onVoiceTap != null && width >= 420)
                          IconButton(
                            icon: const Icon(Icons.mic_rounded, size: 20),
                            color: AppColors.secondary,
                            tooltip: 'Voice Navigation',
                            onPressed: onVoiceTap,
                          ),
                        const _LanguageSelector(),
                        const SizedBox(width: 2),
                        _ThemeToggle(
                          isDark: themeController.isDark,
                          onToggle: themeController.toggle,
                        ),
                        const SizedBox(width: 2),
                        IconButton(
                          icon: const Icon(Icons.menu_rounded, size: 24),
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          tooltip: 'Navigation Menu',
                          onPressed: () => _openMobileMenu(context, ref, profile),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openMobileMenu(BuildContext context, WidgetRef ref, Profile profile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final currentLanguage = ref.watch(localeProvider);

        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface.withValues(alpha: 0.96)
                    : Colors.white.withValues(alpha: 0.96),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: theme.dividerColor, width: 1),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag Handle
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: theme.dividerColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Full Opportunity Announcement Pill
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.emerald.withValues(alpha: 0.12)
                              : AppColors.emerald.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.emerald.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.emerald,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                currentLanguage.availableBadge,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? const Color(0xFF34D399)
                                      : const Color(0xFF047857),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status Badge & Language Selector Row (Zero overflow)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: PulseBadge(
                              label: currentLanguage.navBadge,
                              dotColor: AppColors.emerald,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const _LanguageSelector(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 6),

                      // Home nav link
                      ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        leading: const Icon(Icons.home_rounded, size: 20, color: AppColors.primary),
                        title: Text(
                          currentLanguage.navHome.toUpperCase(),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13),
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Future.delayed(const Duration(milliseconds: 200), () {
                              onLogoTap?.call();
                            });
                          });
                        },
                      ),

                      // Voice navigation link in drawer
                      if (onVoiceTap != null)
                        ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                          leading: const Icon(Icons.mic_rounded, size: 20, color: AppColors.secondary),
                          title: Text(
                            'VOICE NAVIGATION',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 13.5,
                              color: AppColors.secondary,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13),
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Future.delayed(const Duration(milliseconds: 200), () {
                                onVoiceTap?.call();
                              });
                            });
                          },
                        ),

                      // Section nav links
                      for (final item in items)
                        ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                          leading: Icon(
                            _iconForNavItem(item.label, currentLanguage),
                            size: 19,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          title: Text(
                            item.label.toUpperCase(),
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 13.5,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13),
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Future.delayed(const Duration(milliseconds: 200), () {
                                onNavTap(item.sectionKey);
                              });
                            });
                          },
                        ),
                      const SizedBox(height: 16),

                      // Resume Download Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: AppColors.primaryGradient),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              Navigator.of(sheetContext).pop();
                              try {
                                await downloadResume(profile.resumeAssetPath, profile.resumeDownloadFileName);
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Download failed: $e')),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.download_rounded, size: 18, color: Colors.white),
                            label: Text(
                              currentLanguage.downloadCv.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _iconForNavItem(String label, AppLanguage lang) {
    if (label == lang.navWork.toUpperCase()) return Icons.work_outline_rounded;
    if (label == lang.navExperience.toUpperCase()) return Icons.timeline_rounded;
    if (label == lang.navEngineering.toUpperCase()) return Icons.terminal_rounded;
    if (label == lang.navAbout.toUpperCase()) return Icons.person_outline_rounded;
    return Icons.navigation_rounded;
  }
}

class _LanguageSelector extends ConsumerWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentLanguage = ref.watch(localeProvider);

    return PopupMenuButton<AppLanguage>(
      onSelected: (language) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(localeProvider.notifier).setLanguage(language);
        });
      },
      tooltip: 'Select Language',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor),
      ),
      color: isDark ? AppColors.darkSurface : Colors.white,
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              currentLanguage.shortName,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.arrow_drop_down_rounded, size: 18),
          ],
        ),
      ),
      itemBuilder: (context) => AppLanguage.values.map((lang) {
        final isSelected = lang == currentLanguage;
        return PopupMenuItem<AppLanguage>(
          value: lang,
          child: Row(
            children: [
              Text(lang.flag, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Text(
                lang.displayName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : theme.colorScheme.onSurface,
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                const Icon(Icons.check_rounded, size: 16, color: AppColors.primary),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback? onTap;
  const _Logo({this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isVeryCompact = width < 360;
    final isCompact = width < 500;

    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
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
                  'JD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'JAYAJIT DUTTA',
                  maxLines: 1,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: isVeryCompact ? 0.8 : (isCompact ? 1.2 : 2.0),
                    fontSize: isVeryCompact ? 11.5 : (isCompact ? 12.5 : 14),
                  ),
                ),
              ),
            ),
          ],
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: (theme.textTheme.labelMedium ?? const TextStyle()).copyWith(
              color: _hovered
                  ? AppColors.primary
                  : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.85),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              fontSize: 13,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
