import 'package:flutter/material.dart';

class ScooterColors {
  // Dark mode colors
  static final darkModeColors = {
    'speedometerBackground': Colors.grey.shade800,
    'speedometerActive': Colors.blue,
    'speedometerInactive': Colors.grey,
    'regenerativeColor': Colors.green.withOpacity(0.2),
    'batteryGoodColor': Colors.green,
    'batteryWarningColor': Colors.orange,
    'batteryErrorColor': Colors.redAccent,
  };

  // Light mode colors
  static final lightModeColors = {
    'speedometerBackground': Colors.grey.shade200,
    'speedometerActive': Colors.blue,
    'speedometerInactive': Colors.grey.shade600,
    'regenerativeColor': Colors.green.withOpacity(0.2),
    'batteryGoodColor': Colors.green,
    'batteryWarningColor': Colors.orange,
    'batteryErrorColor': Colors.red,
  };
}

class AppThemes {
  // Base dark theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Colors.grey.shade900,
      error: Colors.redAccent,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );

  // Base light theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Colors.grey.shade200,
      error: Colors.red,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  );
}
