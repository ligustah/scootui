import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart'
    show
        Alignment,
        BuildContext,
        Colors,
        Icon,
        Icons,
        StatelessWidget,
        Widget,
        TickerProviderStateMixin;
import 'package:flutter/widgets.dart' hide Route;
import 'package:flutter_map/flutter_map.dart'
    show
        FlutterMap,
        MapController,
        MapOptions,
        Marker,
        MarkerLayer,
        Polyline,
        PolylineLayer,
        StrokePattern,
        TileLayer;
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart'
    show TileProviders, VectorTileLayer, VectorTileProvider;
import 'package:vector_map_tiles_mbtiles/vector_map_tiles_mbtiles.dart'
    show MbTilesVectorTileProvider;
import 'package:vector_tile_renderer/vector_tile_renderer.dart' show Theme;

import '../../routing/models.dart';

final distanceCalculator = Distance();

class OnlineMapView extends StatefulWidget {
  final MapController mapController;
  final LatLng position;
  final double orientation;
  final void Function(TickerProvider)? mapReady;

  const OnlineMapView({
    super.key,
    required this.mapController,
    required this.position,
    required this.orientation,
    this.mapReady,
  });

  @override
  State<OnlineMapView> createState() => _OnlineMapViewState();
}

class _OnlineMapViewState extends State<OnlineMapView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        onMapReady: () => widget.mapReady?.call(this),
        minZoom: 8,
        maxZoom: 18,
        initialCenter: widget.position,
        initialZoom: 17,
      ),
      mapController: widget.mapController,
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'github.com/librescoot/scootui',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: widget.position,
              width: 30.0,
              height: 30.0,
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: -widget.orientation * (math.pi / 180),
                child: const Icon(
                  Icons.navigation,
                  color: Colors.blue,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OfflineMapView extends StatefulWidget {
  final MapController mapController;
  final Theme theme;
  final VectorTileProvider tiles;
  final LatLng position;
  final double orientation;
  final void Function(TickerProvider)? mapReady;
  final FutureOr<void> Function(LatLng)? setDestination;
  final Route? route;
  final RouteInstruction? nextInstruction;
  final LatLng? destination;

  const OfflineMapView({
    super.key,
    required this.mapController,
    required this.theme,
    required this.tiles,
    required this.position,
    required this.orientation,
    this.setDestination,
    this.route,
    this.mapReady,
    this.nextInstruction,
    this.destination,
  });

  @override
  State<OfflineMapView> createState() => _OfflineMapViewState();
}

class _OfflineMapViewState extends State<OfflineMapView>
    with TickerProviderStateMixin {
  bool _isReady = false;

  Widget? _routeLayer() {
    final line = widget.route?.waypoints;
    final destination = widget.destination;
    if (line == null || line.isEmpty) {
      return null;
    }

    final points = line
        .map((latlng) => LatLng(latlng.latitude, latlng.longitude))
        .toList();

    return PolylineLayer(
      polylines: [
        Polyline(
          points: points,
          strokeWidth: 4.0,
          color: Colors.lightBlue,
        ),
        if (destination != null && !_isDestinationNearWaypoint())
          Polyline(
            points: [
              LatLng(destination.latitude, destination.longitude),
              LatLng(points.last.latitude, points.last.longitude),
            ],
            strokeWidth: 4.0,
            pattern: StrokePattern.dashed(segments: [8, 10]),
            color: Colors.blue,
          ),
      ],
    );
  }

  Widget? _instructionLayer() {
    final current = widget.nextInstruction;
    if (current == null) {
      return null;
    }

    final distance = switch (current.distance) {
      > 500 =>
        '${((((current.distance + 99) ~/ 100) * 100) / 1000).toStringAsFixed(1)} km',
      > 100 => '${(((current.distance + 99) ~/ 100) * 100)} m',
      > 10 => '${(((current.distance + 9) ~/ 10) * 10)} m',
      _ => '${current.distance.toInt()} m',
    };

    final text = switch (current) {
      Keep(direction: final direction) => switch (direction) {
          KeepDirection.straight => 'Continue straight in $distance',
          _ => 'Keep ${direction.name} in $distance',
        },
      Turn(direction: final direction) => switch (direction) {
          TurnDirection.left => 'Turn left in $distance',
          TurnDirection.right => 'Turn right in $distance',
          TurnDirection.slightLeft => 'Turn slightly left in $distance',
          TurnDirection.slightRight => 'Turn slightly right in $distance',
          TurnDirection.sharpLeft => 'Turn sharply left in $distance',
          TurnDirection.sharpRight => 'Turn sharply right in $distance',
          TurnDirection.uTurn180 => 'Turn 180 degrees in $distance',
          TurnDirection.rightUTurn => 'Perform right u-turn in $distance',
          TurnDirection.uTurn => 'Perform u-turn in $distance',
        },
      Roundabout(side: final side, exitNumber: final exitNumber) =>
        'In the roundabout, take the ${side.name} exit $exitNumber in $distance',
      Other() => 'Do something in $distance',
      Exit(side: final side) => 'Take the ${side.name} exit in $distance',
    };

    return Align(
        alignment: Alignment.topRight,
        child: ColoredBox(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }

  bool _isDestinationNearWaypoint() {
    // determine if the selected destionatin is not directly next to the
    // last waypoint on the road.
    final destination = widget.destination;
    final lastWaypoint = widget.route!.waypoints.last;
    return destination == null ||
        distanceCalculator.as(LengthUnit.Meter, destination, lastWaypoint) < 15;
  }

  List<Marker> _routeMarkers() {
    final markers = <Marker>[];
    if (widget.route == null) return markers;
    final destination = widget.destination;
    final lastWaypoint = widget.route!.waypoints.last;
    final flagIcon = const Icon(Icons.flag, color: Colors.white, size: 30.0);
    final mapPinIcon =
        const Icon(Icons.location_pin, color: Colors.red, size: 30.0);

    final destinationNearWaypoint = _isDestinationNearWaypoint();

    if (destination != null && !destinationNearWaypoint) {
      markers.add(Marker(
        rotate: true,
        point: destination,
        child: mapPinIcon,
      ));
    }

    markers.add(Marker(
      rotate: true,
      point: LatLng(lastWaypoint.latitude, lastWaypoint.longitude),
      child: destinationNearWaypoint ? mapPinIcon : flagIcon,
    ));

    // for (final instruction in widget.route!.instructions) {
    //   markers.add(
    //     Marker(
    //       width: 50.0,
    //       height: 15.0,
    //       point: LatLng(instruction.location.lat, instruction.location.lng),
    //       alignment: Alignment.center,
    //       child: ColoredBox(
    //           color: Colors.white,
    //           child: Text(
    //             instruction.instruction,
    //             style: TextStyle(color: Colors.black, fontSize: 9),
    //           )),
    //     ),
    //   );
    // }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final routeLayer = _routeLayer();
    final instructionLayer = _instructionLayer();

    return FlutterMap(
      options: MapOptions(
        onMapReady: () {
          // no need to setState here, we don't need an immediate rebuild
          _isReady = true;
          widget.mapReady?.call(this);
        },
        minZoom: 8,
        maxZoom: 20,
        initialCenter: widget.position,
        initialZoom: 17,
        onSecondaryTap: (position, coordinates) {
          if (widget.setDestination != null) {
            widget.setDestination!(coordinates);
          }
        },
      ),
      mapController: widget.mapController,
      children: [
        VectorTileLayer(
          theme: widget.theme,
          tileProviders: TileProviders({
            'versatiles-shortbread': widget.tiles,
          }),
          maximumZoom: 20,
          fileCacheTtl: const Duration(seconds: 1),
          memoryTileCacheMaxSize: 0,
          memoryTileDataCacheMaxSize: 0,
          fileCacheMaximumSizeInBytes: 1024 * 1024,
          tileDelay: Duration.zero,
        ),
        if (routeLayer != null) routeLayer,
        MarkerLayer(markers: [
          Marker(
            rotate: true,
            point: widget.position,
            child: const Icon(
              Icons.navigation,
              color: Colors.blue,
              size: 30.0,
            ),
          ),
          ..._routeMarkers()
        ]),
        if (instructionLayer != null) instructionLayer,
      ],
    );
  }
}
