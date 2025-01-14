import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/cluster_screen.dart';
import 'dart:io' show Platform;
import 'theme_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kDebugMode) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  _setupPlatformConfigurations();

  runApp(const ScooterClusterApp());
}

void _setupPlatformConfigurations() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    const windowSize = Size(480.0, 480.0);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChannels.platform.invokeMethod('Window.setSize', {
        'width': windowSize.width,
        'height': windowSize.height,
      });
      SystemChannels.platform.invokeMethod('Window.center');
    });
  }
}

class ScooterClusterApp extends StatefulWidget {
  const ScooterClusterApp({super.key});

  @override
  State<ScooterClusterApp> createState() => _ScooterClusterAppState();
}

class _ScooterClusterAppState extends State<ScooterClusterApp> {
  ThemeMode _currentTheme = ThemeMode.dark;

  void _updateTheme(ThemeMode newTheme) {
    print('Theme update called with: $newTheme');
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scooter Cluster',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: _currentTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox(
          width: 480,
          height: 480,
          child: ClusterScreen(
            onThemeSwitch: _updateTheme,
          ),
        ),
      ),
    );
  }
}
