import 'package:flutter/material.dart';

/// Application runtime environment (DEV, UAT, PROD).
///
/// Configured at build time via:
/// `--dart-define=APP_ENV=dev|uat|prod`
enum AppEnvironment {
  dev,
  uat,
  prod;

  static const String _rawEnv = String.fromEnvironment('APP_ENV', defaultValue: 'prod');

  static AppEnvironment get current {
    switch (_rawEnv.toLowerCase()) {
      case 'dev':
      case 'development':
        return AppEnvironment.dev;
      case 'uat':
      case 'staging':
      case 'qa':
        return AppEnvironment.uat;
      case 'prod':
      case 'production':
      default:
        return AppEnvironment.prod;
    }
  }

  static bool get isDev => current == AppEnvironment.dev;
  static bool get isUat => current == AppEnvironment.uat;
  static bool get isProd => current == AppEnvironment.prod;

  /// Human-readable label for environment badge
  String get label {
    switch (this) {
      case AppEnvironment.dev:
        return 'DEV';
      case AppEnvironment.uat:
        return 'UAT';
      case AppEnvironment.prod:
        return 'PROD';
    }
  }

  /// Theme accent color for environment indicators
  Color get badgeColor {
    switch (this) {
      case AppEnvironment.dev:
        return const Color(0xFFF59E0B); // Amber / Warning
      case AppEnvironment.uat:
        return const Color(0xFF8B5CF6); // Violet / Staging
      case AppEnvironment.prod:
        return const Color(0xFF10B981); // Emerald / Production
    }
  }

  /// Firebase RTDB node prefix to prevent DEV/UAT testing from
  /// polluting production counters.
  String get dbPrefix {
    switch (this) {
      case AppEnvironment.dev:
        return 'portfolio_dev';
      case AppEnvironment.uat:
        return 'portfolio_uat';
      case AppEnvironment.prod:
        return 'portfolio';
    }
  }
}
