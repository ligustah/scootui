import 'dart:async'; // Import dart:async for StreamController
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../config.dart';
import '../repositories/mdb_repository.dart';

/// Service for managing persistent settings across app restarts
class SettingsService {
  final MDBRepository _mdbRepository;
  String? _configFilePath;
  Map<String, dynamic> _settings = {};
  bool _initialized = false;

  // StreamController to emit settings updates
  final _settingsController = StreamController<Map<String, dynamic>>.broadcast();

  /// Stream of settings updates
  Stream<Map<String, dynamic>> get settingsStream => _settingsController.stream;

  SettingsService(this._mdbRepository);

  /// Initializes the settings service by loading settings from Redis,
  /// falling back to config file if Redis values aren't available
  Future<void> initialize({String? configFilePath}) async {
    if (_initialized) return;

    debugPrint('🔧 SettingsService: Initializing');

    // Set the config file path if provided, otherwise use default or global config
    _configFilePath = configFilePath ?? AppConfig.settingsFilePath ?? await _getDefaultConfigPath();
    debugPrint('🔧 SettingsService: Config file path - $_configFilePath');

    // Try to load from config file first (as a fallback)
    await _loadFromFile();
    debugPrint('🔧 SettingsService: Loaded from file - $_settings');

    // Then try to load from Redis (which takes precedence)
    await _loadFromRedis();
    debugPrint('🔧 SettingsService: Loaded from Redis - $_settings');

    // If we loaded from file but Redis didn't have the values,
    // update Redis with our file values
    await _syncRedisFromSettings();

    // Print current settings
    final theme = getThemeSetting();
    final autoTheme = getAutoThemeSetting();
    final mode = getScreenSetting();
    final routerEndpoint = getRouterEndpoint();
    debugPrint(
        '🔧 SettingsService: Final settings - Theme: ${theme.toString()}, Auto Theme: $autoTheme, Mode: $mode, Router Endpoint: $routerEndpoint');

    // Emit the initial loaded settings
    _settingsController.add(_settings);

    // Subscribe to Redis changes
    _subscribeToRedisChanges();

    _initialized = true;
  }

  /// Returns the default path for the config file
  Future<String> _getDefaultConfigPath() async {
    if (kIsWeb) {
      // For web platform, we don't use the file system
      debugPrint('🔧 SettingsService: Web platform detected - using in-memory settings');
      return '';
    }

    final directory = await getApplicationSupportDirectory();
    debugPrint('🔧 SettingsService: App support directory - ${directory.path}');
    return '${directory.path}/settings.json';
  }

  /// Loads settings from the config file
  Future<void> _loadFromFile() async {
    if (_configFilePath == null || _configFilePath!.isEmpty || kIsWeb) {
      debugPrint('🔧 SettingsService: Skipping file load for web platform or null path');
      return;
    }

    try {
      final file = File(_configFilePath!);
      if (await file.exists()) {
        debugPrint('🔧 SettingsService: Config file exists, loading');
        final String contents = await file.readAsString();
        _settings = jsonDecode(contents) as Map<String, dynamic>;
      } else {
        debugPrint('🔧 SettingsService: Config file does not exist yet');
      }
    } catch (e) {
      debugPrint('🔧 SettingsService: Error loading settings from file: $e');
    }
  }

  /// Loads settings from Redis
  Future<void> _loadFromRedis() async {
    try {
      debugPrint('🔧 SettingsService: Loading theme from Redis');
      final themeMode = await _mdbRepository.get(AppConfig.redisSettingsCluster, AppConfig.themeSettingKey);
      debugPrint('🔧 SettingsService: Redis theme = $themeMode');
      if (themeMode != null) {
        _settings[AppConfig.themeSettingKey] = themeMode;
      }

      debugPrint('🔧 SettingsService: Loading mode from Redis');
      final mode = await _mdbRepository.get(AppConfig.redisSettingsCluster, AppConfig.modeSettingKey);
      debugPrint('🔧 SettingsService: Redis mode = $mode');
      if (mode != null) {
        _settings[AppConfig.modeSettingKey] = mode;
      }

      debugPrint('🔧 SettingsService: Loading router endpoint from Redis');
      final routerEndpoint = await _mdbRepository.get(
        AppConfig.redisSettingsCluster,
        AppConfig.routerEndpointKey,
      );
      debugPrint('🔧 SettingsService: Redis router endpoint = $routerEndpoint');
      if (routerEndpoint != null) {
        _settings[AppConfig.routerEndpointKey] = routerEndpoint;
        AppConfig.routerEndpoint = routerEndpoint; // Update AppConfig immediately
      }
    } catch (e) {
      debugPrint('🔧 SettingsService: Error loading settings from Redis: $e');
    }
  }

