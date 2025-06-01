import 'package:flutter/material.dart';

import '../../cubits/shutdown_cubit.dart';
import '../../cubits/mdb_cubits.dart';
import '../../state/vehicle.dart';
import '../../state/ota.dart';
import 'shutdown_animation.dart';

class ShutdownOverlay extends StatelessWidget {
  const ShutdownOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final shutdownState = ShutdownCubit.watch(context);
    final vehicleState = VehicleSync.watch(context);
    final otaData = OtaSync.watch(context);

    // Check if OTA update is ongoing (DBC status takes priority)
    final dbcStatus = otaData.dbcStatus;
    final isOtaOngoing = dbcStatus == 'downloading' || dbcStatus == 'installing';

    // Check if we're shutting down
    final isShuttingDown = shutdownState.isVisible;

    // Priority logic:
    // 1. If OTA is ongoing AND we're shutting down -> show combined OTA shutdown overlay
    // 2. If OTA is ongoing but NOT shutting down -> show OTA overlay (for locked scooter)
    // 3. If shutting down but no OTA -> show normal shutdown overlay
    // 4. Otherwise -> show nothing

    if (isOtaOngoing && isShuttingDown) {
      return _buildCombinedOtaShutdownOverlay(context, vehicleState, otaData, shutdownState.status);
    } else if (isOtaOngoing) {
      return _buildOtaOverlay(context, vehicleState, otaData);
    } else if (isShuttingDown) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: ShutdownContent(status: shutdownState.status),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildOtaOverlay(BuildContext context, VehicleData vehicleState, OtaData otaData) {
    final dbcStatus = otaData.dbcStatus;
    final updateVersion = otaData.dbcUpdateVersion;
    final isUnlocked = vehicleState.state == ScooterState.readyToDrive || vehicleState.state == ScooterState.parked;
    final isLocked = vehicleState.state == ScooterState.standBy;

    // Status bar icon for unlocked scooter (handled by OtaStatusIndicator in top status bar)
    if (isUnlocked) {
      return const SizedBox.shrink();
    }

    // Full message for locked scooter
    if (isLocked) {
      final actionText = dbcStatus == 'downloading' ? 'Downloading' : 'Installing';
      final versionText = updateVersion.isNotEmpty ? ' $updateVersion' : '';

      return Container(
        color: Colors.black, // Full black background for stand-by state
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spinner
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3.0,
                  ),
                ),
                const SizedBox(height: 10),
                // Text
                Text(
                  '$actionText update$versionText.\nYour scooter will turn off when done.\nYou can unlock it again at any point.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCombinedOtaShutdownOverlay(
      BuildContext context, VehicleData vehicleState, OtaData otaData, ShutdownStatus shutdownStatus) {
    final dbcStatus = otaData.dbcStatus;
    final updateVersion = otaData.dbcUpdateVersion;
    final actionText = dbcStatus == 'downloading' ? 'Downloading' : 'Installing';
    final versionText = updateVersion.isNotEmpty ? ' $updateVersion' : '';
    
    // Use full black background when in stand-by, translucent when shutting down
    final isStandBy = vehicleState.state == ScooterState.standBy;
    final backgroundColor = isStandBy ? Colors.black : Colors.black.withOpacity(0.8);

    return Container(
      color: backgroundColor,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spinner
              const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3.0,
                ),
              ),
              const SizedBox(height: 10),
              // Text
              Text(
                '$actionText update$versionText.\nYour scooter will turn off when done.\nYou can unlock it again at any point.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
