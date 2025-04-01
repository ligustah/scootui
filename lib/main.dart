import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/all.dart';
import 'cubits/theme_cubit.dart';
import 'repositories/redis_repository.dart';
import 'screens/main_screen.dart';

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

class ScooterClusterApp extends StatelessWidget {
  const ScooterClusterApp({super.key});

  static String getRedisHost() {
    if (Platform.isMacOS || Platform.isWindows) {
      return '127.0.0.1'; // Local development
    }
    return '192.168.7.1'; // Target system
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          RedisRepository(host: getRedisHost(), port: 6379)..dashboardReady(),
      child: MultiBlocProvider(
        providers: allCubits,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Scooter Cluster',
              theme: state.lightTheme,
              darkTheme: state.darkTheme,
              themeMode: state.themeMode,
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: MainScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
