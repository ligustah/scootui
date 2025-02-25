import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart' as vtr;
import 'package:vector_map_tiles_mbtiles/vector_map_tiles_mbtiles.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/vehicle_state.dart';
import '../widgets/status_bars/top_status_bar.dart';
import '../widgets/status_bars/map_bottom_status_bar.dart';
import '../services/map_service.dart';

class MapScreen extends StatefulWidget {
  final VehicleState vehicleState;
  final String currentTime;

  const MapScreen({
    super.key,
    required this.vehicleState,
    required this.currentTime,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  MbTiles? _mbtiles;
  vtr.Theme? _theme;
  Object? _error;
  Brightness? _currentTheme;
  bool _isMapAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkMapAvailability();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMapTheme();
  }

  Future<void> _checkMapAvailability() async {
    final isAvailable = await MapService.isMapAvailable();
    setState(() {
      _isMapAvailable = isAvailable;
    });
    if (isAvailable) {
      _initMap();
    }
  }

  Future<void> _updateMapTheme() async {
    try {
      final newTheme = Theme.of(context).brightness;
      // Only update if the theme has actually changed
      if (_currentTheme == newTheme) {
        return;
      }
      _currentTheme = newTheme;
      
      print('Theme changed to: ${newTheme == Brightness.dark ? "dark" : "light"}');
      
      // Dispose of existing resources
      _mbtiles?.dispose();
      _mbtiles = null;
      _theme = null;

      // Reinitialize the map
      await _initMap();
    } catch (e, stack) {
      print('Map theme update error: $e\n$stack');
      setState(() {
        _error = e;
      });
    }
  }

  Future<void> _initMap() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      print('Application Documents Directory: ${appDir.path}');
      final mapPath = '${appDir.path}/maps/map.mbtiles';
      print('MBTiles path: $mapPath');
      
      // Ensure directory exists
      await Directory('${appDir.path}/maps').create(recursive: true);

      // Initialize MBTiles
      _mbtiles = MbTiles(
        mbtilesPath: mapPath,
        gzip: true,
      );

      // Load theme file based on current brightness
      final isDark = Theme.of(context).brightness == Brightness.dark;
      _currentTheme = Theme.of(context).brightness;
      final themeStr = await rootBundle.loadString(
        isDark ? 'assets/mapdark.json' : 'assets/maplight.json',
      );
      _theme = vtr.ThemeReader().read(jsonDecode(themeStr));

      setState(() {});
    } catch (e, stack) {
      print('Map init error: $e\n$stack');
      setState(() {
        _error = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      height: 480,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Top status bar
          StatusBar(
            state: widget.vehicleState,
            currentTime: widget.currentTime,
          ),

          // Map view
          Expanded(
            child: _buildMap(),
          ),

          // Bottom status bar with speed
          MapBottomStatusBar(
            state: widget.vehicleState,
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    if (!_isMapAvailable) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Map data is not available',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please install the map data to use this feature',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(child: Text('Error loading map: $_error'));
    }

    if (_mbtiles == null || _theme == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FlutterMap(
      mapController: _mapController,
      options: const MapOptions(
        initialCenter: LatLng(52.5200, 13.4050),
        initialZoom: 18.0,
        minZoom: 8,
        maxZoom: 18,
      ),
      children: [
        VectorTileLayer(
          theme: _theme!,
          tileProviders: TileProviders({
            'versatiles-shortbread': MbTilesVectorTileProvider(
              mbtiles: _mbtiles!,
              silenceTileNotFound: true,
            ),
          }),
          maximumZoom: 18,
          // Set minimal cache settings to prevent theme persistence
          fileCacheTtl: const Duration(seconds: 1),
          memoryTileCacheMaxSize: 0,  // Disable memory tile cache
          memoryTileDataCacheMaxSize: 0,  // Disable memory tile data cache
          fileCacheMaximumSizeInBytes: 1024 * 1024,  // 1MB file cache
          // Force immediate tile updates
          tileDelay: Duration.zero,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _mbtiles?.dispose();
    super.dispose();
  }
} 
