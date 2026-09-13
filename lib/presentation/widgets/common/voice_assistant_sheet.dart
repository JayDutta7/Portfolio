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
          if (!mounted) return;
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
          if (!mounted) return;
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
          _statusMessage = 'Say "Projects", "Skills", or "Download Resume"...';
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
    if (!_isAvailable) return;
    _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() {
          _words = result.recognizedWords;
        });

        if (result.finalResult || result.recognizedWords.isNotEmpty) {
          _processVoiceCommand(result.recognizedWords);
        }
      },
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
      ),
    );
  }

  void _stopListening() {
    _speech.stop();
    if (!mounted) return;
    setState(() {
      _isListening = false;
    });
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _processVoiceCommand(String text) {
    final cmd = text.toLowerCase().trim();
    if (cmd.isEmpty) return;

    // 1. Projects
    if (cmd.contains('project') ||
        cmd.contains('work') ||
        cmd.contains('case study') ||
        cmd.contains('app') ||
        cmd.contains('portfolio')) {
      _executeAction('Navigating to Projects', widget.onScrollToProjects);
      return;
    }

    // 2. Architecture
    if (cmd.contains('architecture') ||
        cmd.contains('system design') ||
        cmd.contains('clean arch') ||
        cmd.contains('pipeline') ||
        cmd.contains('layer')) {
      _executeAction('Navigating to Architecture', widget.onScrollToArchitecture);
      return;
    }

    // 3. Skills
    if (cmd.contains('skill') ||
        cmd.contains('technolog') ||
        cmd.contains('coroutine') ||
        cmd.contains('dagger') ||
        cmd.contains('hilt') ||
        cmd.contains('stack')) {
      _executeAction('Navigating to Skills', widget.onScrollToSkills);
      return;
    }

    // 4. Experience
    if (cmd.contains('experience') ||
        cmd.contains('career') ||
        cmd.contains('timeline') ||
        cmd.contains('job') ||
        cmd.contains('shyam steel') ||
        cmd.contains('compan')) {
      _executeAction('Navigating to Experience', widget.onScrollToExperience);
      return;
    }

    // 5. About
    if (cmd.contains('about') ||
        cmd.contains('bio') ||
        cmd.contains('profile') ||
        cmd.contains('who is') ||
        cmd.contains('summary')) {
      _executeAction('Navigating to About', widget.onScrollToAbout);
      return;
    }

    // 6. Contact
    if (cmd.contains('contact') ||
        cmd.contains('hire') ||
        cmd.contains('email') ||
        cmd.contains('call') ||
        cmd.contains('touch') ||
        cmd.contains('reach')) {
      _executeAction('Navigating to Contact', widget.onScrollToContact);
      return;
    }

    // 7. Resume / CV
    if (cmd.contains('resume') || cmd.contains('cv') || cmd.contains('download')) {
      _executeAction('Opening Resume', widget.onDownloadResume);
      return;
    }

    // 8. Theme
    if (cmd.contains('dark') ||
        cmd.contains('light') ||
        cmd.contains('night') ||
        cmd.contains('theme')) {
      _executeAction('Toggling Theme', widget.onToggleTheme);
      return;
    }

    // 9. Close
    if (cmd.contains('close') || cmd.contains('stop') || cmd.contains('dismiss')) {
      Navigator.of(context).pop();
      return;
    }
  }

  void _executeAction(String message, VoidCallback? action) {
    _speech.stop();
    setState(() {
      _statusMessage = message;
      _badgeText = 'EXECUTED';
      _badgeColor = AppColors.emerald;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      Navigator.of(context).pop();
      action?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
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
                    : AppColors.secondary.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isListening
                      ? AppColors.emerald.withValues(alpha: 0.2)
                      : AppColors.secondary.withValues(alpha: 0.15),
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
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

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
