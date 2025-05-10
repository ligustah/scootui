import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/mdb_repository.dart';
import '../state/enums.dart';
import '../state/vehicle.dart';

class VersionOverlayCubit extends Cubit<bool> {
  Timer? _brakeHoldTimer;
  DateTime? _brakeHoldStartTime;

  static const _brakeHoldDuration = Duration(seconds: 3);

  VersionOverlayCubit({MDBRepository? mdbRepository}) : super(false);

  static VersionOverlayCubit create(BuildContext context) {
    return VersionOverlayCubit(
      mdbRepository: context.read<MDBRepository>(),
    );
  }

  void updateBrakeState(Toggle leftBrake, Toggle rightBrake, ScooterState scooterState) {
    final bool leftPressed = leftBrake == Toggle.on;
    final bool rightPressed = rightBrake == Toggle.on;
    final bool inParkedState = scooterState == ScooterState.parked;

    // Only track brake holds when in parked state
    if (!inParkedState) {
      _resetBrakeHold();
      return;
    }

    // Check if both brakes are pressed
    if (leftPressed && rightPressed) {
      // Start timer if not already started
      if (_brakeHoldStartTime == null) {
        _brakeHoldStartTime = DateTime.now();
        _startBrakeHoldTimer();
      }
    } else {
      // Reset if either brake is released
      _resetBrakeHold();
    }

    // Update brake state
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
    return super.close();
  }
}
