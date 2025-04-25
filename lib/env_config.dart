import 'dart:io';

import 'package:flutter/foundation.dart';

import 'config.dart';

/// Loads environment-specific configuration
class EnvConfig {
  /// Initialize application configuration from environment variables
  static void initialize() {
    // Only process environment variables on native platforms
    if (kIsWeb) return;

    // Get settings file path from environment variable if available
    final configPath = Platform.environment['SCOOTUI_SETTINGS_PATH'];
    if (configPath != null && configPath.isNotEmpty) {
      AppConfig.settingsFilePath = configPath;
      debugPrint('Using settings file from environment: $configPath');
    }
  }
}
