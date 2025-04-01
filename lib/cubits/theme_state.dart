part of 'theme_cubit.dart';

@freezed
abstract class ThemeState with _$ThemeState {
  const ThemeState._();
  const factory ThemeState({
    required ThemeData lightTheme,
    required ThemeData darkTheme,
    @Default(ThemeMode.dark) ThemeMode themeMode,
  }) = _ThemeState;

  bool get isDark => themeMode == ThemeMode.dark;
  ThemeData get theme => isDark ? darkTheme : lightTheme;
}
