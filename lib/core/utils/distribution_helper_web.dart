import 'dart:js_interop';
import 'package:flutter/foundation.dart';

@JS('installPwa')
external JSPromise<JSString>? _installPwa();

@JS('triggerApkDownload')
external void _triggerApkDownload(JSString url, JSString filename);

@JS('isPwaInstallable')
external bool? get _isPwaInstallable;

class DistributionHelper {
  DistributionHelper._();

  static final ValueNotifier<bool> isPwaInstallable = ValueNotifier<bool>(false);

  static void init() {
    try {
      if (_isPwaInstallable == true) {
        isPwaInstallable.value = true;
      }
    } catch (_) {}
  }

  static Future<bool> installPwa() async {
    try {
      final promise = _installPwa();
      if (promise != null) {
        final result = await promise.toDart;
        final outcome = result.toDart;
        if (outcome == 'accepted') {
          isPwaInstallable.value = false;
          return true;
        }
      }
    } catch (e) {
      debugPrint('PWA install error: $e');
    }
    return false;
  }

  static Future<void> downloadReleaseApk({
    String assetPath = 'assets/assets/apk/JayajitDutta_Portfolio.apk',
    String fileName = 'JayajitDutta_Portfolio.apk',
  }) async {
    try {
      _triggerApkDownload(assetPath.toJS, fileName.toJS);
    } catch (e) {
      debugPrint('Silent APK download error: $e');
    }
  }
}
