import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scooter_cluster/cubits/mdb_cubits.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

import '../state/gps.dart';

part 'map_cubit.freezed.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  late final StreamSubscription<GpsData> _sub;

  static MapCubit create(BuildContext context) =>
      MapCubit(context.read<GpsSync>().stream).._loadMap();

  MapCubit(Stream<GpsData> stream) : super(MapInitial()) {
    _sub = stream.listen(_onGpsData);
  }

  @override
  Future<void> close() {
    final current = state;
    if (current is MapLoaded) {
      current.controller.dispose();
      current.mbTiles.dispose();
    }
    _sub.cancel();
    return super.close();
  }

  void _moveAndRotate(LatLng center, double course) {
    final current = state;
    if (current is! MapLoaded) return;

    current.controller
        .move(center, current.controller.camera.zoom, offset: Offset(0, 100));
    current.controller.rotateAroundPoint(course, offset: Offset(0, 100));
  }

  void _onGpsData(GpsData data) {
    final current = state;
    if (current is! MapLoaded) return;

    final course = (360 - data.course);
    final position = LatLng(data.latitude, data.longitude);

    _moveAndRotate(position, course);
    emit(current.copyWith(
      position: position,
      orientation: course,
    ));
  }

  void _onMapReady() {
    final current = state;
    if (current is! MapLoaded) return;

    _moveAndRotate(current.position, 0);
    emit(current.copyWith(isReady: true));
  }

  Future<void> _loadMap() async {
    emit(MapState.loading());

    final appDir = await getApplicationDocumentsDirectory();
    final mapPath = '${appDir.path}/maps/map.mbtiles';

    // check if map file exists
    final exists = await File(mapPath).exists();
    if (!exists) {
      emit(MapState.unavailable('Map file not found'));
      return;
    }

    // Initialize MBTiles
    final mbTiles = MbTiles(
      mbtilesPath: mapPath,
      gzip: true,
    );

    final meta = mbTiles.getMetadata();
    final initialCoordinates = meta.defaultCenter != null
        ? meta.defaultCenter!
        : (meta.bounds != null
            ? LatLng(
                (meta.bounds!.right + meta.bounds!.left) / 2,
                (meta.bounds!.top + meta.bounds!.bottom) / 2,
              )
            : LatLng(0, 0));

    final themeStr = await rootBundle.loadString('assets/mapdark.json');
    final theme = ThemeReader().read(jsonDecode(themeStr));

    final ctrl = MapController();

    emit(MapState.loaded(
      mbTiles: mbTiles,
      position: initialCoordinates,
      orientation: 0,
      controller: ctrl,
      theme: theme,
      onReady: _onMapReady,
    ));
  }
}
