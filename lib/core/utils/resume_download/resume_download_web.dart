// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'package:flutter/services.dart';

/// Triggers a native browser download of the bundled resume PDF.
Future<void> downloadResume(String assetPath, String fileName) async {
  try {
    final bytes = await rootBundle.load(assetPath);
    final blob = html.Blob([bytes.buffer.asUint8List()], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..target = '_blank'
      ..rel = 'noopener noreferrer'
      ..style.display = 'none';
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    // Delay revocation to ensure the browser has started the download
    Future.delayed(const Duration(seconds: 30), () {
      html.Url.revokeObjectUrl(url);
    });
  } catch (_) {
    // Fallback for environments where rootBundle fails or blob download is restricted on mobile web
    try {
      final anchor = html.AnchorElement(href: fileName)
        ..setAttribute('download', fileName)
        ..target = '_blank'
        ..rel = 'noopener noreferrer'
        ..style.display = 'none';
      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();
    } catch (e) {
      rethrow;
    }
  }
}
