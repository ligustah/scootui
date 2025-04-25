import 'dart:async'; // Import dart:async for StreamSubscription
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../repositories/mdb_repository.dart';
import '../services/settings_service.dart';

part 'screen_state.dart';
part 'screen_cubit.freezed.dart';

class ScreenCubit extends Cubit<ScreenState> {
  final SettingsService _settingsService;
  late StreamSubscription _settingsSubscription; // Add subscription

  ScreenCubit(this._settingsService) : super(_getInitialState(_settingsService.getScreenSetting())) {
    // Subscribe to settings updates
    _settingsSubscription = _settingsService.settingsStream.listen((settings) {
      final screenMode = _settingsService.getScreenSetting(); // Get updated screen mode
      emit(_getInitialState(screenMode)); // Emit new state based on updated mode
    });
  }

  static ScreenState _getInitialState(String mode) {
    switch (mode) {
      case 'navigation': // Map OEM 'navigation' to our 'map'
        return const ScreenState.map();
      case 'address_selection': // Keep our custom mode
        return const ScreenState.addressSelection();
      case 'speedometer': // Map OEM 'speedometer' to our 'cluster'
      default:
        return const ScreenState.cluster();
    }
  }

  void showCluster() {
    // No need to emit here, the stream listener will handle it
    _persistScreenMode('speedometer'); // Persist as OEM 'speedometer'
  }

  void showMap() {
    // No need to emit here, the stream listener will handle it
    _persistScreenMode('navigation'); // Persist as OEM 'navigation'
  }

  void showAddressSelection() {
    // No need to emit here, the stream listener will handle it
    _persistScreenMode('address_selection'); // Persist our custom mode
  }

  void _persistScreenMode(String mode) {
    _settingsService.updateScreenSetting(mode); // Use the provided mode string
  }

  static ScreenCubit create(BuildContext context) {
    final settingsService = context.read<SettingsService>();
    return ScreenCubit(settingsService);
  }

  @override
  Future<void> close() {
    _settingsSubscription.cancel(); // Cancel subscription on close
    return super.close();
  }
}
