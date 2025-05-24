import 'package:flutter/material.dart';
import 'dart:math' as math;

class UserLocationMarkerIcon extends StatelessWidget {
  final double orientation;

  const UserLocationMarkerIcon({
    Key? key,
    required this.orientation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assuming orientation is in degrees, positive clockwise from North.
    // Transform.rotate takes radians. Positive angle rotates clockwise.
    // If 'orientation' is map's rotation, the icon should point "up" on the screen,
    // so it needs to be counter-rotated by the map's orientation.
    // If 'orientation' is the user's heading, and the map is North-up,
    // then the icon should rotate by 'orientation'.
    // The instruction mentioned "mapState.orientation", which usually means map's rotation.
    // If the map rotates, the marker should counter-rotate to stay pointing "forward" from user's perspective
    // or stay pointing to the user's heading if map is north-up.
    // The existing code in map_view.dart for Marker rotation is: angle: -widget.orientation * (math.pi / 180),
    // This suggests 'widget.orientation' is the map's rotation and the icon is counter-rotated.
    // Let's stick to this convention.
    return Transform.rotate(
      angle: -orientation * (math.pi / 180),
      child: const Icon(
        Icons.navigation,
        color: Colors.blue, // Consider making color configurable or theme-dependent
        size: 28.0, // Adjust size as needed
      ),
    );
  }
}
