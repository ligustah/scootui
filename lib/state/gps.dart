import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'gps.g.dart';

enum GpsState {
  off,
  searching,
  fixEstablished,
  error,
}

@StateClass("gps", Duration(seconds: 3))
class GpsData extends Equatable with $GpsData {
  @override
  @StateField()
  final double latitude;

  @override
  @StateField()
  final double longitude;

  @override
  @StateField()
  final double course;

  @override
  @StateField()
  final double speed;

  @override
  @StateField()
  final double altitude;

  @override
  @StateField()
  final String timestamp;

  @override
  @StateField(defaultValue: "off")
  final GpsState state;

  LatLng get latLng => LatLng(latitude, longitude);
  double get courseRadians => course * (math.pi / 180);
  
  bool get hasRecentFix {
    if (timestamp.isEmpty) return false;
    try {
      final gpsTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(gpsTime).inSeconds;
      return diff <= 10; // GPS fix is recent if within 10 seconds
    } catch (e) {
      return false;
    }
  }

  GpsData({
    this.speed = 0,
    this.altitude = 0,
    this.course = 0,
    this.latitude = 0,
    this.longitude = 0,
    this.timestamp = "",
    this.state = GpsState.off,
  });
}
