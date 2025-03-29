class VehicleState {
  // GPS data
  double gpsLatitude = 0.0;
  double gpsLongitude = 0.0;
  double gpsAltitude = 0.0;
  double gpsSpeed = 0.0;
  double gpsCourse = 0.0;
  String gpsTimestamp = '';
  bool hasGpsSignal = false;

  bool get isParked => false;

  void updateFromRedis(String channel, String key, dynamic value) {
  }
}