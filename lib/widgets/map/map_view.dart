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
        TileLayer;
import 'package:flutter_map_animations/flutter_map_animations.dart'
    show
        AnimatedMap,
        AnimatedMapController,
        AnimatedMarker,
        AnimatedMarkerLayer,
        AnimatedPolyline,
        AnimatedPolylineLayer,
        AnimatedTileLayer,
        AnimatedVectorTileLayer,
        AnimatedWidgetBuilder,
        MapAnimationMixin;
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:routing_client_dart/routing_client_dart.dart'
    hide RouteInstruction;
import 'package:scooter_cluster/cubits/map_cubit.dart'
    show RouteInstruction, Straight, Turn;
import 'package:vector_map_tiles/vector_map_tiles.dart'
    show TileProviders, VectorTileLayer;
import 'package:vector_map_tiles_mbtiles/vector_map_tiles_mbtiles.dart'
    show MbTilesVectorTileProvider;
import 'package:vector_tile_renderer/vector_tile_renderer.dart' show Theme;

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
  final MbTiles mbTiles;
  final LatLng position;
  final double orientation;
  final void Function(TickerProvider)? mapReady;
  final FutureOr<void> Function(LatLng)? setDestination;
  final Route? route;
  final RouteInstruction? nextInstruction;

  const OfflineMapView({
    super.key,
    required this.mapController,
    required this.theme,
    required this.mbTiles,
    required this.position,
    required this.orientation,
    this.setDestination,
    this.route,
    this.mapReady,
    this.nextInstruction,
  });

  @override
  State<OfflineMapView> createState() => _OfflineMapViewState();
}

class _OfflineMapViewState extends State<OfflineMapView>
    with TickerProviderStateMixin {
  bool _isReady = false;

  Widget? _routeLayer() {
    final line = widget.route?.polyline;
    if (line == null || line.isEmpty) {
      return null;
    }

    final points =
        line.map((lnglat) => LatLng(lnglat.lat, lnglat.lng)).toList();

    return PolylineLayer(
      polylines: [
        Polyline(
          points: points,
          strokeWidth: 4.0,
          color: Colors.lightBlue,
        ),
      ],
    );
  }

  Widget? _instructionLayer() {
    final current = widget.nextInstruction;
    if (current == null) {
      return null;
    }

    final text = switch (current) {
      Straight(distance: final distance) =>
        'Continue for ${distance.toStringAsFixed(0)} m',
      Turn(distance: final distance, direction: final direction) =>
        'Turn ${direction.name} in ${distance.toStringAsFixed(0)} m',
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

  List<Marker> _routeMarkers() {
    final markers = <Marker>[];
    if (widget.route == null) return markers;

    for (final instruction in widget.route!.instructions) {
      markers.add(
        Marker(
          width: 50.0,
          height: 15.0,
          point: LatLng(instruction.location.lat, instruction.location.lng),
          alignment: Alignment.center,
          child: ColoredBox(
              color: Colors.white,
              child: Text(
                instruction.instruction,
                style: TextStyle(color: Colors.black, fontSize: 9),
              )),
        ),
      );
    }
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
            'versatiles-shortbread': MbTilesVectorTileProvider(
              mbtiles: widget.mbTiles,
              silenceTileNotFound: true,
            ),
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
            point:
                _isReady ? widget.mapController.camera.center : widget.position,
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
