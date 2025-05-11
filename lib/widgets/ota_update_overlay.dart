import 'package:flutter/material.dart';

import '../cubits/mdb_cubits.dart';
import '../state/vehicle.dart';

// Define possible OTA update states
enum OtaStatus {
  initializing,
  checkingUpdates,
  checkingUpdateError,
  deviceUpdated,
  waitingDashboard,
  downloadingUpdates,
  downloadingUpdateError,
  installingUpdates,
  installingUpdateError,
  installationCompleteWaitingDashboardReboot,
  installationCompleteWaitingReboot,
  unknown,
  none, // Add a 'none' state for when no update is in progress
}

// Helper function to map string status from MDB to OtaStatus enum
OtaStatus mapOtaStatus(String? status) {
  switch (status) {
    case 'initializing':
      return OtaStatus.initializing;
    case 'checking-updates':
      return OtaStatus.checkingUpdates;
    case 'checking-update-error':
      return OtaStatus.checkingUpdateError;
    case 'device-updated':
      return OtaStatus.deviceUpdated;
    case 'waiting-dashboard':
      return OtaStatus.waitingDashboard;
    case 'downloading-updates':
      return OtaStatus.downloadingUpdates;
    case 'downloading-update-error':
      return OtaStatus.downloadingUpdateError;
    case 'installing-updates':
      return OtaStatus.installingUpdates;
    case 'installing-update-error':
      return OtaStatus.installingUpdateError;
    case 'installation-complete-waiting-dashboard-reboot':
      return OtaStatus.installationCompleteWaitingDashboardReboot;
    case 'installation-complete-waiting-reboot':
      return OtaStatus.installationCompleteWaitingReboot;
    case 'unknown':
      return OtaStatus.unknown;
    default:
      return OtaStatus.none;
  }
}

// Helper function to get display text for OTA status
String getOtaStatusText(OtaStatus status) {
  switch (status) {
    case OtaStatus.initializing:
      return 'Initializing update...';
    case OtaStatus.checkingUpdates:
      return 'Checking for updates...';
    case OtaStatus.checkingUpdateError:
      return 'Update check failed.';
    case OtaStatus.deviceUpdated:
      return 'Device updated.';
    case OtaStatus.waitingDashboard:
      return 'Waiting for dashboard...';
    case OtaStatus.downloadingUpdates:
      return 'Downloading updates...';
    case OtaStatus.downloadingUpdateError:
      return 'Download failed.';
    case OtaStatus.installingUpdates:
      return 'Installing updates...';
    case OtaStatus.installingUpdateError:
      return 'Installation failed.';
    case OtaStatus.installationCompleteWaitingDashboardReboot:
      return 'Installation complete, waiting for dashboard reboot...';
    case OtaStatus.installationCompleteWaitingReboot:
      return 'Installation complete, waiting for reboot...';
    case OtaStatus.unknown:
    case OtaStatus.none:
      return ''; // Should not be displayed
  }
}

class OtaUpdateOverlay extends StatelessWidget {
  const OtaUpdateOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the vehicle state to determine scooter mode
    final vehicleState = VehicleSync.watch(context);
    final isReadyToDrive = vehicleState.state == ScooterState.readyToDrive;
    final isParked = vehicleState.state == ScooterState.parked;
    final isStandby = vehicleState.state == ScooterState.standBy;

    // Watch the OTA status from MDB data
    final otaData = OtaSync.watch(context);
    final otaStatusString = otaData.otaStatus;
    final otaStatus = mapOtaStatus(otaStatusString);

    // Check DBC-specific status field
    final dbcStatus = otaData.dbcStatus;

    // Check update type to see if this is a blocking update
    final isBlockingUpdate = otaData.updateType == 'blocking';

    // Check if the scooter is in a special state where we don't want to show OTA overlay
    final isSpecialState = vehicleState.state == ScooterState.booting ||
        vehicleState.state == ScooterState.shuttingDown ||
        vehicleState.state == ScooterState.hibernating ||
        vehicleState.state == ScooterState.hibernatingImminent ||
        vehicleState.state == ScooterState.suspending ||
        vehicleState.state == ScooterState.suspendingImminent;

    // Always hide the overlay if:
    // 1. OTA status is none or empty and there's no DBC update active
    // 2. The scooter is in a special state
    if ((otaStatus == OtaStatus.none || otaStatusString.trim().isEmpty) &&
        !isBlockingUpdate && (dbcStatus == null || dbcStatus.isEmpty) ||
        isSpecialState) {
      return Container(); // Don't show anything
    }

    // Determine if the overlay should be shown based on scooter mode and status
    bool showOverlay = false;

    if (isReadyToDrive) {
      // In ready-to-drive mode, show only for downloading, installing, and their errors
      // This shows a minimal overlay at the bottom
      showOverlay = otaStatus == OtaStatus.downloadingUpdates ||
          otaStatus == OtaStatus.downloadingUpdateError ||
          otaStatus == OtaStatus.installingUpdates ||
          otaStatus == OtaStatus.installingUpdateError ||
          dbcStatus == 'downloading' ||
          dbcStatus == 'installing';
    } else if (isParked) {
      // In parked mode (unlocked scooter), hide for specific statuses
      // Otherwise shows full overlay on top of the user's selected screen
      showOverlay = !(otaStatus == OtaStatus.unknown ||
          otaStatus == OtaStatus.initializing ||
          otaStatus == OtaStatus.checkingUpdates);
    } else {
      // In other modes (like standby/locked and off), show for all statuses except deviceUpdated
      // The MainScreen component will handle showing the black background in standby mode
      showOverlay = otaStatus != OtaStatus.deviceUpdated || isBlockingUpdate;
    }

    if (!showOverlay) {
      return Container(); // Don't show anything if overlay is not needed
    }

    // Determine the status text to display
    String statusText = getOtaStatusText(otaStatus);

    // Override with specific message for blocking updates in standby mode
    if (isBlockingUpdate && vehicleState.state == ScooterState.standBy) {
      statusText = 'Your scooter is locked. It will fully shut off after finishing the update installation.';
    }

    // Use DBC status if available
    if (dbcStatus != null && dbcStatus.isNotEmpty) {
      OtaStatus dbcOtaStatus = mapOtaStatus(dbcStatus);
      if (dbcOtaStatus != OtaStatus.none && dbcOtaStatus != OtaStatus.unknown) {
        statusText = getOtaStatusText(dbcOtaStatus);
      }
    }

    if (isReadyToDrive) {
      // Minimal overlay at the bottom for ready-to-drive mode
      return Positioned(
        bottom: 16, // Tiny bit of padding
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Tiny bit of padding
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7), // Semi-transparent background
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            child: Text(
              statusText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16, // Font size 16 or so
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      // Full-screen overlay with spinner for non-ready-to-drive modes
      return Container(
        color: isParked ? Colors.black.withOpacity(0.7) : Colors.black, // 70% opacity in parked, 100% otherwise
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                statusText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}
