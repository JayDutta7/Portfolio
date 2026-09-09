String _slugify(String input) {
  return input
      .toLowerCase()
      .replaceAll(RegExp(r"[^a-z0-9]+"), "_")
      .replaceAll(RegExp(r"_+"), "_")
      .trim()
      .replaceAll(RegExp(r"^_|_"), "");
}

/// Build a conventional asset path for a project screenshot.
/// Expected files (optional):
///  - assets/images/screens/<project-slug>_android.png
///  - assets/images/screens/<project-slug>_iphone.png
///  - assets/images/screens/<project-slug>_tablet.png
/// These are not required; Image.asset(...) calls should provide an
/// errorBuilder fallback.
String screenshotAsset(String projectTitle, String device) {
  final slug = _slugify(projectTitle);
  final deviceKey = device.toLowerCase();
  return 'assets/images/screens/${slug}_$deviceKey.png';
}
