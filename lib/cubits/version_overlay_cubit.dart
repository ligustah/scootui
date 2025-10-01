import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/mdb_repository.dart';
import '../state/enums.dart';
import '../state/vehicle.dart';
import 'mdb_cubits.dart';

class VersionOverlayCubit extends Cubit<bool> {
  Timer? _brakeHoldTimer;
  DateTime? _brakeHoldStartTime;
  final MDBRepository _mdbRepository;
  StreamSubscription<(String, String)>? _buttonEventsSubscription;

  static const _brakeHoldDuration = Duration(seconds: 3);

  VersionOverlayCubit({required MDBRepository mdbRepository})
      : _mdbRepository = mdbRepository,
        super(false) {
    // Subscribe to direct button events channel for more responsive UI
    _buttonEventsSubscription = _mdbRepository.subscribe("buttons").listen(
      _handleButtonEvent,
      onError: (e) {
        print('VERSION_OVERLAY: Error in button subscription: $e');
      },
      cancelOnError: false,
    );
  }

  static VersionOverlayCubit create(BuildContext context) {
    // Get VehicleSync instance
    final vehicleSync = context.read<VehicleSync>();

    // Create and setup the cubit
    final cubit = VersionOverlayCubit(
      mdbRepository: context.read<MDBRepository>(),
    );

    // Immediately initialize with current state
    final currentState = vehicleSync.state;
    cubit._inParkedState = currentState.state == ScooterState.parked;
    cubit._leftBrakePressed = currentState.brakeLeft == Toggle.on;
    cubit._rightBrakePressed = currentState.brakeRight == Toggle.on;

    print(
        'VERSION_OVERLAY: Initial state - left: ${cubit._leftBrakePressed}, right: ${cubit._rightBrakePressed}, parked: ${cubit._inParkedState}');

    // Update brake state whenever vehicle data changes
    vehicleSync.stream.listen((vehicleData) {
      cubit.updateBrakeState(
        vehicleData.brakeLeft,
        vehicleData.brakeRight,
        vehicleData.state,
      );
    });

    return cubit;
  }

  void _handleButtonEvent((String channel, String message) event) {
    final buttonEvent = event.$2;
    print('VERSION_OVERLAY: Received button event: $buttonEvent');

    // Parse the button event
    final parts = buttonEvent.split(':');
    if (parts.length < 2) return;

    // Log all button events
    print('VERSION_OVERLAY: Event parts: ${parts.join('|')}');

    // Special handling for brake events - format: brake:left/right:on/off
    if (parts[0] == 'brake' && parts.length >= 3) {
      final brakePosition = parts[1]; // "left" or "right"
      final brakeState = parts[2]; // "on" or "off"

      print('VERSION_OVERLAY: Brake event - $brakePosition: $brakeState');

      // Update the corresponding brake state
      if (brakePosition == 'left') {
        _leftBrakePressed = brakeState == 'on';
        print('VERSION_OVERLAY: Left brake state updated: $_leftBrakePressed');
      } else if (brakePosition == 'right') {
        _rightBrakePressed = brakeState == 'on';
        print('VERSION_OVERLAY: Right brake state updated: $_rightBrakePressed');
      }

      // Check current overall state for debugging
      print(
          'VERSION_OVERLAY: After update - left: $_leftBrakePressed, right: $_rightBrakePressed, parked: $_inParkedState');

      // Check if we should start or stop the timer
      if (_leftBrakePressed && _rightBrakePressed && _inParkedState) {
        // Both brakes pressed in parked state, start timer
        if (_brakeHoldStartTime == null) {
          _brakeHoldStartTime = DateTime.now();
          print('VERSION_OVERLAY: Both brakes held in PARKED state, starting timer');
          _startBrakeHoldTimer();
        } else {
          print('VERSION_OVERLAY: Timer already running');
        }
      } else {
        // Conditions not met, reset timer
        if (_brakeHoldStartTime != null) {
          print(
              'VERSION_OVERLAY: Conditions no longer met, canceling timer - left: $_leftBrakePressed, right: $_rightBrakePressed, parked: $_inParkedState');
        }
        _resetBrakeHold();
      }
    }
  }

  // We maintain brake state from both real-time events and regular vehicle data
  bool _leftBrakePressed = false;
  bool _rightBrakePressed = false;
  bool _inParkedState = false;

  void updateBrakeState(Toggle leftBrake, Toggle rightBrake, ScooterState scooterState) {
    // Check if anything has changed
    bool leftChanged = _leftBrakePressed != (leftBrake == Toggle.on);
    bool rightChanged = _rightBrakePressed != (rightBrake == Toggle.on);
    bool stateChanged = _inParkedState != (scooterState == ScooterState.parked);

    // Update internal state
    _leftBrakePressed = leftBrake == Toggle.on;
    _rightBrakePressed = rightBrake == Toggle.on;
    _inParkedState = scooterState == ScooterState.parked;

    // If state changed, update the timer state
    if (leftChanged || rightChanged || stateChanged) {
      _updateOverlayState();
    }
  }

  // Centralized helper to manage the timer based on brake and vehicle state
  void _updateOverlayState() {
    // Only track brake holds when in parked state
    if (!_inParkedState) {
      if (_brakeHoldStartTime != null) {
        print('VERSION_OVERLAY: Not in PARKED state, canceling timer');
        _resetBrakeHold();
      }
      return;
    }

    // Check if both brakes are pressed
    if (_leftBrakePressed && _rightBrakePressed) {
      // Start timer if not already started
      if (_brakeHoldStartTime == null) {
        _brakeHoldStartTime = DateTime.now();
        print('VERSION_OVERLAY: Both brakes pressed, starting timer');
        _startBrakeHoldTimer();
      }
    } else {
      // Reset if either brake is released
      if (_brakeHoldStartTime != null) {
        print('VERSION_OVERLAY: At least one brake released, canceling timer');
        _resetBrakeHold();
      }
    }
  }

  void _startBrakeHoldTimer() {
    _brakeHoldTimer?.cancel();
    print('VERSION_OVERLAY: Starting brake hold timer for ${_brakeHoldDuration.inSeconds} seconds');
    _brakeHoldTimer = Timer(_brakeHoldDuration, () {
      // Show version overlay when timer completes
      print('VERSION_OVERLAY: Timer completed, showing version overlay!');
      emit(true);
    });
  }

  void _resetBrakeHold() {
    _brakeHoldStartTime = null;
    _brakeHoldTimer?.cancel();
    _brakeHoldTimer = null;

    // Also hide the overlay if it's currently visible
    if (state) {
      print('VERSION_OVERLAY: Brakes released, hiding overlay');
      emit(false);
    }
  }

  void hideOverlay() {
    print('VERSION_OVERLAY: Hiding overlay');
    emit(false);
  }

  @override
  Future<void> close() {
    _brakeHoldTimer?.cancel();
    _buttonEventsSubscription?.cancel();
    return super.close();
  }
}
