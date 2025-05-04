import 'dart:async'; // Import dart:async for StreamSubscription

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../cubits/ota_cubit.dart';
import '../services/settings_service.dart';

part 'screen_cubit.freezed.dart';
part 'screen_state.dart';

class ScreenCubit extends Cubit<ScreenState> {
  final SettingsService _settingsService;
  final OtaCubit? _otaCubit;
  late StreamSubscription _settingsSubscription; // Add subscription
  StreamSubscription? _otaSubscription;

  ScreenCubit(this._settingsService, [this._otaCubit]) : super(_getInitialState(_settingsService.getScreenSetting())) {
    // Subscribe to settings updates
    _settingsSubscription = _settingsService.settingsStream.listen((settings) {
      final screenMode = _settingsService.getScreenSetting(); // Get updated screen mode
      emit(_getInitialState(screenMode)); // Emit new state based on updated mode
    });

    // Subscribe to OTA state updates if OtaCubit is provided
    if (_otaCubit != null) {
      _otaSubscription = _otaCubit!.stream.listen((otaState) {
        // When OTA enters full screen mode, switch to OTA screen
        if (otaState is OtaFullScreen) {
          emit(const ScreenState.ota());
        } else if (state is ScreenOta && otaState is! OtaFullScreen) {
          // When OTA exits full screen mode, switch back to cluster
          emit(const ScreenState.cluster());
        }
      });
    }
  }

  static ScreenState _getInitialState(String mode) {
    switch (mode) {
      case 'navigation': // Map OEM 'navigation' to our 'map'
        return const ScreenState.map();
      case 'address_selection': // Default to cluster if address_selection is persisted
        return const ScreenState.cluster();
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
    // Directly emit the state without persisting
    emit(const ScreenState.addressSelection());
    // Do not persist address_selection mode as it can cause hanging
  }

  void _persistScreenMode(String mode) {
    _settingsService.updateScreenSetting(mode); // Use the provided mode string
  }

  static ScreenCubit create(BuildContext context) {
    final settingsService = context.read<SettingsService>();
    final otaCubit = context.read<OtaCubit>();
    return ScreenCubit(settingsService, otaCubit);
  }

  @override
  Future<void> close() {
    _settingsSubscription.cancel(); // Cancel subscription on close
    _otaSubscription?.cancel(); // Cancel OTA subscription if it exists
    return super.close();
  }
}
