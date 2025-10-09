// lib/services/platform_service.dart
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// A simple, centralized service for detecting which platform the app is running on.
/// Use it anywhere: `PlatformService.isAndroid`, `PlatformService.useCupertino`, etc.
class PlatformService {
  PlatformService._(); // Prevent instantiation

  /// Returns the current platform as an [AppPlatform] enum.
  static AppPlatform get platform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AppPlatform.android;
      case TargetPlatform.iOS:
        return AppPlatform.iOS;
      default:
        return AppPlatform.iOS; // Default to iOS for other platforms
    }
  }

  // ----------- Quick access helpers -----------

  static bool get isAndroid => platform == AppPlatform.android;
  static bool get isIOS => platform == AppPlatform.iOS;

  /// Use Cupertino widgets (iOS/macOS).
  static bool get useCupertino => isIOS;

  /// Use Material widgets (Android, Web, others).
  static bool get useMaterial => !useCupertino;
}

/// AppPlatform enum - intentionally independent of dart:io's Platform
/// so this also works safely on Web.
enum AppPlatform {
  android,
  iOS,
}
