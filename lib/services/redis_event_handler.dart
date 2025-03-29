import 'package:flutter/material.dart';
import '../models/vehicle_state.dart';

class RedisEventHandler {
  final VehicleState vehicleState;
  final Function(ThemeMode)? onThemeSwitch;
  final Function(String)? onBatteryAlert;
  final Function(String?)? onBluetoothPinCodeEvent;
  final Function(double, double)? onLocationUpdate;

  bool _batteryAlertShown = false;

  RedisEventHandler({
    required this.vehicleState,
    this.onThemeSwitch,
    this.onBatteryAlert,
    this.onBluetoothPinCodeEvent,
    this.onLocationUpdate,
  });

  void handleEvent(String key) {
    // print('Handling Redis event: $key');
    
    // Handle battery state changes
    if (key == 'location-update') {
      // Handle GPS location update
      if (vehicleState.hasGpsSignal && onLocationUpdate != null) {
        onLocationUpdate!(vehicleState.gpsLatitude, vehicleState.gpsLongitude);
      }
    }
  }

  void handleBrakeEvent(String brake, String state) {
    // print('Handling brake event: $brake = $state');
    
    // Update brake state
    vehicleState.updateFromRedis('engine-ecu', brake, 
      state == 'on' ? 'pressed' : 'released');
  }

  void handleBluetoothPinCodeEvent() {
    // Trigger the pin code callback to clear or update
    onBluetoothPinCodeEvent?.call(null);
  }

  // void _handleBatteryCriticalStates(
  //   int batteryNumber,
  //   String currentState,
  //   String currentTempState,
  //   double charge,
  //   String? lastState,
  //   String? lastTempState,
  // ) {
  //   if (!_batteryAlertShown) {
  //     // Check for fault state changes
  //     if (currentState == 'fault' && lastState != 'fault') {
  //       onBatteryAlert?.call('Battery ${batteryNumber + 1} fault detected!');
  //       _batteryAlertShown = true;
  //       return;
  //     }
  //
  //     // Check for high temperature state changes
  //     if (currentTempState == 'high' && lastTempState != 'high') {
  //       onBatteryAlert?.call('Battery ${batteryNumber + 1} temperature critical!');
  //       _batteryAlertShown = true;
  //       return;
  //     }
  //
  //     // Check for low charge
  //     if (charge <= 20 && (lastState == null || charge > 20)) {
  //       onBatteryAlert?.call('Battery ${batteryNumber + 1} charge critical!');
  //       _batteryAlertShown = true;
  //       return;
  //     }
  //   }
  // }
}