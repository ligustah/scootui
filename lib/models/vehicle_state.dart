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

  // System state
  bool isConnected = false;
  String internetTech = '';
  int signalQuality = 0;
  String mdbVersion = '';
  String nrfFwVersion = '';

  double get powerOutput => motorVoltage * motorCurrent / 1000;
  
  double get odometerKm => odometer / 1000;
  bool get isParked => vehicleState == 'parked';

  void updateFromRedis(String channel, String key, dynamic value) {
    switch (channel) {
      case 'gps':
        _updateGpsState(key, value);
        break;
    }
  }



  // Reset trip distance to 0
  void resetTrip() {
    tripDistance = 0.0;
    _lastOdometer = odometer;  // Reset last odometer to current value
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