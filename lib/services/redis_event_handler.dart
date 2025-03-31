import 'package:flutter/material.dart';

class RedisEventHandler {
  final Function(ThemeMode)? onThemeSwitch;
  final Function(String)? onBatteryAlert;
  final Function(String?)? onBluetoothPinCodeEvent;
  final Function(double, double)? onLocationUpdate;

  bool _batteryAlertShown = false;

  RedisEventHandler({
    this.onThemeSwitch,
    this.onBatteryAlert,
    this.onBluetoothPinCodeEvent,
    this.onLocationUpdate,
  });

  void handleEvent(String key) {}

  void handleBrakeEvent(String brake, String state) {}

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