  /// Syncs Redis with the current settings if Redis is missing values
  Future<void> _syncRedisFromSettings() async {
    try {
      if (_settings.containsKey(AppConfig.themeSettingKey)) {
        final redisTheme = await _mdbRepository.get(AppConfig.redisSettingsCluster, AppConfig.themeSettingKey);
        debugPrint(
            '🔧 SettingsService: Sync check - Redis theme = $redisTheme, settings = ${_settings[AppConfig.themeSettingKey]}');
        if (redisTheme == null) {
          debugPrint('🔧 SettingsService: Syncing theme to Redis');
          await _mdbRepository.set(
            AppConfig.redisSettingsCluster,
            AppConfig.themeSettingKey,
            _settings[AppConfig.themeSettingKey],
          );
        }
      }

      if (_settings.containsKey(AppConfig.modeSettingKey)) {
        final redisMode = await _mdbRepository.get(AppConfig.redisSettingsCluster, AppConfig.modeSettingKey);
        debugPrint(
            '🔧 SettingsService: Sync check - Redis mode = $redisMode, settings = ${_settings[AppConfig.modeSettingKey]}');
        if (redisMode == null) {
          debugPrint('🔧 SettingsService: Syncing mode to Redis');
          await _mdbRepository.set(
            AppConfig.redisSettingsCluster,
            AppConfig.modeSettingKey,
            _settings[AppConfig.modeSettingKey],
          );
        }
      }

      if (_settings.containsKey(AppConfig.routerEndpointKey)) {
        final redisEndpoint = await _mdbRepository.get(
          AppConfig.redisSettingsCluster,
          AppConfig.routerEndpointKey,
        );
        debugPrint(
            '🔧 SettingsService: Sync check - Redis router endpoint = $redisEndpoint, settings = ${_settings[AppConfig.routerEndpointKey]}');
        if (redisEndpoint == null) {
          debugPrint('🔧 SettingsService: Syncing router endpoint to Redis');
          await _mdbRepository.set(
            AppConfig.redisSettingsCluster,
            AppConfig.routerEndpointKey,
            _settings[AppConfig.routerEndpointKey],
          );
        }
      }
    } catch (e) {
      debugPrint('🔧 SettingsService: Error syncing settings to Redis: $e');
    }
  }

  /// Subscribes to Redis changes for settings values
  void _subscribeToRedisChanges() {
    debugPrint('🔧 SettingsService: Subscribing to Redis changes');
    _mdbRepository.subscribe(AppConfig.redisSettingsCluster).listen(
      (event) {
        final (_, key) = event;
        debugPrint('🔧 SettingsService: Received Redis update for key: $key');
        _handleRedisChange(key);
      },
      onError: (e) {
        debugPrint('🔧 SettingsService: Error in Redis subscription: $e');
      },
    );
  }

  /// Handles Redis change events
  Future<void> _handleRedisChange(String key) async {
    try {
      // Only handle changes for keys we expect to save to the settings file
      if (key == AppConfig.themeSettingKey || key == AppConfig.modeSettingKey || key == AppConfig.routerEndpointKey) {
        final value = await _mdbRepository.get(AppConfig.redisSettingsCluster, key);
        debugPrint('🔧 SettingsService: Redis change - key: $key, value: $value');
        if (value != null) {
          _settings[key] = value;

          // Update AppConfig if it's the router endpoint
          if (key == AppConfig.routerEndpointKey) {
            AppConfig.routerEndpoint = value;
          }

          await _saveToFile();
          // Emit updated settings
          _settingsController.add(_settings);
        }
      } else {
        debugPrint('🔧 SettingsService: Ignoring Redis change for key: $key');
      }
    } catch (e) {
      debugPrint('🔧 SettingsService: Error handling Redis change: $e');
    }
  }

