class VehicleState {
  double currentSpeed = 0.0;
  int rpm = 0;
  double motorVoltage = 0.0;
  double motorCurrent = 0.0;
  bool throttleActive = false;
  String blinkerState = 'off';
  int odometer = 0;
  int _lastOdometer = 0;  // To track changes for trip calculation
  double tripDistance = 0.0;  // Trip distance in kilometers
  String handlebarPosition = 'unlocked';
  String handlebarLockSensor = 'unlocked';
  String kickstandState = 'up';
  String seatboxButton = 'released';
  String vehicleState = '';
  String seatboxLock = '';
  
  // GPS data
  double gpsLatitude = 0.0;
  double gpsLongitude = 0.0;
  double gpsAltitude = 0.0;
  double gpsSpeed = 0.0;
  double gpsCourse = 0.0;
  String gpsTimestamp = '';
  bool hasGpsSignal = false;

  // Communication board battery state (cb-battery)
  double cbBatteryVoltage = 0.0;
  double cbBatteryCurrent = 0.0;
  int cbBatteryTimeToFull = 0;
  double cbBatteryTemp = 0.0;
  double cbBatteryRemainingCapacity = 0.0;
  double cbBatteryFullCapacity = 0.0;

  // Aux battery
  double auxBatteryVoltage = 0.0;
  String auxBatteryChargeStatus = '';

  // System state
  bool isConnected = false;
  String internetTech = '';
  int signalQuality = 0;
  String mdbVersion = '';
  String nrfFwVersion = '';

  // Bluetooth connection status
  bool isBluetoothConnected = false;
  String blePin = '';

  double get powerOutput => motorVoltage * motorCurrent / 1000;
  
  double get odometerKm => odometer / 1000;
  bool get isParked => vehicleState == 'parked';

  void updateFromRedis(String channel, String key, dynamic value) {
    switch (channel) {
      case 'cb-battery':
        _updateCBBatteryState(key, value);
        break;
      case 'internet':
        _updateInternetState(key, value);
        break;
      case 'aux-battery':
        _updateAuxBatteryState(key, value);
        break;
      case 'ble':
        _updateBluetoothState(key, value);
        break;
      case 'gps':
        _updateGpsState(key, value);
        break;
    }
  }

  void _updateBluetoothState(String key, dynamic value) {
    switch (key) {
      case 'status':
        isBluetoothConnected = value.toString() == 'connected';
        break;
      case 'pin-code':
        blePin = value.toString();
        break;
    }
  }


  // Reset trip distance to 0
  void resetTrip() {
    tripDistance = 0.0;
    _lastOdometer = odometer;  // Reset last odometer to current value
  }

    void _updateCBBatteryState(String key, dynamic value) {
    switch (key) {
      case 'cell-voltage':
        cbBatteryVoltage = (int.tryParse(value.toString()) ?? 0) / 1000000;
        break;
      case 'current':
        cbBatteryCurrent = (int.tryParse(value.toString()) ?? 0) / 1000;
        break;
      case 'temperature':
        cbBatteryTemp = double.tryParse(value.toString()) ?? cbBatteryTemp;
        break;
      case 'remaining-capacity':
        cbBatteryRemainingCapacity = (int.tryParse(value.toString()) ?? 0) / 1000;
        break;
      case 'full-capacity':
        cbBatteryFullCapacity = (int.tryParse(value.toString()) ?? 0) / 1000;
        break;
      case 'time-to-full':
        cbBatteryTimeToFull = int.tryParse(value.toString()) ?? cbBatteryTimeToFull;
        break;
    }
  }

  void _updateInternetState(String key, dynamic value) {
    switch (key) {
      case 'status':
        isConnected = value == 'connected';
        break;
      case 'access-tech':
        internetTech = value.toString();
        break;
      case 'signal-quality':
        signalQuality = int.tryParse(value.toString()) ?? signalQuality;
        break;
    }
  }

  void _updateAuxBatteryState(String key, dynamic value) {
    switch (key) {
      case 'voltage':
        auxBatteryVoltage = (int.tryParse(value.toString()) ?? 0) / 1000;
        break;
      case 'charge-status':
        auxBatteryChargeStatus = value.toString();
        break;
    }
  }

  void _updateGpsState(String key, dynamic value) {
    switch (key) {
      case 'latitude':
        gpsLatitude = double.tryParse(value.toString()) ?? gpsLatitude;
        hasGpsSignal = true;
        break;
      case 'longitude':
        gpsLongitude = double.tryParse(value.toString()) ?? gpsLongitude;
        break;
      case 'altitude':
        gpsAltitude = double.tryParse(value.toString()) ?? gpsAltitude;
        break;
      case 'speed':
        gpsSpeed = double.tryParse(value.toString()) ?? gpsSpeed;
        break;
      case 'course':
        gpsCourse = double.tryParse(value.toString()) ?? gpsCourse;
        break;
      case 'timestamp':
        gpsTimestamp = value.toString();
        break;
    }
  }
}