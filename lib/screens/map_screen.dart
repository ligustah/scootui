import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scooter_cluster/cubits/mdb_cubits.dart';
import 'package:scooter_cluster/widgets/general/control_gestures_detector.dart';

import '../cubits/map_cubit.dart';
import '../cubits/theme_cubit.dart';
import '../state/vehicle.dart';
import '../widgets/map/address_selection.dart';
import '../widgets/map/map_view.dart';
import '../widgets/status_bars/map_bottom_status_bar.dart';
import '../widgets/status_bars/top_status_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isSelectingDestination = false;

  @override
  Widget build(BuildContext context) {
    final ThemeState(:theme) = ThemeCubit.watch(context);

    return Container(
      width: 480,
      height: 480,
      color: theme.scaffoldBackgroundColor,
      child: _isSelectingDestination
          ? _destinationSelector(theme, context.read<VehicleSync>().stream,
              context.watch<MapCubit>().state)
          : _mapView(theme, context.read<VehicleSync>().stream,
              context.watch<MapCubit>().state),
    );
  }

  Widget _destinationSelector(
      ThemeData theme, Stream<VehicleData> vehicleStream, MapState mapState) {
    return AddressSelection(
      onSubmit: (code) {
        context.read<MapCubit>().setDestinationAddress(code);
        setState(() => _isSelectingDestination = false);
      },
      onCancel: () => setState(() => _isSelectingDestination = false),
    );
  }

  Widget _mapView(
      ThemeData theme, Stream<VehicleData> vehicleStream, MapState mapState) {
    return ControlGestureDetector(
      stream: vehicleStream,
      onRightDoubleTap: () => setState(() => _isSelectingDestination = true),
      child: Column(
        children: [
          // Top status bar
          StatusBar(),

          // Map view
          Expanded(
            child: _buildMap(context, mapState, theme),
          ),

          // Bottom status bar with speed
          MapBottomStatusBar(),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context, MapState mapState, ThemeData theme) =>
      switch (mapState) {
        MapLoading() => const Center(child: CircularProgressIndicator()),
        MapUnavailable(:final error) => Center(
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
                    error,
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please install the map data to use this feature',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        MapOnline(
          :final position,
          :final controller,
          :final onReady,
          :final orientation,
        ) =>
          OnlineMapView(
            mapController: controller,
            position: position,
            mapReady: onReady,
            orientation: orientation,
          ),
        MapOffline(
          :final mbTiles,
          :final position,
          :final controller,
          :final theme,
          :final onReady,
          :final orientation,
          :final route,
          :final nextInstruction,
          :final destination,
        ) =>
          OfflineMapView(
            mbTiles: mbTiles,
            mapController: controller,
            theme: theme,
            position: position,
            mapReady: onReady,
            orientation: orientation,
            route: route,
            setDestination: context.read<MapCubit>().setDestination,
            nextInstruction: nextInstruction,
            destination: destination,
          ),
      };
}
