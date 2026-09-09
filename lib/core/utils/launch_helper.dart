import 'package:url_launcher/url_launcher.dart';

class LaunchHelper {
  LaunchHelper._();

  static Future<void> openUrl(String url) async {
    // If the URL doesn't have a protocol, prepend https:// to prevent it
    // from being treated as a relative path on the web.
    var targetUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      targetUrl = 'https://$url';
    }
    final uri = Uri.parse(targetUrl);
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  static Future<void> sendEmail(String email, {String? subject}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: subject != null ? 'subject=${Uri.encodeComponent(subject)}' : null,
    );
    await launchUrl(uri);
  }
}
