import 'package:dio/dio.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:latlong2/latlong.dart';

import 'models.dart';
import 'valhalla_models.dart';

class ValhallaService {
  static const String _routeEndpoint = '/route';
  static const String _motorScooterCosting = 'motor_scooter';
  static const String _units = 'kilometers';
  static const String _language = 'en-US';
  static const int _connectTimeoutSeconds = 5;
  static const int _receiveTimeoutSeconds = 5;

  // Valhalla maneuver types that map to our instruction types
  static final Map<int, RouteInstruction Function(double, LatLng)> _maneuverMap = {
    2: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.right,
          location: location,
        ),
    3: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.left,
          location: location,
        ),
    5: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.right,
          location: location,
        ),
    6: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.left,
          location: location,
        ),
    7: (distance, location) => RouteInstruction.keep(
          distance: distance,
          direction: KeepDirection.straight,
          location: location,
        ),
    8: (distance, location) => RouteInstruction.keep(
          distance: distance,
          direction: KeepDirection.straight,
          location: location,
        ),
    9: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.slightRight,
          location: location,
        ),
    10: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.right,
          location: location,
        ),
    11: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.sharpRight,
          location: location,
        ),
    12: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.rightUTurn,
          location: location,
        ),
    13: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.uTurn,
          location: location,
        ),
    14: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.sharpLeft,
          location: location,
        ),
    15: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.left,
          location: location,
        ),
    16: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.slightLeft,
          location: location,
        ),
    17: (distance, location) => RouteInstruction.keep(
          distance: distance,
          direction: KeepDirection.straight,
          location: location,
        ),
    18: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.right,
          location: location,
        ),
    19: (distance, location) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.left,
          location: location,
        ),
    20: (distance, location) => RouteInstruction.exit(
          distance: distance,
          side: ExitSide.right,
          location: location,
        ),
    21: (distance, location) => RouteInstruction.exit(
          distance: distance,
          side: ExitSide.left,
          location: location,
        ),
    22: (distance, location) => RouteInstruction.keep(
          distance: distance,
          direction: KeepDirection.straight,
          location: location,
        ),
    23: (distance, location) => RouteInstruction.keep(
          distance: distance,
          direction: KeepDirection.right,
          location: location,
        ),
    24: (distance, location) => RouteInstruction.keep(
          distance: distance,
          direction: KeepDirection.left,
          location: location,
        ),
    26: (distance, location) => RouteInstruction.roundabout(
          distance: distance,
          side: RoundaboutSide.right,
          exitNumber: 1,
          location: location,
        ),
  };

  final Dio _dio;
  final String serverURL;

  ValhallaService({required this.serverURL})
      : _dio = Dio(BaseOptions(
          baseUrl: serverURL,
          connectTimeout: Duration(seconds: _connectTimeoutSeconds),
          receiveTimeout: Duration(seconds: _receiveTimeoutSeconds),
        ));

  Future<Route> getRoute(LatLng start, LatLng end) async {
    final response = await _dio.post(
      _routeEndpoint,
      data: {
        'locations': [
          {'lat': start.latitude, 'lon': start.longitude},
          {'lat': end.latitude, 'lon': end.longitude}
        ],
        'costing': _motorScooterCosting,
        'units': _units,
        'language': _language,
        'directions_options': {
          'units': _units,
          'language': _language,
        }
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get route from Valhalla');
    }

    final valhallaResponse = ValhallaResponse.fromJson(response.data);
    final leg = valhallaResponse.trip.legs.first;

    final List<LatLng> waypoints = [];
    final List<RouteInstruction> instructions = [];

    // Extract waypoints from shape
    final points =
        decodePolyline(leg.shape, accuracyExponent: 6).map((e) => LatLng(e[0].toDouble(), e[1].toDouble())).toList();
    waypoints.addAll(points);

    // Extract instructions
    for (final maneuver in leg.maneuvers) {
      final location = LatLng(
        maneuver.beginShapeIndex != null ? points[maneuver.beginShapeIndex!].latitude : points.last.latitude,
        maneuver.beginShapeIndex != null ? points[maneuver.beginShapeIndex!].longitude : points.last.longitude,
      );

      final distance = maneuver.length * 1000; // Convert to meters

      final instruction = _createInstruction(maneuver.type, distance, location);
      if (instruction != null) {
        instructions.add(instruction);
      }
    }

    return Route(
      distance: leg.summary.length * 1000, // Convert to meters
      duration: Duration(seconds: leg.summary.time),
      waypoints: waypoints,
      instructions: instructions,
    );
  }

  RouteInstruction? _createInstruction(int type, double distance, LatLng location) {
    final instructionCreator = _maneuverMap[type];
    if (instructionCreator != null) {
      return instructionCreator(distance, location);
    }
    return RouteInstruction.other(distance: distance, location: location);
  }
}
