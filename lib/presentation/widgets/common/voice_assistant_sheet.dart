import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../core/theme/app_colors.dart';

class VoiceAssistantSheet extends StatefulWidget {
  final VoidCallback? onScrollToProjects;
  final VoidCallback? onScrollToArchitecture;
  final VoidCallback? onScrollToSkills;
  final VoidCallback? onScrollToExperience;
  final VoidCallback? onScrollToEducation;
  final VoidCallback? onScrollToAbout;
  final VoidCallback? onScrollToContact;
  final VoidCallback? onDownloadResume;
  final VoidCallback? onToggleTheme;

  const VoiceAssistantSheet({
    super.key,
    this.onScrollToProjects,
    this.onScrollToArchitecture,
    this.onScrollToSkills,
    this.onScrollToExperience,
    this.onScrollToEducation,
    this.onScrollToAbout,
    this.onScrollToContact,
    this.onDownloadResume,
    this.onToggleTheme,
  });

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onScrollToProjects,
    VoidCallback? onScrollToArchitecture,
    VoidCallback? onScrollToSkills,
    VoidCallback? onScrollToExperience,
    VoidCallback? onScrollToEducation,
    VoidCallback? onScrollToAbout,
    VoidCallback? onScrollToContact,
    VoidCallback? onDownloadResume,
    VoidCallback? onToggleTheme,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => VoiceAssistantSheet(
        onScrollToProjects: onScrollToProjects,
        onScrollToArchitecture: onScrollToArchitecture,
        onScrollToSkills: onScrollToSkills,
        onScrollToExperience: onScrollToExperience,
        onScrollToEducation: onScrollToEducation,
        onScrollToAbout: onScrollToAbout,
        onScrollToContact: onScrollToContact,
        onDownloadResume: onDownloadResume,
        onToggleTheme: onToggleTheme,
      ),
    );
  }

  @override
  State<VoiceAssistantSheet> createState() => _VoiceAssistantSheetState();
}

