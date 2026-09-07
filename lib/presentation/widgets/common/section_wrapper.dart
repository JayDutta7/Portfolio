import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

/// Wraps every page section with consistent horizontal padding,
/// a capped max content width (for ultrawide screens) and optional
/// background color / vertical padding.
class SectionWrapper extends StatelessWidget {
  final Widget child;
  final Color? background;
  final double verticalPadding;
  final Key? sectionKey;

  const SectionWrapper({
    required this.child,
    this.background,
    this.verticalPadding = 96,
    this.sectionKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.pagePadding(context);
    final maxWidth = Responsive.maxContentWidth(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      key: sectionKey,
      width: double.infinity,
      color: background,
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: isMobile ? verticalPadding * 0.6 : verticalPadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}

/// Small "eyebrow" label + headline used at the top of every section.
class SectionHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? description;
  final CrossAxisAlignment alignment;

  const SectionHeading({
    required this.eyebrow,
    required this.title,
    this.description,
    this.alignment = CrossAxisAlignment.start,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textAlign =
        alignment == CrossAxisAlignment.center ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          eyebrow.toUpperCase(),
          textAlign: textAlign,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: textAlign,
          style: theme.textTheme.headlineLarge,
        ),
        if (description != null) ...[
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              description!,
              textAlign: textAlign,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
        const SizedBox(height: 48),
      ],
    );
  }
}
