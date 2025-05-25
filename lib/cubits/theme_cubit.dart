import 'dart:async'; // Import dart:async for StreamSubscription

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/settings_service.dart';
import '../services/auto_theme_service.dart';
import '../theme_config.dart';

part 'theme_cubit.freezed.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SettingsService _settingsService;
  final AutoThemeService _autoThemeService;
  late StreamSubscription _settingsSubscription; // Add subscription

  ThemeCubit(ThemeData light, ThemeData dark, this._settingsService, this._autoThemeService)
      : super(ThemeState(
          lightTheme: light,
          darkTheme: dark,
          themeMode: _settingsService.getThemeSetting(),
          isAutoMode: _settingsService.getAutoThemeSetting(),
          autoResolvedTheme:
              _settingsService.getAutoThemeSetting() ? ThemeMode.dark : _settingsService.getThemeSetting(),
        )) {
    // Subscribe to settings updates
    _settingsSubscription = _settingsService.settingsStream.listen((settings) {
      final themeMode = _settingsService.getThemeSetting();
      final isAutoMode = _settingsService.getAutoThemeSetting();

      emit(state.copyWith(
        themeMode: themeMode,
        isAutoMode: isAutoMode,
        autoResolvedTheme: isAutoMode ? state.autoResolvedTheme : themeMode,
      ));

      // Update auto theme service
      _autoThemeService.setAutoMode(isAutoMode);
    });

    // Initialize auto theme service
    _initializeAutoTheme();
  }

  Future<void> _initializeAutoTheme() async {
    await _autoThemeService.initialize(themeCallback: (resolvedTheme) {
      final newThemeMode = resolvedTheme == 'light' ? ThemeMode.light : ThemeMode.dark;
      emit(state.copyWith(autoResolvedTheme: newThemeMode));
    });

    // Set initial auto mode state
    _autoThemeService.setAutoMode(state.isAutoMode);
  }

  void updateTheme(ThemeMode newTheme) async {
    // No need to emit here, the stream listener will handle it
    await _settingsService.updateThemeSetting(newTheme);
  }

  void updateAutoTheme(bool enabled) async {
    await _settingsService.updateAutoThemeSetting(enabled);
  }

  void toggleTheme() {
    if (state.isAutoMode) {
      // If in auto mode, disable auto mode and set to opposite of current resolved theme
      final newTheme = state.autoResolvedTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      updateAutoTheme(false);
      updateTheme(newTheme);
    } else {
      // Normal toggle behavior
      final newTheme = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      updateTheme(newTheme);
    }
  }

  void toggleAutoMode() {
    updateAutoTheme(!state.isAutoMode);
  }

  static ThemeCubit create(BuildContext context) {
    final settingsService = context.read<SettingsService>();
    final autoThemeService = context.read<AutoThemeService>();
    return ThemeCubit(AppThemes.lightTheme, AppThemes.darkTheme, settingsService, autoThemeService);
  }

  static ThemeState watch(BuildContext context) => context.watch<ThemeCubit>().state;

  @override
  Future<void> close() {
    _settingsSubscription.cancel(); // Cancel subscription on close
    _autoThemeService.dispose();
    return super.close();
  }
}
