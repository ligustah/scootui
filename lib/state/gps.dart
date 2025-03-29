import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'gps.g.dart';

@StateClass("aux-battery", Duration(seconds: 3))
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

  GpsData({
    this.speed = 0,
    this.altitude = 0,
    this.course = 0,
    this.latitude = 0,
    this.longitude = 0,
    this.timestamp = "",
  });
}
