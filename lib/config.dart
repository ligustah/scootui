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

  /// Default BRouter endpoint URL
  static String routerEndpoint = 'http://localhost:17777';

  /// Default Valhalla endpoint URL
  static String valhallaEndpoint = 'http://localhost:8002';

  /// Redis brouter endpoint setting key
  static const String routerEndpointKey = 'brouter-url';

  // TODO: add to setting service
  /// Redis valhalla endpoint setting key
  // static const String valhallaEndpointKey = 'valhalla-url';

  /// Redis illumination sensor key
  static const String illuminationKey = 'illumination';

  /// Auto theme light threshold (lux) - switch to light theme above this value
  static const double autoThemeLightThreshold = 25.0;

  /// Auto theme dark threshold (lux) - switch to dark theme below this value
  static const double autoThemeDarkThreshold = 15.0;
}
