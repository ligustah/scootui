import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:latlong2/latlong.dart';
import 'package:routing_client_dart/routing_client_dart.dart';

part 'brouter.freezed.dart';
part 'brouter.g.dart';

enum VoiceHints implements Comparable<VoiceHints> {
  straight(1, "straight"), // continue (go straight)
  turnLeft(2, "turn_left"), // turn left
  slightTurnLeft(3, "slight_turn_left"), // turn slightly left
  sharpTurnLeft(4, "sharp_turn_left"), // turn sharply left
  turnRight(5, "turn_right"), // turn right
  slightTurnRight(6, "slight_turn_right"), // turn slightly right
  sharpTurnRight(7, "sharp_turn_right"), // turn sharply right
  keepLeft(8, "keep_left"), // keep left
  keepRight(9, "keep_right"), // keep right
  uTurn(10, "u_turn"), // U-turn
  rightUTurn(11, "right_u_turn"), // Right U-turn
  offRoute(12, "off_route"), // Off route
  roundabout(13, "roundabout"), // Roundabout
  roundaboutLeft(14, "roundabout_left"), // Roundabout left
  uTurn180(15, "u_turn_180"), // 180 degree u-turn
  beelineRouting(16, "beeline_routing"), // Beeline routing
  exitLeft(17, "exit_left"), // exit left
  exitRight(18, "exit_right"); // exit right

  const VoiceHints(this.code, this.action);

  final int code;
  final String action;

  @override
  int compareTo(VoiceHints other) => code.compareTo(other.code);

  factory VoiceHints.fromCode(int code) {
    return VoiceHints.values.firstWhere(
      (element) => element.code == code,
      orElse: () => throw ArgumentError(
        "Invalid code: $code. Valid codes are: ${VoiceHints.values.map((e) => e.code).toList()}",
      ),
    );
  }

  factory VoiceHints.fromAction(String action) {
    return VoiceHints.values.firstWhere(
      (element) => element.action == action,
      orElse: () => throw ArgumentError(
        "Invalid action: $action. Valid actions are: ${VoiceHints.values.map((e) => e.action).toList()}",
      ),
    );
  }
}

@freezed
abstract class BRouterProperties with _$BRouterProperties {
  const BRouterProperties._();

  const factory BRouterProperties({
    required String creator,
    required String name,
    @JsonKey(name: 'track-length') required String trackLength,
    @JsonKey(name: 'filtered ascend') required String filteredAscend,
    @JsonKey(name: 'plain-ascend') required String plainAscend,
    @JsonKey(name: 'total-time') required String totalTime,
    @JsonKey(name: 'total-energy') required String totalEnergy,
    @JsonKey(name: 'voicehints') required List<List<int>> voiceHints,
    required String cost,
    required List<List<String>> messages,
    required List<double> times,
  }) = _BRouterProperties;

  factory BRouterProperties.fromJson(Map<String, dynamic> json) =>
      _$BRouterPropertiesFromJson(json);
}

enum BRouterProfile { moped }

class BRouterRequest {
  final List<LatLng> waypoints;
  final BRouterProfile profile;

  BRouterRequest(
      {required this.waypoints, this.profile = BRouterProfile.moped});

  Map<String, dynamic> encode() {
    final lonlats = waypoints.map((point) {
      return "${point.longitude},${point.latitude}";
    }).join("|");

    final params = {
      "lonlats": lonlats,
      "profile": profile.name,
      "format": "geojson",
      "alternativeidx": 0,
      "timode": 2,
    };

    return params;
  }
}

const String _publicBRouterServer = 'https://brouter.de/';

void check(Map<String, dynamic> json) {
  final map = {
    "creator": json['creator'] as String,
    "name": json['name'] as String,
    "trackLength": json['track-length'] as String,
    "filteredAscend": json['filtered ascend'] as String,
    "plainAscend": json['plain-ascend'] as String,
    "totalTime": json['total-time'] as String,
    "totalEnergy": json['total-energy'] as String,
    "voiceHints": (json['voicehints'] as List<dynamic>)
        .map(
            (e) => (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
        .toList(),
    "cost": json['cost'] as String,
    "messages": (json['messages'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
        .toList(),
    "times": (json['times'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList()
  };

  print("check: $map");
}

class BRouterService {
  final Dio _dio;

  BRouterService({String? serverURL})
      : _dio = Dio(BaseOptions(baseUrl: serverURL ?? _publicBRouterServer));

  Future<Route> getRoute(BRouterRequest request) async {
    final response =
        await _dio.get("/brouter", queryParameters: request.encode());
    if (response.statusCode != null && response.statusCode! > 299 ||
        response.statusCode! < 200) {
      throw Exception("Cannot get route");
    }

    final collection = GeoJSONFeatureCollection.fromJSON(response.toString());
    final geoRoute = collection.features.first as GeoJSONFeature;
    final props = geoRoute.properties;

    if (props == null) {
      throw Exception("No properties found in the response");
    }

    check(props);
    final brouterProperties = BRouterProperties.fromJson(props);

    List<String>? labels;
    List<Map<String, String>> messages = [];
    for (var message in brouterProperties.messages) {
      if (labels == null) {
        labels = message;
      } else {
        messages.add({
          for (var element in message) labels[message.indexOf(element)]: element
        });
      }
    }

    // [
    //  2,        hint.indexInTrack
    //  2,        hint.getJsonCommandIndex(turnInstructionMode)
    //  0,        hint.getExitNumber()
    //  173.0,    hint.distanceToNext
    //  -89,      hint.angle
    // ]

    final List<LngLat> polyline = geoRoute.geometry is GeoJSONLineString
        ? (geoRoute.geometry as GeoJSONLineString)
            .coordinates
            .map((e) => LngLat(lng: e[0], lat: e[1]))
            .toList()
        : [];

    final instructions = brouterProperties.voiceHints.map((hint) {
      var [indexInTrack, jsonCommandIndex, exitNumber, distanceToNext, angle] =
          hint;

      return RouteInstruction(
          distance: distanceToNext.toDouble(),
          duration: 5.0,
          instruction: VoiceHints.fromCode(jsonCommandIndex).action,
          location: polyline[indexInTrack]);
    }).toList();

    return Route(
      distance: double.parse(brouterProperties.trackLength),
      duration: double.parse(brouterProperties.totalTime),
      polylineEncoded: null,
      polyline: polyline,
      instructions: instructions,
    );
  }
}
