import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/map_cubit.dart';
import 'cubits/mdb_cubits.dart';
import 'cubits/menu_cubit.dart';
import 'cubits/screen_cubit.dart';
import 'cubits/system_cubit.dart';
import 'cubits/trip_cubit.dart';
import 'repositories/redis_repository.dart';
import 'screens/main_screen.dart';
import 'screens/map_screen.dart';
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

  static String getRedisHost() {
    if (Platform.isMacOS || Platform.isWindows) {
      return '127.0.0.1'; // Local development
    }
    return '192.168.7.1'; // Target system
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => RedisRepository(host: getRedisHost(), port: 6379),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: EngineSync.create),
          BlocProvider(create: VehicleSync.create),
          BlocProvider(create: Battery1Sync.create),
          BlocProvider(create: Battery2Sync.create),
          BlocProvider(create: BluetoothSync.create),
          BlocProvider(create: GpsSync.create),
          BlocProvider(create: SystemCubit.create),
          BlocProvider(create: TripCubit.create),
          BlocProvider(create: MapCubit.create),
          BlocProvider(create: ScreenCubit.create),
          BlocProvider(create: MenuCubit.create),
        ],
        child: MaterialApp(
          title: 'Scooter Cluster',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: _currentTheme,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: MainScreen(),
          ),
        ),
      ),
    );
  }
}
