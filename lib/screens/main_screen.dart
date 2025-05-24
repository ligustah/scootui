import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/debug_overlay_cubit.dart';
import '../cubits/mdb_cubits.dart';
import '../cubits/menu_cubit.dart';
import '../cubits/screen_cubit.dart';
import '../widgets/bluetooth_pin_code_overlay.dart';
import '../widgets/general/control_gestures_detector.dart';
import '../widgets/menu/menu_overlay.dart';
import '../widgets/shortcut_menu/shortcut_menu_overlay.dart';
import '../widgets/shutdown/shutdown_overlay.dart';
import '../widgets/version_overlay.dart';
import 'address_selection_screen.dart';
import 'cluster_screen.dart';
import 'debug_screen.dart';
import 'map_screen.dart';
import 'ota_background_screen.dart';
import 'ota_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current screen state
    final state = context.watch<ScreenCubit>().state;
    final menu = context.read<MenuCubit>(); // Changed from .watch to .read
    final debugMode = context.watch<DebugOverlayCubit>().state;

    Widget menuTrigger(Widget child) => ControlGestureDetector(
          stream: context.read<VehicleSync>().stream,
          onLeftDoubleTap: () => menu.showMenu(),
          child: child,
        );

    // If debug mode is set to full, show the debug screen regardless of current screen state
    if (debugMode == DebugMode.full) {
      return SizedBox(
        width: 480,
        height: 480,
        child: Stack(
          children: [
            const DebugScreen(),

            // Overlay essential components that should always be visible
            ShutdownOverlay(),
            BluetoothPinCodeOverlay(),
          ],
        ),
      );
    }

    return SizedBox(
      width: 480,
      height: 480,
      child: Stack(
        children: [
          switch (state) {
            // only map and cluster should trigger the menu
            ScreenMap() => menuTrigger(const MapScreen()),
            ScreenCluster() => menuTrigger(const ClusterScreen()),
            ScreenAddressSelection() => const AddressSelectionScreen(),
            ScreenOtaBackground() => const OtaBackgroundScreen(),
            ScreenOta() => const OtaScreen(),
            ScreenDebug() => const DebugScreen(),
          },

          // Menu overlay
          MenuOverlay(),

          // Shortcut menu overlay
          const ShortcutMenuOverlay(),

          // Shutdown animation overlay
          ShutdownOverlay(),

          // Bluetooth pin code overlay
          BluetoothPinCodeOverlay(),

          // Version information overlay (triggered by both brakes in parked state)
          VersionOverlay(),
        ],
      ),
    );
  }
}
