part of 'theme_cubit.dart';

@freezed
abstract class ThemeState with _$ThemeState {
  const ThemeState._();
  const factory ThemeState({
    required ThemeData lightTheme,
    required ThemeData darkTheme,
    @Default(ThemeMode.dark) ThemeMode themeMode,
    @Default(false) bool isAutoMode,
    @Default(ThemeMode.dark) ThemeMode autoResolvedTheme,
  }) = _ThemeState;

  bool get isDark => isAutoMode ? autoResolvedTheme == ThemeMode.dark : themeMode == ThemeMode.dark;
  ThemeData get theme => isDark ? darkTheme : lightTheme;
  ThemeMode get effectiveThemeMode => isAutoMode ? autoResolvedTheme : themeMode;
}
