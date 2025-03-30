import 'package:flutter/material.dart'
    show Alignment, BuildContext, Colors, Icon, Icons, StatelessWidget, Widget;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_map_tiles_mbtiles/vector_map_tiles_mbtiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

class MapView extends StatelessWidget {
  final MapController mapController;
  final Theme theme;
  final MbTiles mbTiles;
  final LatLng position;
  final double maxZoom;
  final double minZoom;
  final void Function()? mapReady;

  const MapView({
    super.key,
    required this.mapController,
    required this.theme,
    required this.mbTiles,
    required this.position,
    required this.maxZoom,
    required this.minZoom,
    this.mapReady,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        onMapReady: mapReady,
        minZoom: minZoom,
        maxZoom: maxZoom,

        initialCenter: position,
        initialZoom: maxZoom,
      ),
      mapController: mapController,
      children: [
        VectorTileLayer(
          theme: theme,
          tileProviders: TileProviders({
            'versatiles-shortbread': MbTilesVectorTileProvider(
              mbtiles: mbTiles,
              silenceTileNotFound: true,
            ),
          }),
          maximumZoom: maxZoom.toDouble(),
          // Set minimal cache settings to prevent theme persistence
          fileCacheTtl: const Duration(seconds: 1),
          memoryTileCacheMaxSize: 0,
          // Disable memory tile cache
          memoryTileDataCacheMaxSize: 0,
          // Disable memory tile data cache
          fileCacheMaximumSizeInBytes: 1024 * 1024,
          // 1MB file cache
          // Force immediate tile updates
          tileDelay: Duration.zero,
        ),
        MarkerLayer(markers: [
          Marker(
            width: 30.0,
            height: 30.0,
            point: position,
            alignment: Alignment.center,
            child: const Icon(
              Icons.navigation,
              color: Colors.blue,
              size: 30.0,
            ),
          ),
        ]),
      ],
    );
  }
}
