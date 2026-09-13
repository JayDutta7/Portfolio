import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class DistributionHelper {
  DistributionHelper._();

  static final ValueNotifier<bool> isPwaInstallable = ValueNotifier<bool>(false);

  static void init() {
    // Non-web platforms do not have browser beforeinstallprompt
  }

  static Future<bool> installPwa() async {
    return false;
  }

  static Future<void> downloadReleaseApk({
    String assetPath = 'assets/apk/JayajitDutta_Portfolio.apk',
    String fileName = 'JayajitDutta_Portfolio.apk',
  }) async {
    // Fallback on native/desktop: launch URL or direct repo release
    const fallbackUrl = 'https://github.com/JayDutta7/Portfolio/releases';
    final uri = Uri.parse(fallbackUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
