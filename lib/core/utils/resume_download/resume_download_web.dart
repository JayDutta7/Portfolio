// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Triggers a native browser download of the bundled resume PDF.
Future<void> downloadResume(String assetPath, String fileName) async {
  final anchor = html.AnchorElement(href: assetPath)
    ..setAttribute('download', fileName)
    ..style.display = 'none';
  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
