import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../theme_config.dart';

part 'theme_cubit.freezed.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(ThemeData light, ThemeData dark)
      : super(ThemeState(lightTheme: light, darkTheme: dark));

  void updateTheme(ThemeMode newTheme) {
    emit(state.copyWith(themeMode: newTheme));
  }

  void toggleTheme() {
    final newTheme =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    updateTheme(newTheme);
  }

  static ThemeCubit create(BuildContext context) =>
      ThemeCubit(AppThemes.lightTheme, AppThemes.darkTheme);

  static ThemeState watch(BuildContext context) =>
      context.watch<ThemeCubit>().state;
}
