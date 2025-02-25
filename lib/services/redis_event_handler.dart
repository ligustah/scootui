import 'package:flutter/material.dart';
import '../models/vehicle_state.dart';

class RedisEventHandler {
  final VehicleState vehicleState;
  final Function(ThemeMode)? onThemeSwitch;
  final Function(String)? onBatteryAlert;
  final Function(String?)? onBluetoothPinCodeEvent;
  final Function(double, double)? onLocationUpdate;

  // Battery state tracking
  String? _lastBattery0State;
  String? _lastBattery0TempState;
  String? _lastBattery1State;
  String? _lastBattery1TempState;
  bool _batteryAlertShown = false;

  RedisEventHandler({
    required this.vehicleState,
    this.onThemeSwitch,
    this.onBatteryAlert,
    this.onBluetoothPinCodeEvent,
    this.onLocationUpdate,
  });

  void handleEvent(String key) {
    print('Handling Redis event: $key');
    
    // Handle battery state changes
    if (key.startsWith('battery:')) {
      _handleBatteryStateChange();
    } else if (key == 'location-update') {
      // Handle GPS location update
      if (vehicleState.hasGpsSignal && onLocationUpdate != null) {
        onLocationUpdate!(vehicleState.gpsLatitude, vehicleState.gpsLongitude);
      }
    }
  }

  void handleBrakeEvent(String brake, String state) {
    print('Handling brake event: $brake = $state');
    
    // Update brake state
    vehicleState.updateFromRedis('engine-ecu', brake, 
      state == 'on' ? 'pressed' : 'released');
  }

  void handleBluetoothPinCodeEvent() {
    // Trigger the pin code callback to clear or update
    onBluetoothPinCodeEvent?.call(null);
  }

  void _handleBatteryStateChange() {
    // Check for critical battery states
    if (vehicleState.battery0Present) {
      _handleBatteryCriticalStates(
        0,
        vehicleState.battery0State,
        vehicleState.battery0TempState,
        vehicleState.battery0Charge,
        _lastBattery0State,
        _lastBattery0TempState,
      );
      _lastBattery0State = vehicleState.battery0State;
      _lastBattery0TempState = vehicleState.battery0TempState;
    }

    if (vehicleState.battery1Present) {
      _handleBatteryCriticalStates(
        1,
        vehicleState.battery1State,
        vehicleState.battery1TempState,
        vehicleState.battery1Charge,
        _lastBattery1State,
        _lastBattery1TempState,
      );
      _lastBattery1State = vehicleState.battery1State;
      _lastBattery1TempState = vehicleState.battery1TempState;
    }

    // Reset alert flag if batteries are in good state
    if (_batteryAlertShown && _areBatteriesHealthy()) {
      _batteryAlertShown = false;
    }
  }

  bool _areBatteriesHealthy() {
    bool battery0Healthy = !vehicleState.battery0Present || 
      (vehicleState.battery0State != 'fault' && 
       vehicleState.battery0TempState != 'high' && 
       vehicleState.battery0Charge > 20);

    bool battery1Healthy = !vehicleState.battery1Present || 
      (vehicleState.battery1State != 'fault' && 
       vehicleState.battery1TempState != 'high' && 
       vehicleState.battery1Charge > 20);

    return battery0Healthy && battery1Healthy;
  }

  void _handleBatteryCriticalStates(
    int batteryNumber,
    String currentState,
    String currentTempState,
    double charge,
    String? lastState,
    String? lastTempState,
  ) {
    if (!_batteryAlertShown) {
      // Check for fault state changes
      if (currentState == 'fault' && lastState != 'fault') {
        onBatteryAlert?.call('Battery ${batteryNumber + 1} fault detected!');
        _batteryAlertShown = true;
        return;
      }

      // Check for high temperature state changes
      if (currentTempState == 'high' && lastTempState != 'high') {
        onBatteryAlert?.call('Battery ${batteryNumber + 1} temperature critical!');
        _batteryAlertShown = true;
        return;
      }

      // Check for low charge
      if (charge <= 20 && (lastState == null || charge > 20)) {
        onBatteryAlert?.call('Battery ${batteryNumber + 1} charge critical!');
        _batteryAlertShown = true;
        return;
      }
    }
  }
}