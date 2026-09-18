// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

const int kRealisticVisitorBaseline = 120;

int computeDynamicBaseline() {
  const storageKey = 'portfolio_visitor_count';
  try {
    final stored = html.window.localStorage[storageKey];
    if (stored != null) {
      final parsed = int.tryParse(stored);
      if (parsed != null && parsed >= kRealisticVisitorBaseline) return parsed;
    }
  } catch (_) {}
  return kRealisticVisitorBaseline;
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
    int count = stored != null ? (int.tryParse(stored) ?? kRealisticVisitorBaseline) : kRealisticVisitorBaseline;
    if (count < kRealisticVisitorBaseline) count = kRealisticVisitorBaseline;

    final sessionLogged = html.window.sessionStorage[sessionKey];
    if (sessionLogged == null) {
      count++;
      html.window.localStorage[storageKey] = count.toString();
      html.window.sessionStorage[sessionKey] = 'true';
    }

    return count;
  } catch (_) {
    return kRealisticVisitorBaseline;
  }
}

Future<int> incrementVisitorCountImpl() async {
  const storageKey = 'portfolio_visitor_count';
  try {
    final stored = html.window.localStorage[storageKey];
    int count = stored != null ? (int.tryParse(stored) ?? kRealisticVisitorBaseline) : kRealisticVisitorBaseline;
    if (count < kRealisticVisitorBaseline) count = kRealisticVisitorBaseline;
    count++;
    html.window.localStorage[storageKey] = count.toString();
    return count;
  } catch (_) {
    return kRealisticVisitorBaseline + 1;
  }
}

void syncVisitorCountLocal(int newCount) {
  const storageKey = 'portfolio_visitor_count';
  try {
    if (newCount > 0) {
      html.window.localStorage[storageKey] = newCount.toString();
    }
  } catch (_) {}
}

