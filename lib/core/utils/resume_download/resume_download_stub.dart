/// Fallback used only if neither dart:html nor dart:io is available.
Future<void> downloadResume(String assetPath, String fileName) async {
  throw UnsupportedError('Resume download is not supported on this platform.');
}
