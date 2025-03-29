import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../cubits/mdb_cubits.dart';
import '../cubits/trip_cubit.dart';
import '../models/vehicle_state.dart';
import '../services/menu_manager.dart';
import '../services/redis_service.dart';
import '../widgets/general/odometer_display.dart';
import '../widgets/general/warning_indicators.dart';
import '../widgets/menu/menu_overlay.dart';
import '../widgets/power/power_display.dart';
import '../widgets/speedometer/speedometer_display.dart';
import '../widgets/status_bars/top_status_bar.dart';
import 'map_screen.dart';

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
  final VehicleState _vehicleState = VehicleState();
  late RedisService _redis;
  late MenuManager _menuManager;
  late Timer _clockTimer;
  String _currentTime = '';
  String? _errorMessage;
  Timer? _reconnectTimer;
  String? _bluetoothPinCode;
  ViewMode _currentView = ViewMode.dashboard;

  // Track previous odometer values for animation
  double _previousTrip = 0.0;
  double _previousTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _setupRedis();
    _startClock();
    _updateTime();
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

  void _setupRedis() {
    _redis = RedisService(
      '', // Host is determined by platform
      6379, // Default Redis port
      _vehicleState,
      onThemeSwitch: widget.onThemeSwitch,
      onBluetoothPinCodeEvent: (pinCode) {
        setState(() {
          _bluetoothPinCode = pinCode;
        });
      },
      onBrakeEvent: (brake, state) {
        if (state == 'on') {
          if (brake == 'brake:left') {
            _menuManager.handleLeftBrake(_vehicleState.isParked, state);
          } else if (brake == 'brake:right') {
            _menuManager.handleRightBrake();
          }
        }
      },
    );
    _menuManager = MenuManager(
      widget.onThemeSwitch ?? (_) {},
      _vehicleState,
      _redis,
      widget.onResetTrip ?? () {},
    );
    _menuManager.onMapViewToggled = (showMap) {
      setState(() {
        _currentView = showMap ? ViewMode.map : ViewMode.dashboard;
      });
    };
    _connectToRedis();
  }

  Future<void> _connectToRedis() async {
    try {
      await _redis.connect();
      setState(() {
        _errorMessage = null;
      });
      _reconnectTimer?.cancel();
    } catch (e) {
      debugPrint('Failed to connect to Redis: $e');
      setState(() {
        _errorMessage = 'Connection to MDB failed';
      });
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(const Duration(seconds: 5), () {
        _connectToRedis();
      });
    }
  }

  void _startClock() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm').format(DateTime.now());
    });
  }

  void _switchView(ViewMode newView) {
    setState(() {
      _currentView = newView;
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _reconnectTimer?.cancel();
    _redis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final engineState = EngineSync.watch(context);
    final trip = TripCubit.watch(context);

    // Store current odometer values before update
    final currentTrip = trip.distanceTravelled / 1000;
    final currentTotal = engineState.odometer / 1000;

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
          // Main content layout
          if (_currentView == ViewMode.dashboard)
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
                        bottom: 20,
                        left: 40,
                        right: 40,
                        child: PowerDisplay(
                          powerOutput: engineState.powerOutput / 1000,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom area with trip/total distance
                Container(
                  height: 80,
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
            )
          else
            MapScreen(
              vehicleState: _vehicleState,
              currentTime: _currentTime,
            ),

          // Error message overlay
          if (_errorMessage != null)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

          // Bluetooth pin code notification
          if (_bluetoothPinCode != null)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.blue.withOpacity(0.8),
                child: Text(
                  'Bluetooth Pin Code: $_bluetoothPinCode',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Menu overlay
          ListenableBuilder(
            listenable: _menuManager,
            builder: (context, child) {
              return MenuOverlay(
                vehicleState: _vehicleState,
                isVisible: _menuManager.isMenuVisible,
                menuItems: _menuManager.menuItems,
                selectedIndex: _menuManager.selectedIndex,
                isInSubmenu: _menuManager.isInSubmenu,
                onThemeChanged: (mode) {
                  widget.onThemeSwitch?.call(mode);
                  _menuManager.updateThemeMode(mode);
                },
                onClose: () => _menuManager.closeMenu(),
              );
            },
          ),
        ],
      ),
    );
  }
}
