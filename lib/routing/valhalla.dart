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
  static final Map<int, RouteInstruction Function(double, LatLng, int, String?, String?)> _maneuverMap = {
    2: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.right,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    3: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.left,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    5: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.right,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    6: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.left,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    7: (distance, location, index, streetName, instructionText) => RouteInstruction.keep(
          distance: distance,
          direction: KeepDirection.straight,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    8: (distance, location, index, streetName, instructionText) => RouteInstruction.keep(
          distance: distance,
          direction: KeepDirection.straight,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    9: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.slightRight,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    10: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.right,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    11: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.sharpRight,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    12: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.rightUTurn,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    13: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.uTurn,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    14: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.sharpLeft,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    15: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.left,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    16: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.slightLeft,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    17: (distance, location, index, streetName, instructionText) => RouteInstruction.keep(
          distance: distance,
          direction: KeepDirection.straight,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    18: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.right,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    19: (distance, location, index, streetName, instructionText) => RouteInstruction.turn(
          distance: distance,
          direction: TurnDirection.left,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    20: (distance, location, index, streetName, instructionText) => RouteInstruction.exit(
          distance: distance,
          side: ExitSide.right,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    21: (distance, location, index, streetName, instructionText) => RouteInstruction.exit(
          distance: distance,
          side: ExitSide.left,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    22: (distance, location, index, streetName, instructionText) => RouteInstruction.keep(
          distance: distance,
          direction: KeepDirection.straight,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    23: (distance, location, index, streetName, instructionText) => RouteInstruction.keep(
          distance: distance,
          direction: KeepDirection.right,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    24: (distance, location, index, streetName, instructionText) => RouteInstruction.keep(
          distance: distance,
          direction: KeepDirection.left,
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
        ),
    // Note: Valhalla maneuver type 26 (RoundaboutEnter) has roundabout_exit_count.
    // Our RouteInstruction.roundabout expects exitNumber.
    // Type 25 is RoundaboutExit in OSRM, Valhalla uses type 27 for ExitRoundabout.
    // The example route.json has type 26 with roundabout_exit_count.
    // This mapping might need adjustment based on how exitNumber is derived for Valhalla.
    // For now, passing maneuver.beginShapeIndex as originalShapeIndex.
    // The example JSON for type 26 does not have an explicit exit number, but `roundabout_exit_count`.
    // This might be a slight mismatch or requires interpretation.
    // For type 26, Valhalla docs say "The number of exits to take from the roundabout."
    // The example JSON has "roundabout_exit_count": 2 for type 26. This should be the exit number.
    26: (distance, location, index, streetName, instructionText) => RouteInstruction.roundabout(
          distance: distance,
          side: RoundaboutSide.right, // Assuming right-hand traffic default for roundabout side
          exitNumber: 1, // Placeholder - this needs to come from maneuver.roundabout_exit_count if available
          location: location,
          originalShapeIndex: index,
          streetName: streetName,
          instructionText: instructionText,
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
    final requestData = {
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
    };

    // print('ValhallaService: Request to $serverURL$_routeEndpoint');
    // print('ValhallaService: Request data: $requestData');

    final response = await _dio.post(
      _routeEndpoint,
      data: requestData,
    );

    // print('ValhallaService: Response status: ${response.statusCode}');
    // print('ValhallaService: Response data: ${response.data}');

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
      // If beginShapeIndex is null, this maneuver might be problematic or represent a point-like instruction.
      // For now, we assume valid maneuvers for turn-by-turn will have a beginShapeIndex.
      // If it can be null and still be a valid instruction, originalShapeIndex in RouteInstruction
      // would need to be nullable (int?) and we'd pass null or a sentinel like -1.
      // Given route.json, all maneuvers had a beginShapeIndex.
      if (maneuver.beginShapeIndex == null) {
        // Optionally log or handle maneuvers without a shape index if they are not expected
        // For now, skip creating an instruction if beginShapeIndex is null,
        // as it cannot be placed on the polyline for navigation sequence.
        // Alternatively, assign a special index like -1 if `RouteInstruction.originalShapeIndex` becomes nullable.
        print(
            "Skipping maneuver: Type=${maneuver.type}, Length=${maneuver.length}, roundaboutExitCount=${maneuver.roundaboutExitCount}. Full maneuver object: ${maneuver.toString()}");
        continue;
      }

      final location = LatLng(
        points[maneuver.beginShapeIndex!].latitude,
        points[maneuver.beginShapeIndex!].longitude,
      );

      final distance = maneuver.length * 1000; // Convert to meters

      // Special handling for roundabout exit number if needed
      int exitCountForRoundabout = maneuver.roundaboutExitCount ?? 1; // Default to 1 if null

      // Extract street name and instruction text from maneuver
      final streetName = _extractStreetName(maneuver);
      final instructionText = _extractInstructionText(maneuver);

      final instruction = _createInstruction(maneuver.type, distance, location, maneuver.beginShapeIndex!,
          exitCountForRoundabout, streetName, instructionText);
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

  RouteInstruction? _createInstruction(int type, double distance, LatLng location, int beginShapeIndex,
      int roundaboutExitCount, String? streetName, String? instructionText) {
    final instructionCreator = _maneuverMap[type];
    if (instructionCreator != null) {
      // For roundabout type 26, we need to pass the exit count.
      // The map function for type 26 needs to be updated to accept it or we handle it here.
      // Let's update the map function for type 26 to use roundaboutExitCount.
      // The current signature is (double, LatLng, int) -> (distance, location, originalShapeIndex)
      // We need to pass roundaboutExitCount to the RouteInstruction.roundabout factory.
      // This means the _maneuverMap functions for roundabouts need a different signature or special handling.

      // Simpler: modify the specific call for type 26 if it's the only one needing extra param.
      if (type == 26) {
        // ManeuverType.kRoundaboutEnter
        return RouteInstruction.roundabout(
            distance: distance,
            side: RoundaboutSide.right, // Default, Valhalla might not specify side for enter
            exitNumber: roundaboutExitCount,
            location: location,
            originalShapeIndex: beginShapeIndex,
            streetName: streetName,
            instructionText: instructionText);
      }
      return instructionCreator(distance, location, beginShapeIndex, streetName, instructionText);
    }
    return RouteInstruction.other(
        distance: distance,
        location: location,
        originalShapeIndex: beginShapeIndex,
        streetName: streetName,
        instructionText: instructionText);
  }

  String? _extractStreetName(Maneuver maneuver) {
    // Try to get street name from streetNames first, fallback to beginStreetNames
    if (maneuver.streetNames?.isNotEmpty == true) {
      return maneuver.streetNames!.first;
    }
    if (maneuver.beginStreetNames?.isNotEmpty == true) {
      return maneuver.beginStreetNames!.first;
    }
    return null;
  }

  String? _extractInstructionText(Maneuver maneuver) {
    // Use verbal succinct instruction for turn-by-turn display, fallback to other options
    return maneuver.verbalSuccinctTransitionInstruction ??
        maneuver.verbalPreTransitionInstruction ??
        maneuver.instruction;
  }
}
