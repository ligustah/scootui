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
  @StateField()
  final double latitude;

  @StateField()
  final double longitude;

  @StateField()
  final double course;

  @StateField()
  final double speed;

  @StateField()
  final double altitude;

  @StateField()
  final String timestamp;

  @StateField(defaultValue: "off")
  final GpsState state;

  LatLng get latLng => LatLng(latitude, longitude);
  double get courseRadians => course * (math.pi / 180);

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
