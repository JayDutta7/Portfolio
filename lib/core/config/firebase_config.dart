import 'package:firebase_core/firebase_core.dart';

/// Centralized configuration for Firebase Realtime Database.
///
/// Credentials are read securely at compile time from `.env` via:
/// `--dart-define-from-file=.env`
///
/// Never hardcode credentials in this file.
class FirebaseConfig {
  FirebaseConfig._();

  static const String projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const String messagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
  static const String _rawDatabaseURL = String.fromEnvironment('FIREBASE_DATABASE_URL');
  static String get databaseURL => _rawDatabaseURL.replaceAll(RegExp(r'/+$'), '');
  static const String apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const String appId = String.fromEnvironment('FIREBASE_APP_ID');

  /// Returns true only when valid Firebase credentials are provided via .env
  static bool get isConfigured =>
      apiKey.isNotEmpty && projectId.isNotEmpty && databaseURL.isNotEmpty;

  static FirebaseOptions get options {
    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      databaseURL: databaseURL,
    );
  }
}
