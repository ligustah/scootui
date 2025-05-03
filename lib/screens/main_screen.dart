import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/mdb_cubits.dart';
import '../cubits/menu_cubit.dart';
import '../cubits/screen_cubit.dart';
import '../state/ota.dart';
import '../state/vehicle.dart';
import '../state/enums.dart';
import '../widgets/bluetooth_pin_code_overlay.dart';
import '../widgets/general/control_gestures_detector.dart';
import '../widgets/menu/menu_overlay.dart';
import '../widgets/ota_update_overlay.dart';
import '../widgets/shutdown/shutdown_overlay.dart';
import 'address_selection_screen.dart';
import 'cluster_screen.dart';
import 'map_screen.dart';
import 'ota_background_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the vehicle state to determine scooter mode
    final vehicleState = VehicleSync.watch(context);
    final isReadyToDrive = vehicleState.state == ScooterState.readyToDrive;
    final isParked = vehicleState.state == ScooterState.parked;
    final isStandby = vehicleState.state == ScooterState.standBy;

    // Watch the OTA status
    final otaStatusString = OtaSync.watch(context).otaStatus;
    final otaActive = otaStatusString != null &&
        otaStatusString.trim().isNotEmpty &&
        otaStatusString != "none" &&
        otaStatusString != "unknown";

    // Get the current screen state
    final state = context.watch<ScreenCubit>().state;
    final screenCubit = context.read<ScreenCubit>();
    final menu = context.watch<MenuCubit>();

    // Check if the scooter is in a special state where we don't want to show OTA overlay
    final isSpecialState = vehicleState.state == ScooterState.booting ||
        vehicleState.state == ScooterState.shuttingDown ||
        vehicleState.state == ScooterState.hibernating ||
        vehicleState.state == ScooterState.hibernatingImminent ||
        vehicleState.state == ScooterState.suspending ||
        vehicleState.state == ScooterState.suspendingImminent;

    // If OTA is active and scooter is in standby mode (locked), use black background
    // The OtaUpdateOverlay will still be shown on top of this
    if (otaActive && isStandby) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state is! ScreenOtaBackground) {
          screenCubit.emit(const ScreenState.otaBackground());
        }
      });
    } else if (state is ScreenOtaBackground && (!otaActive || !isStandby)) {
      // Switch back to cluster when conditions no longer require OTA background
      WidgetsBinding.instance.addPostFrameCallback((_) {
        screenCubit.emit(const ScreenState.cluster());
      });
    }

    Widget menuTrigger(Widget child) => ControlGestureDetector(
          stream: context.read<VehicleSync>().stream,
          onLeftDoubleTap: () => menu.showMenu(),
          child: child,
        );

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
          },

          // Menu overlay
          MenuOverlay(),

          // Shutdown animation overlay
          ShutdownOverlay(),

          // Bluetooth pin code overlay
          BluetoothPinCodeOverlay(),

          // OTA update overlay
          OtaUpdateOverlay(),
        ],
      ),
    );
  }
}
