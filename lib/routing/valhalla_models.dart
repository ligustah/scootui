import 'package:freezed_annotation/freezed_annotation.dart';

part 'valhalla_models.freezed.dart';
part 'valhalla_models.g.dart';

@freezed
abstract class ValhallaResponse with _$ValhallaResponse {
  const factory ValhallaResponse({
    required Trip trip,
  }) = _ValhallaResponse;

  factory ValhallaResponse.fromJson(Map<String, dynamic> json) => _$ValhallaResponseFromJson(json);
}

@freezed
abstract class Trip with _$Trip {
  const factory Trip({
    required List<Leg> legs,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}

@freezed
abstract class Leg with _$Leg {
  const factory Leg({
    required List<Maneuver> maneuvers,
    required Summary summary,
    required String shape,
  }) = _Leg;

  factory Leg.fromJson(Map<String, dynamic> json) => _$LegFromJson(json);
}

@freezed
abstract class Maneuver with _$Maneuver {
  const factory Maneuver({
    required int type,
    required double length,
    int? beginShapeIndex,
    @JsonKey(name: 'roundabout_exit_count') int? roundaboutExitCount,
  }) = _Maneuver;

  factory Maneuver.fromJson(Map<String, dynamic> json) => _$ManeuverFromJson(json);
}

@freezed
abstract class Summary with _$Summary {
  const factory Summary({
    required double length,
    required int time,
  }) = _Summary;

  factory Summary.fromJson(Map<String, dynamic> json) => _$SummaryFromJson(json);
}
