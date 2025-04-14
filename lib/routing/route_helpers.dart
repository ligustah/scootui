import 'dart:math' as math;
import 'package:latlong2/latlong.dart';
import 'package:routing_client_dart/routing_client_dart.dart' as routing;

import '../cubits/map_cubit.dart';
import 'brouter.dart';

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
    List<routing.LngLat> polyline,
  ) {
    if (polyline.isEmpty) {
      throw ArgumentError('Polyline cannot be empty');
    }

    var closestPoint = LatLng(polyline.first.lat, polyline.first.lng);
    var closestDistance = double.infinity;
    var closestSegmentIndex = 0;

    for (var i = 0; i < polyline.length - 1; i++) {
      final segmentStart = LatLng(polyline[i].lat, polyline[i].lng);
      final segmentEnd = LatLng(polyline[i + 1].lat, polyline[i + 1].lng);
      
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

  /// Finds the next instruction based on the current position and route
  static RouteInstruction? findNextInstruction(
    LatLng currentPosition,
    routing.Route route,
  ) {
    if (route.polyline == null || route.polyline!.isEmpty) {
      return null;
    }

    // Find the closest point on the route
    final (closestPoint, segmentIndex, distanceFromRoute) = findClosestPointOnRoute(
      currentPosition,
      route.polyline!,
    );

    // If we're too far from the route, don't show instructions
    if (distanceFromRoute > _offRouteTolerance) {
      return null;
    }

    // Find the next instruction after the current segment
    var nextInstruction = _findNextInstructionAfterSegment(
      route.instructions,
      route.polyline!,
      segmentIndex,
      closestPoint,
    );

    // If we didn't find a next instruction, we might be very close to or past the last one
    if (nextInstruction == null && segmentIndex > 0) {
      // Try looking from the previous segment
      nextInstruction = _findNextInstructionAfterSegment(
        route.instructions,
        route.polyline!,
        segmentIndex - 1,
        closestPoint,
      );
    }

    return nextInstruction;
  }

  /// Helper to find the next instruction after a given segment
  static RouteInstruction? _findNextInstructionAfterSegment(
    List<routing.RouteInstruction> instructions,
    List<routing.LngLat> polyline,
    int segmentIndex,
    LatLng fromPoint,
  ) {
    for (final instruction in instructions) {
      final instructionPoint = LatLng(
        instruction.location.lat,
        instruction.location.lng,
      );

      // Find the closest polyline point to this instruction
      var minDistance = double.infinity;
      var instructionIndex = -1;

      for (var i = 0; i < polyline.length; i++) {
        final point = polyline[i];
        final latDiff = (point.lat - instruction.location.lat).abs();
        final lngDiff = (point.lng - instruction.location.lng).abs();
        
        if (latDiff < _coordinateMatchTolerance && 
            lngDiff < _coordinateMatchTolerance) {
          final dist = const Distance().as(
            LengthUnit.Meter,
            LatLng(point.lat, point.lng),
            instructionPoint,
          );
          if (dist < minDistance) {
            minDistance = dist;
            instructionIndex = i;
          }
        }
      }

      if (instructionIndex > segmentIndex) {
        // Calculate distance to the instruction
        final distance = const Distance().as(
          LengthUnit.Meter,
          fromPoint,
          instructionPoint,
        );

        // Convert the instruction to our format
        final hint = VoiceHints.fromAction(instruction.instruction);
        return switch (hint) {
          VoiceHints.turnLeft ||
          VoiceHints.slightTurnLeft ||
          VoiceHints.sharpTurnLeft ||
          VoiceHints.turnRight ||
          VoiceHints.slightTurnRight ||
          VoiceHints.sharpTurnRight =>
            RouteInstruction.turn(
              distance: distance,
              direction: switch (hint) {
                VoiceHints.turnLeft => TurnDirection.left,
                VoiceHints.slightTurnRight => TurnDirection.slightRight,
                VoiceHints.sharpTurnRight => TurnDirection.sharpRight,
                VoiceHints.slightTurnLeft => TurnDirection.slightLeft,
                VoiceHints.sharpTurnLeft => TurnDirection.sharpLeft,
                _ => TurnDirection.right,
              },
            ),
          VoiceHints.straight => RouteInstruction.straight(
              distance: distance,
            ),
          _ => null,
        };
      }
    }

    return null;
  }
} 