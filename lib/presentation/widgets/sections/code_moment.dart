import 'package:flutter/material.dart';
import '../common/section_wrapper.dart';

class CodeMoment extends StatelessWidget {
  const CodeMoment({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionWrapper(
      verticalPadding: 80,
      child: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF000000),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  for (final color in const [Colors.red, Colors.orange, Colors.green])
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.3), shape: BoxShape.circle),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              const _CodeLine(text: r'$ flutter build appbundle', isInput: true),
              const SizedBox(height: 12),
              const _CodeLine(text: '✓ Analyzing dependencies'),
              const _CodeLine(text: '✓ Compiling application'),
              const _CodeLine(text: '✓ Optimizing assets'),
              const _CodeLine(text: '✓ Building release bundle'),
              const SizedBox(height: 16),
              const Text(
                'BUILD SUCCESSFUL',
                style: TextStyle(
                  color: Color(0xFF14B8A6),
                  fontWeight: FontWeight.w900,
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeLine extends StatelessWidget {
  final String text;
  final bool isInput;

  const _CodeLine({required this.text, this.isInput = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          color: isInput ? Colors.white : Colors.white.withValues(alpha: 0.4),
          fontFamily: 'JetBrainsMono',
          fontSize: 13,
        ),
      ),
    );
  }
}
