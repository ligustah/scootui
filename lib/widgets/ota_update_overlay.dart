import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/mdb_cubits.dart'; // Assuming OTA status comes from MDB
import '../state/vehicle.dart'; // Assuming scooter state comes from Vehicle state
import '../state/enums.dart'; // Assuming scooter state enum is here
import '../state/ota.dart'; // Import OtaData from its new location
import '../state/vehicle.dart'; // Import VehicleData

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
      return 'Unknown update status.';
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
    final isReadyToDrive = vehicleState.state == ScooterState.readyToDrive; // Corrected access

    // Watch the OTA status from MDB data
    final otaStatusString = OtaSync.watch(context).otaStatus;
    final otaStatus = mapOtaStatus(otaStatusString);

    // Determine if the overlay should be shown based on scooter mode and status
    bool showOverlay = false;
    final isParked = vehicleState.state == ScooterState.parked;

    if (isReadyToDrive) {
      // In ready-to-drive mode, show only for downloading, installing, and their errors
      showOverlay = otaStatus == OtaStatus.downloadingUpdates ||
          otaStatus == OtaStatus.downloadingUpdateError ||
          otaStatus == OtaStatus.installingUpdates ||
          otaStatus == OtaStatus.installingUpdateError;
    } else if (isParked) {
      // In parked mode, hide for specific statuses
      showOverlay = !(otaStatus == OtaStatus.unknown ||
          otaStatus == OtaStatus.initializing ||
          otaStatus == OtaStatus.checkingUpdates);
    } else {
      // In other non-ready-to-drive modes (like standby and off), show for all statuses except deviceUpdated and none
      showOverlay = otaStatus != OtaStatus.deviceUpdated && otaStatus != OtaStatus.none;
    }

    if (!showOverlay) {
      return Container(); // Don't show anything if overlay is not needed
    }

    final statusText = getOtaStatusText(otaStatus);

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
      // Full-screen overlay with spinner for standby mode
      return Container(
        color: Colors.black.withOpacity(0.8), // Dark semi-transparent background
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
