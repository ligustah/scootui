import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../cubits/mdb_cubits.dart';
import '../state/vehicle.dart';

part 'ota_cubit.freezed.dart';
part 'ota_state.dart';

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

class OtaCubit extends Cubit<OtaState> {
  final OtaSync _otaSync;
  final VehicleSync _vehicleSync;
  late StreamSubscription _otaSubscription;
  late StreamSubscription _vehicleSubscription;

  OtaCubit(this._otaSync, this._vehicleSync) : super(const OtaState.inactive()) {
    _initialize();
  }

  void _initialize() {
    // Subscribe to OTA status updates
    _otaSubscription = _otaSync.stream.listen((otaData) {
      _updateState(otaData.otaStatus);
    });

    // Subscribe to vehicle state updates
    _vehicleSubscription = _vehicleSync.stream.listen((vehicleData) {
      // Re-evaluate OTA state when vehicle state changes
      _updateState(_otaSync.state.otaStatus);
    });
  }

  void _updateState(String? otaStatusString) {
    final otaStatus = mapOtaStatus(otaStatusString);
    final vehicleState = _vehicleSync.state.state;
    final isReadyToDrive = vehicleState == ScooterState.readyToDrive;
    final isParked = vehicleState == ScooterState.parked;
    final isUpdating = vehicleState == ScooterState.updating;
    final isStandby = vehicleState == ScooterState.standBy;

    // Check the update-type to see if this is a blocking update (which keeps UI on during lock)
    final isBlockingUpdate = _otaSync.state.updateType == 'blocking';

    // Get DBC-specific status field which is populated by the update-service
    final dbcStatus = _otaSync.state.dbcStatus;
    final mdbStatus = _otaSync.state.mdbStatus;

    // Determine the status text to display
    String statusText = getOtaStatusText(otaStatus);

    // Show custom message for blocking updates that happen while locked
    if (isBlockingUpdate && isStandby) {
      statusText = 'Your scooter is locked. It will fully shut off after finishing the update installation.';
    }

    // If we have a specific DBC status, use it (takes precedence)
    if (dbcStatus.isNotEmpty) {
      OtaStatus dbcOtaStatus = mapOtaStatus(dbcStatus);
      if (dbcOtaStatus != OtaStatus.none && dbcOtaStatus != OtaStatus.unknown) {
        statusText = getOtaStatusText(dbcOtaStatus);
      }
    }

    // Check if the scooter is in a special state where we don't want to show OTA
    final isSpecialState = vehicleState == ScooterState.booting ||
        vehicleState == ScooterState.shuttingDown ||
        vehicleState == ScooterState.hibernating ||
        vehicleState == ScooterState.hibernatingImminent ||
        vehicleState == ScooterState.suspending ||
        vehicleState == ScooterState.suspendingImminent;

    // Always hide if OTA status is none/empty or in special states
    if ((otaStatus == OtaStatus.none || otaStatusString?.trim().isEmpty == true) &&
        !isBlockingUpdate &&
        !isSpecialState) {
      emit(const OtaState.inactive());
      return;
    }

    // If the vehicle is in updating state or we have a blocking update during lock, show the full screen OTA
    if (isUpdating || (isBlockingUpdate && isStandby)) {
      emit(OtaState.fullScreen(
        status: otaStatus,
        statusText: statusText,
        isParked: false, // Fully opaque background in updating mode
      ));
      return;
    }

    // Determine visibility and display mode based on scooter state and OTA status
    if (isReadyToDrive) {
      // In ready-to-drive mode, show minimal info for downloading, installing, and their errors
      final showMinimal = otaStatus == OtaStatus.downloadingUpdates ||
          otaStatus == OtaStatus.downloadingUpdateError ||
          otaStatus == OtaStatus.installingUpdates ||
          otaStatus == OtaStatus.installingUpdateError ||
          dbcStatus == "downloading" ||
          dbcStatus == "installing" ||
          mdbStatus == "downloading" ||
          mdbStatus == "installing";

      if (showMinimal) {
        emit(OtaState.minimal(status: otaStatus, statusText: statusText));
      } else {
        emit(const OtaState.inactive());
      }
    } else if (isParked) {
      // In parked mode, show full screen for most statuses
      final showFullScreen = !(otaStatus == OtaStatus.unknown ||
          otaStatus == OtaStatus.initializing ||
          otaStatus == OtaStatus.checkingUpdates);

      if (showFullScreen) {
        emit(OtaState.fullScreen(
          status: otaStatus,
          statusText: statusText,
          isParked: true, // Semi-transparent background in parked mode
        ));
      } else {
        emit(const OtaState.inactive());
      }
    } else {
      // In other modes (like standby/locked), show full screen for all statuses except deviceUpdated
      final showFullScreen = otaStatus != OtaStatus.deviceUpdated;

      if (showFullScreen) {
        emit(OtaState.fullScreen(
          status: otaStatus,
          statusText: statusText,
          isParked: false, // Fully opaque background in standby mode
        ));
      } else {
        emit(const OtaState.inactive());
      }
    }
  }

  static OtaCubit create(BuildContext context) {
    return OtaCubit(
      context.read<OtaSync>(),
      context.read<VehicleSync>(),
    );
  }

  @override
  Future<void> close() {
    _otaSubscription.cancel();
    _vehicleSubscription.cancel();
    return super.close();
  }
}
