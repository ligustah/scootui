import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../state/vehicle.dart';
import 'mdb_cubits.dart';

part 'menu_state.dart';
part 'menu_cubit.freezed.dart';

class MenuCubit extends Cubit<MenuState> {
  late final StreamSubscription<VehicleData> _sub;

  VehicleData _vehicleData = VehicleData();

  void showMenu() {
    if(state is MenuHidden && _vehicleData.state == ScooterState.parked) {
      emit(const MenuState.visible());
    }
  }

  void hideMenu() => emit(MenuState.hidden());

  void _onVehicleData(VehicleData event) {
    _vehicleData = event;

    // just emit a hidden state, cubit will deduplicate
    if(_vehicleData.state != ScooterState.parked) {
      emit(const MenuState.hidden());
    }
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }

  MenuCubit(Stream<VehicleData> stream) : super(const MenuState.hidden()) {
    _sub = stream.listen(_onVehicleData);
  }

  static MenuCubit create(BuildContext context) =>
      MenuCubit(context.read<VehicleSync>().stream);
}
