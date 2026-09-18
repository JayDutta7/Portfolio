import 'dart:async';
import 'dart:math' as math;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../config/firebase_config.dart';
import '../utils/visitor_counter/visitor_counter.dart';

/// Real-time Visitor & Online Presence Service backed by Firebase Realtime Database
/// with automatic onDisconnect session cleanup and offline-safe fallback.
class FirebasePresenceService {
  static final FirebasePresenceService _instance = FirebasePresenceService._internal();
  factory FirebasePresenceService() => _instance;
  FirebasePresenceService._internal();

  final _totalVisitorsController = StreamController<int>.broadcast();
  final _activeOnlineController = StreamController<int>.broadcast();

  Stream<int> get totalVisitorsStream => _totalVisitorsController.stream;
  Stream<int> get activeOnlineStream => _activeOnlineController.stream;

  int _currentTotal = 0;
  int _currentOnline = 1;
  bool _isInitialized = false;
  String? _sessionId;
  FirebaseDatabase? _database;

  int get currentTotal => _currentTotal;
  int get currentOnline => _currentOnline;
  bool get isFirebaseLive => _database != null && FirebaseConfig.isConfigured;

  Future<void> init() async {
    if (_isInitialized) {
      // Re-emit latest state to any newly subscribed widgets
      if (_currentTotal > 0) {
        _totalVisitorsController.add(_currentTotal);
      }
      if (_currentOnline > 0) {
        _activeOnlineController.add(_currentOnline);
      }
      return;
    }
    _isInitialized = true;

    // Load initial fallback baseline immediately
    final fallbackBaseline = await getVisitorCountImpl();
    _currentTotal = fallbackBaseline;
    _totalVisitorsController.add(_currentTotal);

    if (!FirebaseConfig.isConfigured) {
      // Firebase credentials pending; use dynamic fallback
      return;
    }

    try {
      FirebaseApp app;
      try {
        app = Firebase.app();
      } catch (_) {
        app = await Firebase.initializeApp(options: FirebaseConfig.options);
      }

      _database = FirebaseDatabase.instanceFor(
        app: app,
        databaseURL: FirebaseConfig.databaseURL,
      );

      _sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(999999)}';

      // 1. Listen for connection state and manage onDisconnect presence
      _database!.ref('.info/connected').onValue.listen((event) async {
        final isConnected = (event.snapshot.value as bool?) ?? false;
        debugPrint('[FirebasePresence] Connection state: $isConnected');
        if (isConnected && _sessionId != null) {
          final userRef = _database!.ref('portfolio/online_users/$_sessionId');

          // When connection drops (tab closed or network disconnect), remove node
          await userRef.onDisconnect().remove();

          // Register current user as online
          await userRef.set({
            'connectedAt': ServerValue.timestamp,
            'platform': kIsWeb ? 'web' : defaultTargetPlatform.name,
          });

          // Atomically increment total visitors count dynamically
          final totalRef = _database!.ref('portfolio/total_visitors');
          await totalRef.runTransaction((mutableData) {
            final current = (mutableData as num?)?.toInt() ?? 0;
            return Transaction.success(current + 1);
          });
        }
      }, onError: (err) {
        debugPrint('[FirebasePresence] Connection listener error: $err');
      });

      // 2. Real-time stream of online users count
      _database!.ref('portfolio/online_users').onValue.listen((event) {
        final count = event.snapshot.children.length;
        debugPrint('[FirebasePresence] Live online users count: $count');
        _currentOnline = count > 0 ? count : 1;
        _activeOnlineController.add(_currentOnline);
      }, onError: (err) {
        debugPrint('[FirebasePresence] online_users error: $err');
      });

      // 3. Real-time stream of global total visitors
      _database!.ref('portfolio/total_visitors').onValue.listen((event) {
        final val = (event.snapshot.value as num?)?.toInt();
        debugPrint('[FirebasePresence] Live total visitors: $val');
        if (val != null) {
          _currentTotal = val;
          _totalVisitorsController.add(_currentTotal);
        }
      }, onError: (err) {
        debugPrint('[FirebasePresence] total_visitors error: $err');
      });
    } catch (e) {
      debugPrint('[FirebasePresence] Realtime Database init error: $e');
    }
  }

  /// Manually increment counter (e.g. on user celebratory tap)
  Future<int> incrementManually() async {
    if (isFirebaseLive) {
      try {
        final totalRef = _database!.ref('portfolio/total_visitors');
        final result = await totalRef.runTransaction((mutableData) {
          final current = (mutableData as num?)?.toInt() ?? _currentTotal;
          return Transaction.success(current + 1);
        });
        if (result.committed) {
          _currentTotal = (result.snapshot.value as num?)?.toInt() ?? (_currentTotal + 1);
          _totalVisitorsController.add(_currentTotal);
          return _currentTotal;
        }
      } catch (_) {}
    }

    final localUpdated = await incrementVisitorCountImpl();
    _currentTotal = localUpdated;
    _totalVisitorsController.add(_currentTotal);
    return _currentTotal;
  }

  void dispose() {
    _totalVisitorsController.close();
    _activeOnlineController.close();
  }
}
