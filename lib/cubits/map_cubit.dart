import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_tile/util/geometry.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

import '../routing/brouter.dart';
import '../routing/models.dart';
import '../routing/route_helpers.dart';
import '../state/gps.dart';
import 'mdb_cubits.dart';
import 'theme_cubit.dart';

part 'map_cubit.freezed.dart';
part 'map_state.dart';

final distanceCalculator = Distance();
const defaultCoordinates = LatLng(52.52437, 13.41053);

class Address {
  final String id;
  final LatLng coordinates;
  final double x;
  final double y;

  Address(
      {required this.id,
      required this.coordinates,
      required this.x,
      required this.y});
}

class MapCubit extends Cubit<MapState> {
  late final StreamSubscription<GpsData> _gpsSub;
  late final StreamSubscription<ThemeState> _themeSub;
  static const double _offRouteTolerance = 5.0; // 5 meters
  static const double _maxZoom = 19.0;
  static const double _minZoom = 16.5;
  static const double _zoomInStart = 220.0;
  static const double _zoomInEnd = 30.0;
  static const Offset _navigationOffset = Offset(0, 120);
  DateTime? _lastReroute;
  AnimatedMapController? _animatedController;
  Future<void>? _currentAnimation;
  final Map<String, Address> _addressCoordinates = {};
  int _currentAddressId = 0;

  bool _mapLocked = false;

  static MapCubit create(BuildContext context) => MapCubit(
        context.read<GpsSync>().stream,
        context.read<ThemeCubit>().stream,
      )
        .._onGpsData(context.read<GpsSync>().state)
        .._loadMap(context.read<ThemeCubit>().state);

  MapCubit(Stream<GpsData> stream, Stream<ThemeState> themeUpdates)
      : super(MapLoading(
            controller: MapController(), position: defaultCoordinates)) {
    _gpsSub = stream.listen(_onGpsData);
    _themeSub = themeUpdates.listen(_onThemeUpdate);
  }

  @override
  Future<void> close() {
    final current = state;
    current.controller.dispose();
    switch (current) {
      case MapOffline():
        current.mbTiles.dispose();
        break;
      default:
    }
    _themeSub.cancel();
    _gpsSub.cancel();
    return super.close();
  }

  void _updateRoute(Route route) {
    final current = state;

    emit(switch (current) {
      MapOnline() => current.copyWith(route: route),
      MapOffline() => current.copyWith(route: route),
      _ => current,
    });
  }

