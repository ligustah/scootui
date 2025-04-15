import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:latlong2/latlong.dart';

import 'models.dart';

part 'brouter.freezed.dart';
part 'brouter.g.dart';

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

    final List<LatLng> waypoints = geoRoute.geometry is GeoJSONLineString
        ? (geoRoute.geometry as GeoJSONLineString)
            .coordinates
            .map((e) => LatLng(e[1], e[0]))
            .toList()
        : [];

    final instructions = brouterProperties.voiceHints
        .map((hint) => RouteInstruction.fromHint(hint, waypoints))
        .toList();

    return Route(
      distance: double.parse(brouterProperties.trackLength),
      duration: Duration(seconds: int.parse(brouterProperties.totalTime)),
      waypoints: waypoints,
      instructions: instructions,
    );
  }
}
