import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

import 'models.dart';

class RouteHelpers {
  static const double _coordinateMatchTolerance = 0.00001; // About 1 meter
  static const double _offRouteTolerance = 50.0; // Meters

  /// Finds the closest point on a line segment to a given point
  static LatLng findClosestPointOnSegment(
    LatLng point,
    LatLng segmentStart,
    LatLng segmentEnd,
  ) {
    // Convert to radians for calculations
    final lat1 = segmentStart.latitude * (math.pi / 180);
    final lon1 = segmentStart.longitude * (math.pi / 180);
    final lat2 = segmentEnd.latitude * (math.pi / 180);
    final lon2 = segmentEnd.longitude * (math.pi / 180);
    final lat3 = point.latitude * (math.pi / 180);
    final lon3 = point.longitude * (math.pi / 180);

    // Calculate vectors
    final dx = lon2 - lon1;
    final dy = lat2 - lat1;
    final len2 = dx * dx + dy * dy;

    if (len2 == 0) return segmentStart;

    // Calculate projection
    var t = ((lon3 - lon1) * dx + (lat3 - lat1) * dy) / len2;
    t = math.max(0, math.min(1, t));

    // Calculate the closest point
    final projLon = lon1 + t * dx;
    final projLat = lat1 + t * dy;

    // Convert back to degrees
    return LatLng(
      projLat * (180 / math.pi),
      projLon * (180 / math.pi),
    );
  }

  /// Finds the closest point on a route polyline to a given point
  static (LatLng, int, double) findClosestPointOnRoute(
    LatLng point,
    List<LatLng> polyline,
  ) {
    if (polyline.isEmpty) {
      throw ArgumentError('Polyline cannot be empty');
    }

    var closestPoint = LatLng(polyline.first.latitude, polyline.first.longitude);
    var closestDistance = double.infinity;
    var closestSegmentIndex = 0;

    for (var i = 0; i < polyline.length - 1; i++) {
      final segmentStart = LatLng(polyline[i].latitude, polyline[i].longitude);
      final segmentEnd = LatLng(polyline[i + 1].latitude, polyline[i + 1].longitude);

      final pointOnSegment = findClosestPointOnSegment(
        point,
        segmentStart,
        segmentEnd,
      );

      final distance = const Distance().as(
        LengthUnit.Meter,
        point,
        pointOnSegment,
      );

      if (distance < closestDistance) {
        closestDistance = distance;
        closestPoint = pointOnSegment;
        closestSegmentIndex = i;
      }
    }

    return (closestPoint, closestSegmentIndex, closestDistance);
  }

  /// Finds upcoming instructions based on the current position and route
  static List<RouteInstruction> findUpcomingInstructions(
    LatLng currentPosition,
    Route route, {
    int maxInstructions = 3,
  }) {
    if (route.waypoints.isEmpty) {
      return [];
    }

    // Find the closest point on the route
    final (closestPoint, segmentIndex, distanceFromRoute) = findClosestPointOnRoute(
      currentPosition,
      route.waypoints,
    );

    // If we're too far from the route, don't show instructions
    if (distanceFromRoute > _offRouteTolerance) {
      return [];
    }

    // Find upcoming instructions after the current segment
    return _findUpcomingInstructionsAfterSegment(
      route.instructions,
      route.waypoints,
      segmentIndex,
      closestPoint,
      maxInstructions,
    );
  }

  /// Finds the next instruction based on the current position and route
  /// Kept for backwards compatibility, returns first upcoming instruction
  static RouteInstruction? findNextInstruction(
    LatLng currentPosition,
    Route route,
  ) {
    final upcoming = findUpcomingInstructions(currentPosition, route, maxInstructions: 1);
    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  /// Helper to find upcoming instructions after a given segment
  static List<RouteInstruction> _findUpcomingInstructionsAfterSegment(
    List<RouteInstruction> instructions,
    List<LatLng> polyline,
    int segmentIndexToCompareAgainst,
    LatLng fromPoint,
    int maxInstructions,
  ) {
    final List<RouteInstruction> upcomingInstructions = [];

    for (final instruction in instructions) {
      if (upcomingInstructions.length >= maxInstructions) {
        break;
      }

      // Use the stored originalShapeIndex directly
      final int instructionShapeIndex = instruction.originalShapeIndex;

      // Ensure originalShapeIndex is valid before using
      if (instructionShapeIndex < 0) {
        continue; // Skip instructions that couldn't be properly mapped to the shape
      }

      if (instructionShapeIndex > segmentIndexToCompareAgainst) {
        // Calculate distance to the instruction's starting point
        final instructionPoint = instruction.location;
        final distanceToManeuverStart = const Distance().as(
          LengthUnit.Meter,
          fromPoint,
          instructionPoint,
        );

        upcomingInstructions.add(instruction.copyWith(distance: distanceToManeuverStart));
      }
    }

    return upcomingInstructions;
  }

  /// Helper to find the next instruction after a given segment
  /// Kept for backwards compatibility
  static RouteInstruction? _findNextInstructionAfterSegment(
    List<RouteInstruction> instructions,
    List<LatLng> polyline,
    int segmentIndexToCompareAgainst,
    LatLng fromPoint,
  ) {
    final upcoming = _findUpcomingInstructionsAfterSegment(
      instructions,
      polyline,
      segmentIndexToCompareAgainst,
      fromPoint,
      1,
    );
    return upcoming.isNotEmpty ? upcoming.first : null;
  }
}
