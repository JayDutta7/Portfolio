import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/asset_utils.dart';
import '../../../core/utils/resume_download/resume_download.dart';
import '../../../domain/models/profile_models.dart';
import '../common/section_wrapper.dart';

class HeroSection extends StatelessWidget {
  final Profile profile;
  final VoidCallback onViewWork;
  final GlobalKey? sectionKey;

  const HeroSection({
    required this.profile,
    required this.onViewWork,
    this.sectionKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktopOrWider(context);

    return SectionWrapper(
      sectionKey: sectionKey,
      verticalPadding: isDesktop ? 120 : 60,
      child: Column(
        children: [
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _maybeExpanded(
                expand: isDesktop,
                flex: 5,
                child: Column(
                  crossAxisAlignment:
                      isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: [
                    Text(
                      'JAYAJIT DUTTA',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Senior Mobile Application Developer',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'I build mobile\nproducts that are\ndesigned to ship.',
                      textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                      style: theme.textTheme.displayMedium?.copyWith(
                        height: 0.95,
                        letterSpacing: -3.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Text(
                        'Android, Flutter & modern application architecture — from product requirements to production release.',
                        textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
                      children: const [
                        _TechMeta(label: '9+ YEARS EXPERIENCE'),
                        _Dot(),
                        _TechMeta(label: 'ANDROID'),
                        _Dot(),
                        _TechMeta(label: 'FLUTTER'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
                      children: const [
                        _TechMeta(label: 'KOTLIN'),
                        _Dot(),
                        _TechMeta(label: 'JETPACK COMPOSE'),
                      ],
                    ),
                    const SizedBox(height: 64),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
                      children: [
                        _ProductButton(
                          label: 'EXPLORE MY WORK',
                          onPressed: onViewWork,
                          primary: true,
                        ),
                        _ProductButton(
                          label: 'DOWNLOAD RESUME',
                          onPressed: () async {
                            try {
                              await downloadResume(
                                profile.resumeAssetPath,
                                profile.resumeDownloadFileName,
                              );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Download failed: ${e.toString()}')),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isDesktop) const SizedBox(width: 40),
              if (!isDesktop) const SizedBox(height: 100),
              _maybeExpanded(
                expand: isDesktop,
                flex: 5,
                child: _ProductShowcase(projects: profile.projects.take(2).toList()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductShowcase extends StatelessWidget {
  final List projects;
  const _ProductShowcase({required this.projects});

  @override
  Widget build(BuildContext context) {
    final first = projects.isNotEmpty ? projects[0] : null;
    final second = projects.length > 1 ? projects[1] : null;

    return SizedBox(
      height: 600,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow
          Positioned(
            child: Container(
              width: 440,
              height: 440,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
                    blurRadius: 120,
                    spreadRadius: 60,
                  ),
                ],
              ),
            ),
          ),
          if (first != null)
            _FloatingDevice(
              offsetX: -80,
              offsetY: 10,
              delay: 0,
              scale: 1.0,
              child: _SmartphoneFrame(
                title: first.title,
                accent: Theme.of(context).colorScheme.primary,
                deviceAsset: screenshotAsset(first.title, 'android'),
              ),
            ),
          if (second != null)
            _FloatingDevice(
              offsetX: 80,
              offsetY: -40,
              delay: 500,
              scale: 0.92,
              child: _SmartphoneFrame(
                title: second.title,
                accent: Theme.of(context).colorScheme.secondary,
                deviceAsset: screenshotAsset(second.title, 'iphone'),
              ),
            ),
          // Tech Labels
          _FloatingLabel(label: 'Kotlin', x: -160, y: -120, delay: 200),
          _FloatingLabel(label: 'Flutter', x: 160, y: 40, delay: 600),
          _FloatingLabel(label: 'Compose', x: -120, y: 160, delay: 400),
          _FloatingLabel(label: 'Riverpod', x: 140, y: -180, delay: 800),
          _FloatingLabel(label: 'REST API', x: 0, y: -240, delay: 1000),
        ],
      ),
    );
  }
}

class _SmartphoneFrame extends StatelessWidget {
  final String title;
  final Color accent;
  final String deviceAsset;

  const _SmartphoneFrame({required this.title, required this.accent, required this.deviceAsset});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 220,
      height: 460,
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFF1F1F21), width: 10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 44,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Image.asset(
                  deviceAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) {
                    return Center(
                      child: Opacity(
                        opacity: 0.08,
                        child: Icon(Icons.smartphone_rounded, size: 140, color: accent),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Product name label
            Positioned(
              bottom: 22,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  title.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: accent.withValues(alpha: 0.6),
                    letterSpacing: 1.2,
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

class _FloatingLabel extends StatelessWidget {
  final String label;
  final double x;
  final double y;
  final int delay;

  const _FloatingLabel({
    required this.label,
    required this.x,
    required this.y,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _FloatingDevice(
      offsetX: x,
      offsetY: y,
      delay: delay,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor, width: 0.5),
        ),
        child: Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            fontFamily: 'JetBrainsMono',
          ),
        ),
      ),
    );
  }
}

class _FloatingDevice extends StatefulWidget {
  final double offsetX;
  final double offsetY;
  final int delay;
  final double scale;
  final Widget child;

  const _FloatingDevice({
    required this.offsetX,
    required this.offsetY,
    required this.delay,
    this.scale = 1.0,
    required this.child,
  });

  @override
  State<_FloatingDevice> createState() => _FloatingDeviceState();
}

class _FloatingDeviceState extends State<_FloatingDevice>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (!mounted) return;
      // Run a short repeating animation and then stop to avoid keeping an
      // infinite animation active (which blocks tester.pumpAndSettle).
      _controller.repeat(reverse: true);
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) _controller.stop();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(widget.offsetX, widget.offsetY + _animation.value),
          child: Transform.scale(
            scale: widget.scale,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _ProductButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool primary;

  const _ProductButton({
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? theme.colorScheme.onSurface : Colors.transparent,
        foregroundColor: primary ? theme.colorScheme.surface : theme.colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: primary ? BorderSide.none : BorderSide(color: theme.dividerColor, width: 1.5),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _TechMeta extends StatelessWidget {
  final String label;
  const _TechMeta({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.labelSmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

Widget _maybeExpanded({
  required bool expand,
  required int flex,
  required Widget child,
}) {
  if (expand) {
    return Expanded(flex: flex, child: child);
  }
  return child;
}
