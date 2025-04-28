import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/all.dart';
import 'cubits/theme_cubit.dart';
import 'env_config.dart';
import 'repositories/all.dart';
import 'repositories/mdb_repository.dart';
import 'screens/simulator_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration
  EnvConfig.initialize();

  _setupPlatformConfigurations();

  runApp(const SimulatorApp());
}

void _setupPlatformConfigurations() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    const windowSize = Size(800.0, 600.0);
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

class SimulatorApp extends StatelessWidget {
  const SimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: allRepositories,
      child: MultiBlocProvider(
        providers: allCubits,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Cluster Simulator',
              theme: state.lightTheme,
              darkTheme: state.darkTheme,
              themeMode: state.themeMode,
              debugShowCheckedModeBanner: false,
              home: Builder(
                builder: (context) => SimulatorScreen(
                  repository: context.read<MDBRepository>(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
