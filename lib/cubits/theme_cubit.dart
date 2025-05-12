import 'dart:async'; // Import dart:async for StreamSubscription

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/settings_service.dart';
import '../theme_config.dart';

part 'theme_cubit.freezed.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SettingsService _settingsService;
  late StreamSubscription _settingsSubscription; // Add subscription

  ThemeCubit(ThemeData light, ThemeData dark, this._settingsService)
      : super(ThemeState(lightTheme: light, darkTheme: dark, themeMode: _settingsService.getThemeSetting())) {
    // Subscribe to settings updates
    _settingsSubscription = _settingsService.settingsStream.listen((settings) {
      final themeMode = _settingsService.getThemeSetting(); // Get updated theme mode
      emit(state.copyWith(themeMode: themeMode)); // Emit new state
    });
  }

  void updateTheme(ThemeMode newTheme) async {
    // No need to emit here, the stream listener will handle it
    await _settingsService.updateThemeSetting(newTheme);
  }

  void toggleTheme() {
    final newTheme = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    updateTheme(newTheme);
  }

  static ThemeCubit create(BuildContext context) {
    final settingsService = context.read<SettingsService>();
    return ThemeCubit(AppThemes.lightTheme, AppThemes.darkTheme, settingsService);
  }

  static ThemeState watch(BuildContext context) => context.watch<ThemeCubit>().state;

  @override
  Future<void> close() {
    _settingsSubscription.cancel(); // Cancel subscription on close
    return super.close();
  }
}
