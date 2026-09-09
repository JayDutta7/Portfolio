import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/profile_models.dart';
import '../../../core/utils/asset_utils.dart';
import '../common/section_wrapper.dart';

class DeviceShowcase extends StatefulWidget {
  final List<Project> projects;
  const DeviceShowcase({required this.projects, super.key});

  @override
  State<DeviceShowcase> createState() => _DeviceShowcaseState();
}

class _DeviceShowcaseState extends State<DeviceShowcase> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentProject = widget.projects[_selectedIndex];

    return SectionWrapper(
      background: theme.colorScheme.surface,
      child: Column(
        children: [
          const SectionHeading(
            eyebrow: '02 / ADAPTABILITY',
            title: 'Built for the devices\npeople actually use.',
            alignment: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 64),
          _ProjectSwitcher(
            projects: widget.projects,
            selectedIndex: _selectedIndex,
            onChanged: (index) => setState(() => _selectedIndex = index),
          ),
          const SizedBox(height: 80),
          _DeviceGallery(project: currentProject),
        ],
      ),
    );
  }
}

class _ProjectSwitcher extends StatelessWidget {
  final List<Project> projects;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _ProjectSwitcher({
    required this.projects,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < projects.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ChoiceChip(
                label: Text(projects[i].title.toUpperCase()),
                selected: selectedIndex == i,
                onSelected: (selected) => selected ? onChanged(i) : null,
                labelStyle: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: selectedIndex == i ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                backgroundColor: Colors.transparent,
                selectedColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                side: BorderSide(
                  color: selectedIndex == i ? theme.colorScheme.primary : theme.dividerColor,
                ),
                showCheckmark: false,
              ),
            ),
        ],
      ),
    );
  }
}

class _DeviceGallery extends StatelessWidget {
  final Project project;
  const _DeviceGallery({required this.project});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktopOrWider(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Flex(
        key: ValueKey(project.title),
        direction: isDesktop ? Axis.horizontal : Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _DeviceItem(
            label: 'Android',
            width: 160,
            height: 360,
            deviceAsset: screenshotAsset(project.title, 'android'),
            accent: const Color(0xFF3DDC84),
          ),
          const SizedBox(width: 32, height: 32),
          _DeviceItem(
            label: 'iPhone',
            width: 160,
            height: 380,
            deviceAsset: screenshotAsset(project.title, 'iphone'),
            accent: Colors.white,
          ),
          const SizedBox(width: 32, height: 32),
          _DeviceItem(
            label: 'Tablet',
            width: 260,
            height: 380,
            deviceAsset: screenshotAsset(project.title, 'tablet'),
            accent: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _DeviceItem extends StatelessWidget {
  final String label;
  final double width;
  final double height;
  final String deviceAsset;
  final Color accent;

  const _DeviceItem({
    required this.label,
    required this.width,
    required this.height,
    required this.deviceAsset,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF000000),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF1F1F21), width: 6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.32),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              deviceAsset,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Center(
                child: Opacity(
                  opacity: 0.08,
                  child: Icon(Icons.smartphone_rounded, size: 96, color: accent),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.32),
          ),
        ),
      ],
    );
  }
}
