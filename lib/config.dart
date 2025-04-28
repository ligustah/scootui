/// Static configuration values for the application
class AppConfig {
  /// Default configuration file path (can be overridden with environment variables)
  static String? settingsFilePath;

  /// Redis settings cluster name
  static const String redisSettingsCluster = 'dashboard';

  /// Redis theme setting key
  static const String themeSettingKey = 'theme';

  /// Redis mode setting key
  static const String modeSettingKey = 'mode';
}