  /// Saves the current settings to the config file
  Future<void> _saveToFile() async {
    if (_configFilePath == null || _configFilePath!.isEmpty || kIsWeb) {
      debugPrint('🔧 SettingsService: Skipping file save for web platform or null path');
      return;
    }

    try {
      debugPrint('🔧 SettingsService: Saving settings to file: $_settings');
      final file = File(_configFilePath!);
      await file.writeAsString(jsonEncode(_settings));
    } catch (e) {
      debugPrint('🔧 SettingsService: Error saving settings to file: $e');
    }
  }

  /// Gets a theme setting with fallback to default
  ThemeMode getThemeSetting() {
    final value = _settings[AppConfig.themeSettingKey];
    debugPrint('🔧 SettingsService: Getting theme setting: $value');
    if (value == null) return ThemeMode.dark; // Change default to dark

    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'auto':
        // When theme is 'auto', return dark as the fallback theme mode
        // The actual theme will be determined by auto theme service
        return ThemeMode.dark;
      default:
        return ThemeMode.dark; // Also default to dark for unknown values
    }
  }

  /// Gets the auto theme setting with fallback to default
  bool getAutoThemeSetting() {
    final themeValue = _settings[AppConfig.themeSettingKey];

    debugPrint('🔧 SettingsService: Getting auto theme setting - theme: $themeValue');

    // If theme is set to 'auto', enable auto mode
    if (themeValue == 'auto') {
      return true;
    }

    // Otherwise auto mode is disabled
    return false;
  }

  /// Gets a screen setting with fallback to default
  String getScreenSetting() {
    final value = _settings[AppConfig.modeSettingKey] as String?;
    debugPrint('🔧 SettingsService: Getting screen setting: $value');
    return value ?? 'speedometer';
  }

  /// Gets the router endpoint with fallback to default
  String getRouterEndpoint() {
    return _settings[AppConfig.routerEndpointKey] as String? ?? AppConfig.routerEndpoint;
  }

  /// Updates the router endpoint setting
  Future<void> updateRouterEndpoint(String endpoint) async {
    debugPrint('🔧 SettingsService: Updating router endpoint setting to $endpoint');
    _settings[AppConfig.routerEndpointKey] = endpoint;
    AppConfig.routerEndpoint = endpoint;

    // Save to both file and Redis
    await _saveToFile();
    await _mdbRepository.set(
      AppConfig.redisSettingsCluster,
      AppConfig.routerEndpointKey,
      endpoint,
    );

    // Emit updated settings
    _settingsController.add(_settings);
  }

  /// Updates the theme setting
  Future<void> updateThemeSetting(ThemeMode themeMode) async {
    String value;
    switch (themeMode) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      default:
        value = 'system';
    }

    debugPrint('🔧 SettingsService: Updating theme setting to $value');
    _settings[AppConfig.themeSettingKey] = value;

    // Save to both file and Redis
    await _saveToFile();
    await _mdbRepository.set(AppConfig.redisSettingsCluster, AppConfig.themeSettingKey, value);

    // Emit updated settings
    _settingsController.add(_settings);
  }

  /// Updates the auto theme setting
  Future<void> updateAutoThemeSetting(bool enabled) async {
    debugPrint('🔧 SettingsService: Updating auto theme setting to $enabled');

    if (enabled) {
      // When enabling auto mode, set theme to 'auto'
      _settings[AppConfig.themeSettingKey] = 'auto';
      await _mdbRepository.set(AppConfig.redisSettingsCluster, AppConfig.themeSettingKey, 'auto');
    } else {
      // When disabling auto mode, set theme to 'dark' as default
      _settings[AppConfig.themeSettingKey] = 'dark';
      await _mdbRepository.set(AppConfig.redisSettingsCluster, AppConfig.themeSettingKey, 'dark');
    }

    // Save to file
    await _saveToFile();

    // Emit updated settings
    _settingsController.add(_settings);
  }

  /// Updates the screen setting
  Future<void> updateScreenSetting(String screenMode) async {
    debugPrint('🔧 SettingsService: Updating screen setting to $screenMode');
    _settings[AppConfig.modeSettingKey] = screenMode;

    // Save to both file and Redis
    await _saveToFile();
    await _mdbRepository.set(AppConfig.redisSettingsCluster, AppConfig.modeSettingKey, screenMode);

    // Emit updated settings
    _settingsController.add(_settings);
  }

  /// Dispose the stream controller
  void dispose() {
    _settingsController.close();
  }
}
