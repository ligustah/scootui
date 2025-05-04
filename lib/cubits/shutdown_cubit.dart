import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/engine.dart';
import '../state/vehicle.dart';
import 'mdb_cubits.dart';

enum ShutdownStatus {
  hidden,
  shuttingDown,
  suspending,
  hibernatingImminent,
  suspendingImminent
}

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
    // Map scooter state to shutdown status
    ShutdownStatus newStatus;

    switch (data.state) {
      case ScooterState.shuttingDown:
        newStatus = ShutdownStatus.shuttingDown;
        break;
      case ScooterState.suspending:
        newStatus = ShutdownStatus.suspending;
        break;
      case ScooterState.hibernatingImminent:
        newStatus = ShutdownStatus.hibernatingImminent;
        break;
      case ScooterState.suspendingImminent:
        newStatus = ShutdownStatus.suspendingImminent;
        break;
      default:
        newStatus = ShutdownStatus.hidden;
    }

    // Only emit if status changed
    if (state.status != newStatus) {
      emit(ShutdownState(status: newStatus));
    }
  }

  @override
  Future<void> close() async {
    await _engineSub.cancel();
    await _vehicleSub.cancel();
    return super.close();
  }

  static ShutdownState watch(BuildContext context) =>
      context.watch<ShutdownCubit>().state;

  static ShutdownCubit create(BuildContext context) => ShutdownCubit(
        engineStream: context.read<EngineSync>().stream,
        vehicleStream: context.read<VehicleSync>().stream,
      );
}
