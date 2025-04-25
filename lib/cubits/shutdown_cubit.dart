import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/engine.dart';
import '../state/enums.dart';
import '../state/vehicle.dart';
import 'mdb_cubits.dart';

enum ShutdownStatus { hidden, visible }

class ShutdownState {
  final ShutdownStatus status;

  const ShutdownState({required this.status});

  bool get isVisible => status != ShutdownStatus.hidden;
}

class ShutdownCubit extends Cubit<ShutdownState> {
  late final StreamSubscription<EngineData> _engineSub;
  late final StreamSubscription<VehicleData> _vehicleSub;

  ShutdownCubit({
    required Stream<EngineData> engineStream,
    required Stream<VehicleData> vehicleStream,
  }) : super(const ShutdownState(status: ShutdownStatus.hidden)) {
    _vehicleSub = vehicleStream.listen(_onVehicleData);
  }

  void _onVehicleData(VehicleData data) {
    // Detect scooter state change to standBy or off
    if (data.state == ScooterState.standBy || data.state == ScooterState.off) {
      if (state.status == ShutdownStatus.hidden) {
        _startShutdownAnimation();
      }
    } else {
      // If state changes away from standBy or off, hide animation
      if (state.status != ShutdownStatus.hidden) {
        emit(const ShutdownState(status: ShutdownStatus.hidden));
      }
    }
  }

  void _startShutdownAnimation() {
    emit(const ShutdownState(status: ShutdownStatus.visible));
  }

  @override
  Future<void> close() async {
    await _engineSub.cancel();
    await _vehicleSub.cancel();
    return super.close();
  }

  static ShutdownState watch(BuildContext context) => context.watch<ShutdownCubit>().state;

  static ShutdownCubit create(BuildContext context) => ShutdownCubit(
        engineStream: context.read<EngineSync>().stream,
        vehicleStream: context.read<VehicleSync>().stream,
      );
}
