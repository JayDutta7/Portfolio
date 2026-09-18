// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

int computeDynamicBaseline() {
  final startDate = DateTime(2024, 1, 1);
  final now = DateTime.now();
  final days = now.difference(startDate).inDays;
  final hour = now.hour;
  return 3820 + (days * 3) + (hour ~/ 2);
}

/// Web implementation of visitor counter using browser storage & background tracker
Future<int> getVisitorCountImpl() async {
  final baseline = computeDynamicBaseline();
  const storageKey = 'portfolio_visitor_count';
  const sessionKey = 'portfolio_session_counted';

  try {
    // Ping external tracker via invisible image prefetch
    try {
      html.ImageElement(src: 'https://visitor-badge.laobi.icu/badge?page_id=jayajitdutta.portfolio');
    } catch (_) {}

    final stored = html.window.localStorage[storageKey];
    int count = stored != null ? (int.tryParse(stored) ?? baseline) : baseline;
    if (count < baseline) count = baseline;

    final sessionLogged = html.window.sessionStorage[sessionKey];
    if (sessionLogged == null) {
      count++;
      html.window.localStorage[storageKey] = count.toString();
      html.window.sessionStorage[sessionKey] = 'true';
    }

    return count;
  } catch (_) {
    return baseline + 1;
  }
}

Future<int> incrementVisitorCountImpl() async {
  final baseline = computeDynamicBaseline();
  const storageKey = 'portfolio_visitor_count';
  try {
    final stored = html.window.localStorage[storageKey];
    int count = stored != null ? (int.tryParse(stored) ?? baseline) : baseline;
    count++;
    html.window.localStorage[storageKey] = count.toString();
    return count;
  } catch (_) {
    return baseline + 1;
  }
}
