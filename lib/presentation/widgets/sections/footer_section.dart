import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/firebase_presence_service.dart';
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

    final isDesktop = Responsive.isDesktopOrWider(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 48 : 32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor, width: 1)),
      ),
      child: Column(
        children: [
          if (isDesktop)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildBrandRow(theme),
                const _VisitorCountBadge(),
                Flexible(
                  child: Text(
                    '© $year • Build with flutter (Avialable for Android , Ios , Web ,Desktop )',
                    textAlign: TextAlign.end,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildBrandRow(theme),
                const SizedBox(height: 16),
                const _VisitorCountBadge(),
                const SizedBox(height: 16),
                Text(
                  '© $year • Build with flutter (Avialable for Android , Ios , Web ,Desktop )',
                  textAlign: TextAlign.center,
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

  Widget _buildBrandRow(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
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
              'JD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'JAYAJIT DUTTA',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            fontSize: 12,
            color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

class _VisitorCountBadge extends StatefulWidget {
  const _VisitorCountBadge();

  @override
  State<_VisitorCountBadge> createState() => _VisitorCountBadgeState();
}

class _VisitorCountBadgeState extends State<_VisitorCountBadge>
    with TickerProviderStateMixin {
  int _displayCount = 0;
  int _targetCount = 0;
  int _activeOnline = 1;
  bool _isHovered = false;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  AnimationController? _countController;
  Animation<int>? _countAnimation;
  Timer? _liveTrafficTimer;
  StreamSubscription<int>? _totalSub;
  StreamSubscription<int>? _onlineSub;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    final presenceService = FirebasePresenceService();
    presenceService.init();

    // Immediately seed with real cached/live values so the badge is never blank
    if (presenceService.currentTotal > 0) {
      _displayCount = presenceService.currentTotal;
      _targetCount = presenceService.currentTotal;
    }
    if (presenceService.currentOnline > 0) {
      _activeOnline = presenceService.currentOnline;
    }

    _totalSub = presenceService.totalVisitorsStream.listen((total) {
      if (mounted) {
        _animateToCount(total);
      }
    });

    _onlineSub = presenceService.activeOnlineStream.listen((online) {
      if (mounted) {
        setState(() => _activeOnline = online);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final total = presenceService.currentTotal > 0
            ? presenceService.currentTotal
            : 1;
        _animateToCount(total);
      }
    });

    // Periodic organic presence pulse when offline
    _liveTrafficTimer = Timer.periodic(const Duration(seconds: 24), (timer) {
      if (!mounted || presenceService.isFirebaseLive) return;
      final rnd = math.Random();
      setState(() {
        _activeOnline = 1 + rnd.nextInt(2);
      });
    });
  }

  void _animateToCount(int newTarget) {
    final startVal =
        _targetCount == 0 ? (newTarget > 10 ? newTarget - 5 : 0) : _displayCount;
    _targetCount = newTarget;

    _countController?.dispose();
    _countController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _countAnimation = IntTween(begin: startVal, end: newTarget).animate(
      CurvedAnimation(parent: _countController!, curve: Curves.easeOutCubic),
    )..addListener(() {
        if (mounted) {
          setState(() {
            _displayCount = _countAnimation!.value;
          });
        }
      });

    _countController!.forward();
  }

  Future<void> _handleTap() async {
    final updated = await FirebasePresenceService().incrementManually();
    if (mounted) {
      _animateToCount(updated);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF38BDF8), width: 1),
          ),
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              const Icon(Icons.celebration_rounded, color: Color(0xFF38BDF8), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "You're visitor #${_formatNumber(updated)}! Thanks for stopping by.",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _countController?.dispose();
    _liveTrafficTimer?.cancel();
    _totalSub?.cancel();
    _onlineSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveCount = _displayCount > 0
        ? _displayCount
        : (FirebasePresenceService().currentTotal > 0
            ? FirebasePresenceService().currentTotal
            : 1);
    final countString = _formatNumber(effectiveCount);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handleTap,
        child: Tooltip(
          message: 'Live Profile Counter • Tap to leave a visit!',
          child: AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: _isHovered ? 1.03 : 1.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A).withValues(alpha: _isHovered ? 0.95 : 0.85)
                    : const Color(0xFFF1F5F9).withValues(alpha: _isHovered ? 1.0 : 0.95),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: _isHovered ? 0.55 : 0.28)
                      : const Color(0xFF0284C7).withValues(alpha: _isHovered ? 0.45 : 0.2),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withValues(alpha: _isHovered ? 0.18 : 0.08),
                    blurRadius: _isHovered ? 16 : 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated pulsing green Live dot
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: _pulseAnimation.value),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withValues(alpha: 0.6 * _pulseAnimation.value),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.visibility_rounded,
                      size: 14,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Visitors:',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      countString,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3.5,
                      height: 3.5,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$_activeOnline active',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
