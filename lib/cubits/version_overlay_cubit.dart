import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/mdb_repository.dart';
import '../state/enums.dart';
import '../state/vehicle.dart';

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
    _buttonEventsSubscription =
        _mdbRepository.subscribe("buttons").listen(_handleButtonEvent);
  }

  static VersionOverlayCubit create(BuildContext context) {
    return VersionOverlayCubit(
      mdbRepository: context.read<MDBRepository>(),
    );
  }

  void _handleButtonEvent((String channel, String message) event) {
    // Parse the button event (format: "button:state")
    final parts = event.$2.split(':');
    if (parts.length < 2) return;

    final button = parts[0];
    final state = parts[1];

    // Only interested in brake events
    if (button.startsWith('brake:') && parts.length >= 3) {
      final brakePosition = parts[1]; // "left" or "right"
      final brakeState = parts[2]; // "on" or "off"

      // Update the corresponding brake state
      if (brakePosition == 'left') {
        _leftBrakePressed = brakeState == 'on';
      } else if (brakePosition == 'right') {
        _rightBrakePressed = brakeState == 'on';
      }

      // Check if we should start or stop the timer
      if (_leftBrakePressed && _rightBrakePressed && _inParkedState) {
        // Both brakes pressed in parked state, start timer
        if (_brakeHoldStartTime == null) {
          _brakeHoldStartTime = DateTime.now();
          _startBrakeHoldTimer();
        }
      } else {
        // Conditions not met, reset timer
        _resetBrakeHold();
      }
    }
  }


  // We maintain brake state from both real-time events and regular vehicle data
  bool _leftBrakePressed = false;
  bool _rightBrakePressed = false;
  bool _inParkedState = false;

  void updateBrakeState(Toggle leftBrake, Toggle rightBrake, ScooterState scooterState) {
    // Store the current state for use with real-time button events
    _leftBrakePressed = leftBrake == Toggle.on;
    _rightBrakePressed = rightBrake == Toggle.on;
    _inParkedState = scooterState == ScooterState.parked;

    // Only track brake holds when in parked state
    if (!_inParkedState) {
      _resetBrakeHold();
      return;
    }

    // Check if both brakes are pressed
    if (_leftBrakePressed && _rightBrakePressed) {
      // Start timer if not already started
      if (_brakeHoldStartTime == null) {
        _brakeHoldStartTime = DateTime.now();
        _startBrakeHoldTimer();
      }
    } else {
      // Reset if either brake is released
      _resetBrakeHold();
    }
  }

  void _startBrakeHoldTimer() {
    _brakeHoldTimer?.cancel();
    _brakeHoldTimer = Timer(_brakeHoldDuration, () {
      // Show version overlay when timer completes
      emit(true);
    });
  }

  void _resetBrakeHold() {
    _brakeHoldStartTime = null;
    _brakeHoldTimer?.cancel();
    _brakeHoldTimer = null;
  }

  void hideOverlay() {
    emit(false);
  }

  @override
  Future<void> close() {
    _brakeHoldTimer?.cancel();
    _buttonEventsSubscription?.cancel();
    return super.close();
  }
}
