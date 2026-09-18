// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

int computeDynamicBaseline() {
  const storageKey = 'portfolio_visitor_count';
  try {
    final stored = html.window.localStorage[storageKey];
    if (stored != null) {
      final parsed = int.tryParse(stored);
      if (parsed != null && parsed > 0) return parsed;
    }
  } catch (_) {}
  return 1;
}

/// Web implementation of visitor counter using browser storage & background tracker
Future<int> getVisitorCountImpl() async {
  const storageKey = 'portfolio_visitor_count';
  const sessionKey = 'portfolio_session_counted';

  try {
    // Ping external tracker via invisible image prefetch
    try {
      html.ImageElement(src: 'https://visitor-badge.laobi.icu/badge?page_id=jayajitdutta.portfolio');
    } catch (_) {}

    final stored = html.window.localStorage[storageKey];
    int count = stored != null ? (int.tryParse(stored) ?? 1) : 1;

    final sessionLogged = html.window.sessionStorage[sessionKey];
    if (sessionLogged == null) {
      count++;
      html.window.localStorage[storageKey] = count.toString();
      html.window.sessionStorage[sessionKey] = 'true';
    }

    return count;
  } catch (_) {
    return 1;
  }
}

Future<int> incrementVisitorCountImpl() async {
  const storageKey = 'portfolio_visitor_count';
  try {
    final stored = html.window.localStorage[storageKey];
    int count = stored != null ? (int.tryParse(stored) ?? 1) : 1;
    count++;
    html.window.localStorage[storageKey] = count.toString();
    return count;
  } catch (_) {
    return 1;
  }
}