  Future<void> setDestinationAddress(String addressId) async {
    final address = _addressCoordinates[addressId];
    if (address == null) {
      return;
    }

    await setDestination(address.coordinates);

    final current = state;
    final route = current.route;
    if (route == null) {
      return;
    }

    // play an animation that first shows the destination, then the whole route,
    // then the current position
    _mapLocked = true;
    final lastWaypoint = route.polyline!.last.toLatLng();
    final destination = address.coordinates;

    // if the destination is more than 10 meters away from the last waypoint,
    // show both the destination and the last waypoint, otherwise just center
    // on the destination
    if (distanceCalculator.as(LengthUnit.Meter, lastWaypoint, destination) >
        10) {
      await _animatedController?.animatedFitCamera(
        cameraFit: CameraFit.coordinates(
            coordinates: [lastWaypoint, destination],
            padding: const EdgeInsets.all(100)),
        rotation: 0,
        cancelPreviousAnimations: true,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 2000),
      );
    } else {
      await _animatedController?.animateTo(
        dest: destination,
        zoom: _minZoom,
        rotation: 0,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 2000),
      );
    }
    await Future.delayed(const Duration(milliseconds: 5000));
    await _animatedController?.animatedFitCamera(
      cameraFit: CameraFit.coordinates(
          coordinates: [current.position, destination],
          padding: const EdgeInsets.all(50)),
      rotation: 0,
      cancelPreviousAnimations: true,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 2000),
    );
    await Future.delayed(const Duration(milliseconds: 4000));
    _mapLocked = false;

    _moveAndRotate(current.position, current.orientation,
        duration: const Duration(milliseconds: 2000));
  }

  Future<void> setDestination(LatLng destination) async {
    final current = state;
    if (current is! MapOffline && current is! MapOnline) {
      return;
    }

    final brouter = BRouterService();
    final route = await brouter.getRoute(
      BRouterRequest(
        waypoints: [current.position, destination],
      ),
    );

    emit(current.copyWith(
        route: route,
        destination: destination,
        nextInstruction: _nextInstruction(route, current.position)));
  }

  void _moveAndRotate(LatLng center, double course,
      {Duration? duration, RouteInstruction? instruction}) {
    if (_mapLocked) return;
    final ctrl = _animatedController;

    if (ctrl == null) return;

    final route = state.route;
    double bearing = course;
    double zoom = _minZoom;

    if (route != null && route.waypoints.isNotEmpty) {
      // Find the closest point and next point on route
      final (point, segmentIndex, distance) =
          RouteHelpers.findClosestPointOnRoute(
        center,
        route.waypoints,
      );

      // Only use route bearing if we're close enough to the route
      if (distance < _offRouteTolerance) {
        // 5 meters tolerance
        // Get next point to calculate bearing
        final nextPointIndex =
            math.min(segmentIndex + 1, route.waypoints.length - 1);
        if (nextPointIndex > segmentIndex) {
          final currentPoint = route.waypoints[segmentIndex];
          final nextPoint = route.waypoints[nextPointIndex];

          // Calculate bearing between points
          final y = math.sin(nextPoint.longitude - currentPoint.longitude) *
              math.cos(nextPoint.latitude);
          final x =
              math.cos(currentPoint.latitude) * math.sin(nextPoint.latitude) -
                  math.sin(currentPoint.latitude) *
                      math.cos(nextPoint.latitude) *
                      math.cos(nextPoint.longitude - currentPoint.longitude);
          final routeBearing = math.atan2(y, x) * (180 / math.pi);

          // Normalize to 0-360
          bearing = (routeBearing + 360) % 360;
        }

        center = point;
        if (instruction != null) {
          if (instruction.distance >= _zoomInStart) {
            zoom = _minZoom;
          } else if (instruction.distance <= _zoomInEnd) {
            zoom = _maxZoom;
          } else {
            zoom = _minZoom +
                (_maxZoom - _minZoom) *
                    (1 -
                        (instruction.distance - _zoomInEnd) /
                            (_zoomInStart - _zoomInEnd));
          }
        }
      }
    }

    _animatedController?.animateTo(
        dest: center,
        zoom: zoom,
        rotation: bearing,
        curve: Curves.easeInOut,
        offset: _navigationOffset,
        duration: duration,
        cancelPreviousAnimations: false);
  }

  Map<String, Address> getAddresses() => _addressCoordinates;

  Future<void> _checkRouteDeviation(LatLng position) async {
    final current = state;
    final route = current.route;

    if (route == null || route.waypoints.isEmpty) {
      return;
    }

    final (_, _, distance) = RouteHelpers.findClosestPointOnRoute(
      position,
      route.waypoints,
    );

    // If we're too far from the route and haven't rerouted recently
    if (distance > _offRouteTolerance &&
        (_lastReroute == null ||
            DateTime.now().difference(_lastReroute!) >
                const Duration(seconds: 5))) {
      _lastReroute = DateTime.now();

      if (route.waypoints.isEmpty) {
        return;
      }

      // Find the last instruction point in the route
      final destination = route.waypoints.last;

      // Recalculate route
      await setDestination(destination);
    }
  }

  RouteInstruction? _nextInstruction(Route? route, LatLng position) {
    if (route == null) return null;
    return RouteHelpers.findNextInstruction(position, route);
  }

  void _onGpsData(GpsData data) {
    final current = state;
    final course = (360 - data.course);
    final position = LatLng(data.latitude, data.longitude);
    final instruction = _nextInstruction(current.route, position);

    _moveAndRotate(position, course, instruction: instruction);
    _checkRouteDeviation(position);
    emit(current.copyWith(
      position: position,
      orientation: course,
      nextInstruction: instruction,
    ));
  }

  void _onThemeUpdate(ThemeState event) {
    final current = state;

    emit(MapState.loading(
        controller: state.controller, position: state.position));
    _getTheme(event.isDark).then((theme) => emit(switch (current) {
          MapOffline() => current.copyWith(theme: theme),
          _ => current,
        }));
  }

  void _onMapReady(TickerProvider vsync) {
    final current = state;
    // TODO: the animation shouldn't really be in here, because it's a purely
    //  visual thing and not related to the map state. eventually this should
    //  be moved back into the map widget.
    _animatedController = AnimatedMapController(
        vsync: vsync,
        mapController: current.controller,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut);

    emit(switch (current) {
      MapOffline() => current.copyWith(isReady: true),
      MapOnline() => current.copyWith(isReady: true),
      _ => current,
    });
    _moveAndRotate(current.position, current.orientation);
  }

  Future<Theme> _getTheme(bool isDark) async {
    final mapTheme = isDark ? 'assets/mapdark.json' : 'assets/maplight.json';
    final themeStr = await rootBundle.loadString(mapTheme);

    return ThemeReader().read(jsonDecode(themeStr));
  }

  LatLng _getInitialCoordinates(MbTiles tiles) {
    final meta = tiles.getMetadata();
    final bounds = meta.bounds;
    if (bounds != null &&
        (bounds.left > state.position.longitude ||
            bounds.right < state.position.longitude ||
            bounds.top < state.position.latitude ||
            bounds.bottom > state.position.latitude)) {
      // if current position is out of bounds of the map,
      // use the center of the map instead
      return LatLng(
        (bounds.top + bounds.bottom) / 2,
        (bounds.right + bounds.left) / 2,
      );
    }

    // if no bounds are set, just use the coordinates we were given
    return state.position;
  }

  String _toBase32(int number) {
    const chars = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
    if (number == 0) return '0';
    var result = '';
    while (number > 0) {
      result = chars[number % 32] + result;
      number = number ~/ 32;
    }
    return result;
  }

  Future<void> _loadMap(ThemeState themeState) async {
    _animatedController = null;
    emit(MapState.loading(
        controller: state.controller, position: state.position));
    final theme = await _getTheme(themeState.isDark);
    final ctrl = MapController();

    late final Directory appDir;

    try {
      appDir = await getApplicationDocumentsDirectory();
    } catch (e) {
      emit(MapState.online(
          position: state.position,
          orientation: state.orientation,
          controller: state.controller));
      return;
    }

    final mapPath = '${appDir.path}/maps/map.mbtiles';

    // check if map file exists
    final exists = await File(mapPath).exists();
    if (!exists) {
      emit(MapState.unavailable('Map file not found',
          controller: state.controller, position: state.position));
      return;
    }

    // Initialize MBTiles
    final mbTiles = MbTiles(
      mbtilesPath: mapPath,
      gzip: true,
    );

    _processAddresses(mbTiles);

    emit(MapState.offline(
      mbTiles: mbTiles,
      position: _getInitialCoordinates(mbTiles),
      orientation: 0,
      controller: ctrl,
      theme: theme,
      onReady: _onMapReady,
    ));
  }

  void _processAddresses(MbTiles mbTiles) {
    final coordinates = getTileCoordinatesForBounds(mbTiles, 14);

    for (var coordinate in coordinates) {
      final tile = mbTiles.getTile(x: coordinate.x, y: coordinate.y, z: 14);
      if (tile == null) {
        continue;
      }

      final vectorTile = VectorTile.fromBytes(bytes: tile);
      try {
        final addressesLayer =
            vectorTile.layers.firstWhere((layer) => layer.name == 'addresses');
        final features = addressesLayer.features;
        final extent = addressesLayer.extent;

        for (var feature in features) {
          final geometry = feature.decodeGeometry();
          if (geometry is GeometryPoint) {
            final coordinates = geometry.coordinates;
            // Convert from tile coordinates to geographic coordinates
            final n = math.pow(2.0, 14).toDouble();
            final lon =
                (coordinate.x + coordinates[0] / extent) / n * 360.0 - 180.0;
            final y = 1 -
                (coordinate.y + coordinates[1] / extent) / n; // Flip y for TMS
            final z = math.pi * (1 - 2 * y);
            final latRad = math.atan((math.exp(z) - math.exp(-z)) / 2);
            final lat = latRad * 180.0 / math.pi;

            // Assign ID and create mapping
            final id = _currentAddressId++;
            final base32Id = _toBase32(id);
            _addressCoordinates[base32Id] = Address(
                id: base32Id,
                coordinates: LatLng(lat, lon),
                x: coordinates[0],
                y: coordinates[1]);
          }
        }
      } on StateError {
        continue;
      }
    }
  }
}

