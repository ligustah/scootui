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
import 'dart:math' as math;
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

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  MbTiles? _mbtiles;
  vtr.Theme? _theme;
  Object? _error;
  Brightness? _currentTheme;
  bool _isMapAvailable = false;
  bool _isFollowingLocation = true; // Always follow location now
  Marker? _locationMarker;
  bool _isMapInitialized = false;
  
  // Position interpolation
  LatLng _currentPosition = const LatLng(52.5200, 13.4050); // Default position (Berlin)
  LatLng _targetPosition = const LatLng(52.5200, 13.4050);
  late AnimationController _animationController;
  double _lastLat = 0.0;
  double _lastLng = 0.0;
  double _lastCourse = 0.0;
  double _currentRotation = 0.0;
  double _targetRotation = 0.0;
  
  // Map view offset - moves the center point toward the bottom of the screen
  // to show more of the upcoming road (value between 0.0 and 1.0)
  // This creates a "look-ahead" effect similar to navigation apps, where the vehicle
  // position is placed lower on the screen to show more of the road ahead
  final double _mapCenterOffset = 0.4; // 40% offset from center toward bottom
  
  // Calculate the actual position offset based on the course
  LatLng _calculatePositionWithOffset(LatLng position, double courseRadians, double distanceInMeters) {
    // Earth's radius in meters
    const double earthRadius = 6378137.0;
    
    // Calculate the offset distance in latitude and longitude
    final double latOffset = (distanceInMeters * math.cos(courseRadians)) / earthRadius;
    final double lngOffset = (distanceInMeters * math.sin(courseRadians)) / 
                            (earthRadius * math.cos(position.latitude * math.pi / 180));
    
    // Convert to degrees and apply offset
    return LatLng(
      position.latitude + (latOffset * 180 / math.pi),
      position.longitude + (lngOffset * 180 / math.pi)
    );
  }

  @override
  void initState() {
    super.initState();
    _checkMapAvailability();
    
    // Initialize animation controller for smooth movement
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // 1 second interpolation
    );
    
    _animationController.addListener(_updateMapPositionInterpolated);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMapTheme();
  }

  @override
  void didUpdateWidget(MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update map position when GPS coordinates change
    if (widget.vehicleState.hasGpsSignal && _isMapInitialized) {
      // Only start a new animation if the coordinates or course have changed significantly
      if (_lastLat != widget.vehicleState.gpsLatitude || 
          _lastLng != widget.vehicleState.gpsLongitude ||
          _shouldUpdateRotation()) {
        _startPositionAnimation();
      }
    }
  }
  
  bool _shouldUpdateRotation() {
    // Only update rotation if course has changed by more than 5 degrees
    return (widget.vehicleState.gpsCourse - _lastCourse).abs() > 5.0;
  }
  
  void _startPositionAnimation() {
    if (!widget.vehicleState.hasGpsSignal || !_isMapInitialized) return;
    
    try {
      // Save current position as starting point
      _currentPosition = _mapController.camera.center;
      _currentRotation = _mapController.camera.rotation;
      
      // Set target position from GPS data
      final actualPosition = LatLng(
        widget.vehicleState.gpsLatitude,
        widget.vehicleState.gpsLongitude,
      );
      
      // Set target rotation from GPS course
      // GPS course is in degrees from north (0-360), map rotation is in degrees clockwise
      // We need to invert the course for the map rotation (e.g., course of 90° means heading east,
      // but for the map to show heading east, we need to rotate it to -90° or 270°)
      _targetRotation = (360 - widget.vehicleState.gpsCourse) % 360;
      
      // Calculate the offset position to show more of the upcoming road
      // Convert course to radians and adjust for the map rotation
      final courseRadians = widget.vehicleState.gpsCourse * (math.pi / 180);
      
      // Apply offset in the direction of travel (about 50 meters ahead)
      _targetPosition = _calculatePositionWithOffset(actualPosition, courseRadians, 100.0 * _mapCenterOffset);
      
      // Save last coordinates and course to avoid unnecessary animations
      _lastLat = widget.vehicleState.gpsLatitude;
      _lastLng = widget.vehicleState.gpsLongitude;
      _lastCourse = widget.vehicleState.gpsCourse;
      
      // Reset and start animation
      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      print('Animation error: $e');
      // If there's an error with the animation, fall back to direct positioning
      _updateMapPositionDirect();
    }
  }
  
  void _updateMapPositionInterpolated() {
    if (!_isMapAvailable || !_isMapInitialized) return;
    
    try {
      // Calculate interpolated position
      final double t = _animationController.value;
      final double lat = _currentPosition.latitude + 
          (_targetPosition.latitude - _currentPosition.latitude) * t;
      final double lng = _currentPosition.longitude + 
          (_targetPosition.longitude - _currentPosition.longitude) * t;
      
      // Calculate interpolated rotation
      // Find the shortest path for rotation (to avoid spinning around)
      double rotationDiff = _targetRotation - _currentRotation;
      if (rotationDiff > 180) rotationDiff -= 360;
      if (rotationDiff < -180) rotationDiff += 360;
      final double rotation = _currentRotation + rotationDiff * t;
      
      final interpolatedPosition = LatLng(lat, lng);
      
      // Calculate the actual GPS position (without offset) for the marker
      // We need to reverse the offset calculation to get the real position
      final courseRadians = ((360 - rotation) % 360) * (math.pi / 180);
      final actualGpsPosition = _calculatePositionWithOffset(interpolatedPosition, courseRadians + math.pi, 100.0 * _mapCenterOffset);
      
      // Update the map position and rotation
      _mapController.moveAndRotate(interpolatedPosition, _mapController.camera.zoom, rotation);
      
      // Update the location marker at the actual GPS position
      setState(() {
        _locationMarker = Marker(
          width: 30.0,
          height: 30.0,
          point: actualGpsPosition,
          alignment: Alignment.center, // Center the marker
          child: Transform.rotate(
            angle: -rotation * (math.pi / 180), // Convert to radians and negate to counter map rotation
            child: const Icon(
              Icons.navigation,
              color: Colors.blue,
              size: 30.0,
            ),
          ),
        );
      });
    } catch (e) {
      print('Interpolation error: $e');
    }
  }

  void _updateMapPositionDirect() {
    if (!widget.vehicleState.hasGpsSignal || !_isMapAvailable || !_isMapInitialized) {
      return;
    }

    try {
      // Get the actual GPS position
      final actualPosition = LatLng(
        widget.vehicleState.gpsLatitude,
        widget.vehicleState.gpsLongitude,
      );
      
      _lastLat = widget.vehicleState.gpsLatitude;
      _lastLng = widget.vehicleState.gpsLongitude;
      _lastCourse = widget.vehicleState.gpsCourse;

      // Invert the course for the map rotation
      final mapRotation = (360 - _lastCourse) % 360;
      
      // Calculate the offset position to show more of the upcoming road
      final courseRadians = _lastCourse * (math.pi / 180);
      final offsetPosition = _calculatePositionWithOffset(actualPosition, courseRadians, 100.0 * _mapCenterOffset);

      // Update the map position and rotation
      _mapController.moveAndRotate(offsetPosition, _mapController.camera.zoom, mapRotation);
      
      // Update the location marker at the actual GPS position
      setState(() {
        _locationMarker = Marker(
          width: 30.0,
          height: 30.0,
          point: actualPosition,
          alignment: Alignment.center, // Center the marker
          child: Transform.rotate(
            angle: -mapRotation * (math.pi / 180), // Convert to radians and negate to counter map rotation
            child: const Icon(
              Icons.navigation,
              color: Colors.blue,
              size: 30.0,
            ),
          ),
        );
      });
    } catch (e) {
      print('Direct position update error: $e');
    }
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
      
      // Store initial GPS position for when the map is ready
      if (widget.vehicleState.hasGpsSignal) {
        _lastLat = widget.vehicleState.gpsLatitude;
        _lastLng = widget.vehicleState.gpsLongitude;
        _lastCourse = widget.vehicleState.gpsCourse;
        _currentPosition = LatLng(_lastLat, _lastLng);
        
        // Apply offset to initial position
        final courseRadians = _lastCourse * (math.pi / 180);
        _targetPosition = _calculatePositionWithOffset(
          _currentPosition, 
          courseRadians, 
          100.0 * _mapCenterOffset
        );
        
        _currentRotation = (360 - _lastCourse) % 360;
        _targetRotation = _currentRotation;
      }
      
      // We'll set _isMapInitialized to true in the onMapReady callback
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

    // Default position (Berlin) if no GPS data
    final initialPosition = widget.vehicleState.hasGpsSignal
        ? LatLng(widget.vehicleState.gpsLatitude, widget.vehicleState.gpsLongitude)
        : const LatLng(52.5200, 13.4050);
    
    // Initial rotation from GPS course if available (inverted)
    final initialRotation = widget.vehicleState.hasGpsSignal
        ? (360 - widget.vehicleState.gpsCourse) % 360
        : 0.0;
        
    // Apply offset to initial position if GPS is available
    LatLng mapCenterPosition = initialPosition;
    if (widget.vehicleState.hasGpsSignal) {
      final courseRadians = widget.vehicleState.gpsCourse * (math.pi / 180);
      mapCenterPosition = _calculatePositionWithOffset(
        initialPosition, 
        courseRadians, 
        100.0 * _mapCenterOffset
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: mapCenterPosition,
        initialZoom: 18.0,
        minZoom: 8,
        maxZoom: 18,
        initialRotation: initialRotation,
        onMapReady: () {
          // Map is now ready and controller is initialized
          setState(() {
            _isMapInitialized = true;
          });
          
          // Now it's safe to update the map position
          if (widget.vehicleState.hasGpsSignal) {
            _updateMapPositionDirect();
          }
        },
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
        // Add location marker if GPS signal is available
        if (_locationMarker != null)
          MarkerLayer(
            markers: [_locationMarker!],
          ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapController.dispose();
    _mbtiles?.dispose();
    super.dispose();
  }
} 
