import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/map_cubit.dart'; // Keep for map display
import '../cubits/navigation_cubit.dart'; // Added for listening to navigation state
import '../cubits/navigation_state.dart'; // Added
import '../cubits/theme_cubit.dart';
import '../widgets/map/map_view.dart';
import '../widgets/navigation/turn_by_turn_widget.dart'; // Added
import '../widgets/ota_info_widget.dart';
import '../widgets/status_bars/map_bottom_status_bar.dart';
import '../widgets/status_bars/top_status_bar.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeState(:theme) = ThemeCubit.watch(context);
    final MapCubit(:state) = context.watch<MapCubit>();

    return Container(
      width: 480,
      height: 480,
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          Column(
            children: [
              // Top status bar
              StatusBar(),

              // Map view
              Expanded(
                child: _buildMap(context, state, theme),
              ),

              // Bottom status bar with speed
              MapBottomStatusBar(),
            ],
          ),

          // Turn-by-turn instructions
          Positioned(
            top: 60, // Adjust as needed
            left: 10,
            right: 10,
            child: TurnByTurnWidget(),
          ),

          // OTA info widget (will only show when in minimal mode)
          const OtaInfoWidget(),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context, MapState mapState, ThemeData theme) {
    // Listen to NavigationState to get the route for drawing
    final navState = context.watch<NavigationCubit>().state;

    return switch (mapState) {
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
          route: navState.route, // Pass route from NavigationCubit
          destination: navState.destination, // Pass destination from NavigationCubit
        ),
      MapOffline(
        :final tiles,
        :final position,
        :final controller,
        :final theme,
        :final onReady,
        :final orientation,
      ) =>
        OfflineMapView(
          tiles: tiles,
          mapController: controller,
          theme: theme,
          position: position,
          mapReady: onReady,
          orientation: orientation,
          route: navState.route, // Pass route from NavigationCubit
          destination: navState.destination, // Pass destination from NavigationCubit
          // setDestination is now handled by tapping on map, which should trigger Redis update
          // The MapCubit no longer handles setDestination directly.
          // The OfflineMapView's onSecondaryTap will need to be updated
          // to interact with MDBRepository directly if that's the desired behavior.
          // For now, removing direct setDestination from MapCubit.
        ),
    };
  }
}
