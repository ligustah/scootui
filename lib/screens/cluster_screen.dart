import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../cubits/debug_overlay_cubit.dart';
import '../cubits/mdb_cubits.dart';
import '../cubits/theme_cubit.dart';
import '../cubits/trip_cubit.dart';
import '../widgets/debug/debug_overlay.dart';
import '../widgets/ota_info_widget.dart';
import '../widgets/general/odometer_display.dart';
import '../widgets/indicators/warning_indicators.dart';
import '../widgets/power/power_display.dart';
import '../widgets/speedometer/speedometer_display.dart';
import '../widgets/status_bars/top_status_bar.dart';

enum ViewMode {
  dashboard,
  map,
}

class ClusterScreen extends StatefulWidget {
  final Function(ThemeMode)? onThemeSwitch;
  final Function()? onResetTrip;

  const ClusterScreen({
    super.key,
    this.onThemeSwitch,
    this.onResetTrip,
  });

  @override
  State<ClusterScreen> createState() => _ClusterScreenState();
}

class _ClusterScreenState extends State<ClusterScreen> {
  String? _errorMessage;

  // Track previous odometer values for animation
  double _previousTrip = 0.0;
  double _previousTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _printDocumentsDirectory();
  }

  Future<void> _printDocumentsDirectory() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      print('ClusterScreen - Application Documents Directory: ${appDir.path}');
      final mapPath = '${appDir.path}/maps/map.mbtiles';
      print('ClusterScreen - MBTiles path: $mapPath');
    } catch (e) {
      print('ClusterScreen - Error getting documents directory: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeState(:theme, :isDark) = ThemeCubit.watch(context);

    final (odometer, powerOutput) = EngineSync.select(context, (data) => (data.odometer, data.powerOutput));
    final trip = TripCubit.watch(context);

    // Store current odometer values before update
    final currentTrip = trip.distanceTravelled / 1000;
    final currentTotal = odometer / 1000;

    // Update previous values for next animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _previousTrip = currentTrip;
      _previousTotal = currentTotal;
    });

    return Container(
      width: 480,
      height: 480,
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          Column(
            children: [
              // Status bar at top
              StatusBar(),

              // Warning indicators
              WarningIndicators(),

              // Main speedometer area
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Speedometer
                    SpeedometerDisplay(),

                    // Power display at bottom of speedometer area
                    Positioned(
                      bottom: 10,
                      left: 40,
                      right: 40,
                      child: PowerDisplay(
                        powerOutput: powerOutput / 1000,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom area with trip/total distance
              Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDark ? Colors.white10 : Colors.black12,
                      width: 1,
                    ),
                  ),
                ),
                child: AnimatedOdometerDisplay(
                  previousTrip: _previousTrip,
                  previousTotal: _previousTotal,
                  totalDistance: currentTotal,
                  tripDistance: currentTrip,
                ),
              ),
            ],
          ),

          // Error message overlay
          if (_errorMessage != null)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.red.withOpacity(0.8),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // OTA info widget (will only show when in minimal mode)
          const OtaInfoWidget(),

          // Debug overlay - controlled by DebugOverlayCubit
          BlocBuilder<DebugOverlayCubit, DebugMode>(
            builder: (context, debugMode) {
              // Only show overlay if mode is set to overlay
              if (debugMode == DebugMode.overlay) {
                return const DebugOverlay();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