List<Point<int>> getTileCoordinatesForBounds(MbTiles tiles, int zoom) {
  final meta = tiles.getMetadata();
  final bounds = meta.bounds;
  if (bounds == null) {
    throw Exception('No bounds found in MBTiles metadata');
  }

  final minTileX = _lonToTileX(bounds.left, zoom);
  final maxTileX = _lonToTileX(bounds.right, zoom);
  final minTileY = _latToTileYTMS(bounds.top, zoom);
  final maxTileY = _latToTileYTMS(bounds.bottom, zoom);
  final coordinates = <Point<int>>[];

  for (var x = minTileX; x <= maxTileX; x++) {
    final startY = math.min(minTileY, maxTileY);
    final endY = math.max(minTileY, maxTileY);

    for (var y = startY; y <= endY; y++) {
      coordinates.add(Point(x, y));
    }
  }

  return coordinates;
}

int _lonToTileX(double lon, int zoom) {
  final x = ((lon + 180) / 360 * (1 << zoom)).floor();
  return x;
}

int _latToTileYTMS(double lat, int zoom) {
  final latRad = lat * (math.pi / 180);
  final n = math.pow(2.0, zoom).toDouble();
  final y =
      (1.0 - math.log(math.tan(latRad) + 1.0 / math.cos(latRad)) / math.pi) /
          2.0 *
          n;
  final tmsY = (n - 1 - y).floor();
  return tmsY + 1;
}
