import 'dart:async';

import 'package:flutter/foundation.dart';

import '../config.dart';
import '../repositories/mdb_repository.dart';

/// Service for managing automatic theme switching based on brightness sensor
class AutoThemeService {
  final MDBRepository _mdbRepository;
  Timer? _brightnessTimer;
  StreamSubscription? _brightnessSubscription;

  // Exponential smoothing for brightness (better than simple averaging)
  double? _smoothedBrightness;
  static const double _smoothingFactor = 0.7; // Alpha value for exponential smoothing (0.0 to 1.0)

  // Current state tracking
  String _currentTheme = 'dark';
  bool _isAutoEnabled = false;

  // Callbacks
  Function(String)? onThemeChanged;

  AutoThemeService(this._mdbRepository);

  /// Initialize the auto theme service
  Future<void> initialize({Function(String)? themeCallback}) async {
    debugPrint('🌞 AutoThemeService: Initializing');
    onThemeChanged = themeCallback;

    // Subscribe to brightness changes
    _subscribeToBrightnessChanges();

    // Start periodic brightness monitoring
    _startBrightnessMonitoring();
  }

  /// Enable or disable auto theme mode
  void setAutoMode(bool enabled) {
    debugPrint('🌞 AutoThemeService: Setting auto mode to $enabled');
    _isAutoEnabled = enabled;

    if (enabled) {
      _startBrightnessMonitoring();
      // Immediately check current brightness when enabling auto mode
      _checkBrightness();
    } else {
      _stopBrightnessMonitoring();
    }
  }

  /// Subscribe to brightness sensor changes
  void _subscribeToBrightnessChanges() {
    debugPrint('🌞 AutoThemeService: Subscribing to brightness changes');
    _brightnessSubscription = _mdbRepository.subscribe(AppConfig.redisSettingsCluster).listen(
      (event) {
        final (_, key) = event;
        if (key == AppConfig.brightnessKey) {
          _handleBrightnessChange();
        }
      },
      onError: (e) {
        debugPrint('🌞 AutoThemeService: Error in brightness subscription: $e');
      },
    );
  }

  /// Start periodic brightness monitoring
  void _startBrightnessMonitoring() {
    if (!_isAutoEnabled) return;

    debugPrint('🌞 AutoThemeService: Starting brightness monitoring');
    _brightnessTimer?.cancel();
    _brightnessTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkBrightness();
    });
  }

  /// Stop brightness monitoring
  void _stopBrightnessMonitoring() {
    debugPrint('🌞 AutoThemeService: Stopping brightness monitoring');
    _brightnessTimer?.cancel();
    _brightnessTimer = null;
  }

  /// Handle brightness change events
  void _handleBrightnessChange() {
    if (!_isAutoEnabled) return;
    _checkBrightness();
  }

  /// Check current brightness and update theme if needed
  Future<void> _checkBrightness() async {
    if (!_isAutoEnabled) return;

    try {
      final brightnessStr = await _mdbRepository.get(AppConfig.redisSettingsCluster, AppConfig.brightnessKey);
      if (brightnessStr == null) return;

      final brightness = double.tryParse(brightnessStr);
      if (brightness == null) return;

      debugPrint('🌞 AutoThemeService: Current brightness: $brightness lux');

      // Apply exponential smoothing
      if (_smoothedBrightness == null) {
        // Initialize with first reading
        _smoothedBrightness = brightness;
      } else {
        // Exponential smoothing: smoothed = α * current + (1 - α) * previous_smoothed
        _smoothedBrightness = _smoothingFactor * brightness + (1 - _smoothingFactor) * _smoothedBrightness!;
      }

      debugPrint('🌞 AutoThemeService: Smoothed brightness: ${_smoothedBrightness!.toStringAsFixed(2)} lux');

      // Calculate theme using smoothed value
      _calculateTheme();
    } catch (e) {
      debugPrint('🌞 AutoThemeService: Error checking brightness: $e');
    }
  }

  /// Calculate theme based on smoothed brightness with hysteresis
  void _calculateTheme() {
    if (_smoothedBrightness == null) return;

    final smoothedBrightness = _smoothedBrightness!;

    debugPrint('🌞 AutoThemeService: Using smoothed brightness: ${smoothedBrightness.toStringAsFixed(2)} lux');
    debugPrint('🌞 AutoThemeService: Current theme: $_currentTheme');

    String newTheme = _currentTheme;

    // Implement hysteresis similar to OEM backlight logic
    if (_currentTheme == 'dark') {
      // Switch to light theme if brightness is above light threshold
      if (smoothedBrightness > AppConfig.autoThemeLightThreshold) {
        newTheme = 'light';
        debugPrint('🌞 AutoThemeService: Switching to LIGHT theme');
      } else {
        debugPrint('🌞 AutoThemeService: Staying DARK');
      }
    } else if (_currentTheme == 'light') {
      // Switch to dark theme if brightness is below dark threshold
      if (smoothedBrightness < AppConfig.autoThemeDarkThreshold) {
        newTheme = 'dark';
        debugPrint('🌞 AutoThemeService: Switching to DARK theme');
      } else {
        debugPrint('🌞 AutoThemeService: Staying LIGHT');
      }
    }

    // Update theme if it changed
    if (newTheme != _currentTheme) {
      _currentTheme = newTheme;
      onThemeChanged?.call(newTheme);
    }
  }

  /// Get current resolved theme
  String get currentTheme => _currentTheme;

  /// Check if auto mode is enabled
  bool get isAutoEnabled => _isAutoEnabled;

  /// Get current smoothed brightness value (for debugging)
  double? get smoothedBrightness => _smoothedBrightness;

  /// Dispose resources
  void dispose() {
    debugPrint('🌞 AutoThemeService: Disposing');
    _brightnessTimer?.cancel();
    _brightnessSubscription?.cancel();
  }
}