class _VoiceAssistantSheetState extends State<VoiceAssistantSheet>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  late final AnimationController _pulseController;

  bool _isAvailable = false;
  bool _isListening = false;
  bool _hasExecuted = false;
  String _words = '';
  String _statusMessage = 'Initializing Voice Assistant...';
  String _badgeText = 'READY';
  Color _badgeColor = AppColors.secondary;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _initSpeech();
  }

  @override
  void dispose() {
    _speech.stop();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (!mounted || _hasExecuted) return;
          if (status == 'listening') {
            setState(() {
              _isListening = true;
              _badgeText = 'LISTENING';
              _badgeColor = AppColors.emerald;
              _statusMessage = 'Listening for commands...';
            });
          } else if (status == 'notListening' || status == 'done') {
            setState(() {
              _isListening = false;
              _badgeText = 'READY';
              _badgeColor = AppColors.secondary;
            });
          }
        },
        onError: (errorNotification) {
          if (!mounted || _hasExecuted) return;
          setState(() {
            _isListening = false;
            _badgeText = 'NOTICE';
            _badgeColor = Colors.orange;
            _statusMessage = errorNotification.errorMsg.isNotEmpty
                ? errorNotification.errorMsg
                : 'Microphone inactive. Tap a command below!';
          });
        },
      );

      if (!mounted) return;
      setState(() {
        _isAvailable = available;
        if (available) {
          _statusMessage = 'Say "Projects", "Education", or "Skills"...';
        } else {
          _statusMessage = 'Voice not available. Tap any quick command below:';
          _badgeText = 'TOUCH MODE';
          _badgeColor = Colors.amber;
        }
      });

      if (available) {
        _startListening();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isAvailable = false;
        _statusMessage = 'Voice recognition standby. Tap any quick command:';
        _badgeText = 'READY';
        _badgeColor = AppColors.secondary;
      });
    }
  }

  void _startListening() {
    if (!_isAvailable || _hasExecuted) return;
    try {
      _speech.listen(
        onResult: (result) {
          if (!mounted || _hasExecuted) return;
          setState(() {
            _words = result.recognizedWords;
          });

          _processVoiceCommand(result.recognizedWords, isFinal: result.finalResult);
        },
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: false,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isListening = false;
        _statusMessage = 'Tap a command below to navigate:';
      });
    }
  }

  void _stopListening() {
    try {
      _speech.stop();
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _isListening = false;
    });
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _hasExecuted = false;
      _startListening();
    }
  }

  void _processVoiceCommand(String text, {bool isFinal = false}) {
    if (_hasExecuted) return;
    final cmd = text.toLowerCase().trim();
    if (cmd.isEmpty) return;

    // Remove common speech filler prefixes to support natural voice queries
    String normalized = cmd;
    final prefixes = [
      'please ',
      'can you ',
      'could you ',
      'navigate to ',
      'go to ',
      'take me to ',
      'search for ',
      'search ',
      'show me ',
      'find ',
      'open ',
      'scroll to ',
      'look for ',
    ];

    bool stripped = true;
    while (stripped) {
      stripped = false;
      for (final p in prefixes) {
        if (normalized.startsWith(p)) {
          normalized = normalized.substring(p.length).trim();
          stripped = true;
        }
      }
    }

    if (normalized.isEmpty || normalized == 'search' || normalized == 'find') {
      if (isFinal) {
        if (!mounted) return;
        setState(() {
          _statusMessage = 'What would you like to search? Say a section or skill:';
        });
      }
      return;
    }

    // Close / Dismiss
    if (normalized == 'close' ||
        normalized == 'exit' ||
        normalized == 'cancel' ||
        normalized == 'dismiss' ||
        normalized == 'stop' ||
        normalized == 'quit' ||
        cmd == 'close' ||
        cmd == 'stop listening') {
      if (_hasExecuted) return;
      _hasExecuted = true;
      try {
        _speech.stop();
      } catch (_) {}
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      return;
    }

    // 1. Projects & Specific Case Studies
    if (normalized.contains('project') ||
        normalized.contains('work') ||
        normalized.contains('case study') ||
        normalized.contains('portfolio') ||
        normalized.contains('ghareka') ||
        normalized.contains('buildistan') ||
        normalized.contains('pariwar') ||
        normalized.contains('crm') ||
        normalized.contains('sales') ||
        normalized.contains('captain') ||
        normalized.contains('message club') ||
        normalized.contains('massage club') ||
        normalized.contains('staffer') ||
        normalized.contains('drlife') ||
        normalized.contains('telemedicine') ||
        cmd.contains('project') ||
        cmd.contains('case study')) {
      _executeAction('Navigating to Projects', widget.onScrollToProjects);
      return;
    }

    // 2. Architecture
    if (normalized.contains('architecture') ||
        normalized.contains('system design') ||
        normalized.contains('clean arch') ||
        normalized.contains('pipeline') ||
        normalized.contains('layer') ||
        cmd.contains('architecture') ||
        cmd.contains('system design')) {
      _executeAction('Navigating to Architecture', widget.onScrollToArchitecture);
      return;
    }

    // 3. Skills & Technologies
    if (normalized.contains('skill') ||
        normalized.contains('technolog') ||
        normalized.contains('tech stack') ||
        normalized.contains('coroutine') ||
        normalized.contains('dagger') ||
        normalized.contains('hilt') ||
        normalized.contains('flutter') ||
        normalized.contains('kotlin') ||
        normalized.contains('android') ||
        normalized.contains('compose') ||
        normalized.contains('riverpod') ||
        normalized.contains('bloc') ||
        cmd.contains('skill') ||
        cmd.contains('flutter') ||
        cmd.contains('kotlin') ||
        cmd.contains('android')) {
      _executeAction('Navigating to Skills', widget.onScrollToSkills);
      return;
    }

    // 4. Experience
    if (normalized.contains('experience') ||
        normalized.contains('career') ||
        normalized.contains('timeline') ||
        normalized.contains('job') ||
        normalized.contains('shyam steel') ||
        normalized.contains('compan') ||
        cmd.contains('experience') ||
        cmd.contains('career') ||
        cmd.contains('timeline')) {
      _executeAction('Navigating to Experience', widget.onScrollToExperience);
      return;
    }

    // 5. Education & Academics
    if (normalized.contains('education') ||
        normalized.contains('academic') ||
        normalized.contains('degree') ||
        normalized.contains('college') ||
        normalized.contains('school') ||
        normalized.contains('university') ||
        normalized.contains('mca') ||
        normalized.contains('bca') ||
        normalized.contains('study') ||
        normalized.contains('studies') ||
        cmd.contains('education') ||
        cmd.contains('academic') ||
        cmd.contains('degree') ||
        cmd.contains('school')) {
      _executeAction('Navigating to Education', widget.onScrollToEducation);
      return;
    }

    // 6. About
    if (normalized.contains('about') ||
        normalized.contains('bio') ||
        normalized.contains('profile') ||
        normalized.contains('who is') ||
        normalized.contains('summary') ||
        cmd.contains('about') ||
        cmd.contains('who is')) {
      _executeAction('Navigating to About', widget.onScrollToAbout);
      return;
    }

    // 7. Contact
    if (normalized.contains('contact') ||
        normalized.contains('hire') ||
        normalized.contains('email') ||
        normalized.contains('call') ||
        normalized.contains('touch') ||
        normalized.contains('reach') ||
        normalized.contains('phone') ||
        normalized.contains('github') ||
        normalized.contains('linkedin') ||
        cmd.contains('contact') ||
        cmd.contains('hire') ||
        cmd.contains('email')) {
      _executeAction('Navigating to Contact', widget.onScrollToContact);
      return;
    }

    // 8. Resume / CV
    if (normalized.contains('resume') ||
        normalized.contains('cv') ||
        normalized.contains('curriculum vitae') ||
        normalized.contains('download') ||
        cmd.contains('resume') ||
        cmd.contains('cv')) {
      _executeAction('Opening Resume', widget.onDownloadResume);
      return;
    }

    // 9. Theme
    if (normalized.contains('dark') ||
        normalized.contains('light') ||
        normalized.contains('night') ||
        normalized.contains('theme') ||
        normalized.contains('mode') ||
        cmd.contains('theme') ||
        cmd.contains('mode')) {
      _executeAction('Toggling Theme', widget.onToggleTheme);
      return;
    }

    // 10. Fallback when voice search produces no match (avoid blank screens)
    if (isFinal) {
      try {
        _speech.stop();
      } catch (_) {}
      if (!mounted) return;
      setState(() {
        _isListening = false;
        _words = '';
        _badgeText = 'NO MATCH';
        _badgeColor = Colors.orangeAccent;
        _statusMessage = 'No results found for "$text". Tap a command:';
      });
    }
  }

  void _executeAction(String message, VoidCallback? action) {
    if (_hasExecuted) return;
    _hasExecuted = true;
    try {
      _speech.stop();
    } catch (_) {}

    if (mounted) {
      setState(() {
        _statusMessage = message;
        _badgeText = 'EXECUTED';
        _badgeColor = AppColors.emerald;
      });
    }

    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      action?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.paddingOf(context).bottom + 20,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF090A0F).withValues(alpha: 0.92)
                      : Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isListening
                        ? AppColors.emerald.withValues(alpha: 0.5)
                        : (_badgeText == 'NO MATCH'
                            ? Colors.orange.withValues(alpha: 0.6)
                            : AppColors.secondary.withValues(alpha: 0.35)),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isListening
                          ? AppColors.emerald.withValues(alpha: 0.2)
                          : (_badgeText == 'NO MATCH'
                              ? Colors.orange.withValues(alpha: 0.2)
                              : AppColors.secondary.withValues(alpha: 0.15)),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                // Top row: Mic button, Status, Equalizer, Close
                Row(
                  children: [
                    // Mic Pulse Button
                    GestureDetector(
                      onTap: _toggleListening,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final scale = _isListening
                              ? 1.0 + (_pulseController.value * 0.15)
                              : 1.0;
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isListening
                                    ? AppColors.emerald.withValues(alpha: 0.2)
                                    : AppColors.secondary.withValues(alpha: 0.15),
                                border: Border.all(
                                  color: _isListening
                                      ? AppColors.emerald
                                      : AppColors.secondary,
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                _isListening ? Icons.mic : Icons.mic_none,
                                color: _isListening
                                    ? AppColors.emerald
                                    : AppColors.secondary,
                                size: 22,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Title and Live Transcript
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Voice Assistant',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _badgeColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _badgeColor.withValues(alpha: 0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _badgeText,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: _badgeColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _words.isNotEmpty ? '"$_words"' : _statusMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: _words.isNotEmpty
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontStyle: _words.isNotEmpty
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                              color: _words.isNotEmpty
                                  ? (isDark ? Colors.white : Colors.black)
                                  : (isDark ? Colors.white60 : Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Equalizer wave bars
                    if (_isListening)
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final v = _pulseController.value;
                          return Row(
                            children: List.generate(4, (i) {
                              final height = 6.0 +
                                  (16.0 *
                                      ((v + (i * 0.25)) % 1.0)
                                          .abs());
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                width: 3,
                                height: height,
                                decoration: BoxDecoration(
                                  color: AppColors.emerald,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            }),
                          );
                        },
                      ),

                    const SizedBox(width: 8),
                    // Close button
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      color: isDark ? Colors.white60 : Colors.black54,
                      onPressed: () {
                        if (_hasExecuted) return;
                        _hasExecuted = true;
                        try {
                          _speech.stop();
                        } catch (_) {}
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                if (_badgeText == 'NO MATCH') ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 15, color: Colors.orangeAccent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'No matching section or project found. Tap a command below:',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFFDBA74) : const Color(0xFFC2410C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 14),
                const Divider(height: 1, color: Colors.white10),
                const SizedBox(height: 12),

                // Quick Command Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildQuickChip('Projects', () {
                        _executeAction('Opening Projects', widget.onScrollToProjects);
                      }, isDark),
                      _buildQuickChip('Architecture', () {
                        _executeAction('Opening Architecture', widget.onScrollToArchitecture);
                      }, isDark),
                      _buildQuickChip('Skills', () {
                        _executeAction('Opening Skills', widget.onScrollToSkills);
                      }, isDark),
                      _buildQuickChip('Experience', () {
                        _executeAction('Opening Experience', widget.onScrollToExperience);
                      }, isDark),
                      _buildQuickChip('Education', () {
                        _executeAction('Opening Education', widget.onScrollToEducation);
                      }, isDark),
                      _buildQuickChip('About', () {
                        _executeAction('Opening About', widget.onScrollToAbout);
                      }, isDark),
                      _buildQuickChip('Contact', () {
                        _executeAction('Opening Contact', widget.onScrollToContact);
                      }, isDark),
                      _buildQuickChip('Resume', () {
                        _executeAction('Downloading Resume', widget.onDownloadResume);
                      }, isDark),
                      _buildQuickChip('Theme', () {
                        _executeAction('Toggling Theme', widget.onToggleTheme);
                      }, isDark),
                    ],
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

  Widget _buildQuickChip(String label, VoidCallback onTap, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black12,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
