import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

/// Writes the bundled resume PDF to a temp file and opens it with the
/// platform's default viewer / share sheet (Android, iOS, macOS, Windows,
/// Linux).
Future<void> downloadResume(String assetPath, String fileName) async {
  final bytes = await rootBundle.load(assetPath);
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsBytes(
    bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
    flush: true,
  );
  await OpenFile.open(file.path);
}
