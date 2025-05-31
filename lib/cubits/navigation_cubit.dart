import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../config.dart';
import '../routing/route_helpers.dart';
import '../routing/valhalla.dart';
import '../state/gps.dart';
import '../state/navigation.dart';
import 'mdb_cubits.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  late final StreamSubscription<GpsData> _gpsSub;
  late final StreamSubscription<NavigationData> _navigationSub;
  final NavigationSync _navigationSync;

  static const double _arrivalProximityMeters = 100.0;
  static const double _offRouteTolerance = 50.0; // 50 meters
  DateTime? _lastReroute;
  LatLng? _currentPosition;

  final distanceCalculator = Distance();

  NavigationCubit({
    required Stream<GpsData> gpsStream,
    required NavigationSync navigationSync,
  })  : _navigationSync = navigationSync,
        super(const NavigationState()) {
    _gpsSub = gpsStream.listen(_onGpsData);
    _navigationSub = _navigationSync.stream.listen(_onNavigationData);

    // Process initial navigation data if available
    _processInitialNavigationData();
  }

  @override
  Future<void> close() {
    _gpsSub.cancel();
    _navigationSub.cancel();
    return super.close();
  }

  void _processInitialNavigationData() {
    final initialData = _navigationSync.state;
    if (initialData.destination.isNotEmpty) {
      _onNavigationData(initialData);
    }
  }

  Future<void> _calculateRoute(LatLng destination) async {
    emit(state.copyWith(
      destination: destination,
      status: NavigationStatus.calculating,
      error: null,
    ));

    try {
      final position = _currentPosition;
      if (position == null) {
        emit(state.copyWith(
          status: NavigationStatus.error,
          error: 'Current position not available',
        ));
        return;
      }

      final valhallaService = ValhallaService(serverURL: AppConfig.valhallaEndpoint);
      final route = await valhallaService.getRoute(position, destination);

      if (route.waypoints.isEmpty) {
        emit(state.copyWith(
          status: NavigationStatus.error,
          error: 'Could not calculate route',
        ));
        return;
      }

      final nextInstruction = route.instructions.isNotEmpty ? route.instructions.first : null;
      final distanceToDestination = distanceCalculator.as(
        LengthUnit.Meter,
        position,
        destination,
      );

      emit(state.copyWith(
        route: route,
        nextInstruction: nextInstruction,
        status: NavigationStatus.navigating,
        distanceToDestination: distanceToDestination,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NavigationStatus.error,
        error: 'Failed to calculate route: $e',
      ));
    }
  }

  Future<void> clearNavigation() async {
    emit(const NavigationState());
    await _navigationSync.clearDestination();
  }

  void _onNavigationData(NavigationData data) {
    print("NavigationCubit: Received NavigationData: ${data.destination}");
    try {
      if (data.destination.isEmpty) {
        print("NavigationCubit: Destination is empty, clearing navigation state.");
        // Clear navigation if destination is empty
        emit(const NavigationState());
        return;
      }

      final coordinates = data.destination.split(",").map(double.parse).toList();
      final destination = LatLng(coordinates[0], coordinates[1]);
      print("NavigationCubit: Parsed destination: $destination");

      if (_currentPosition == null) {
        print("NavigationCubit: Current position is null, cannot calculate route yet.");
        // Optionally, store pending destination if needed, or rely on next GPS update
        emit(state.copyWith(
            destination: destination, status: NavigationStatus.idle, error: "Waiting for GPS fix to calculate route."));
        return;
      }

      if (state.destination == destination && state.status == NavigationStatus.navigating) {
        print("NavigationCubit: Destination is the same and already navigating.");
        return;
      }

      print(
          "NavigationCubit: Current position: $_currentPosition. New destination: $destination. Current state destination: ${state.destination}");
      // Only start navigation if we have a current position and it's a new destination or not yet navigating
      if (_currentPosition != null &&
          (state.destination != destination ||
              state.status == NavigationStatus.idle ||
              state.status == NavigationStatus.error)) {
        print("NavigationCubit: Conditions met, calling _calculateRoute for $destination");
        _calculateRoute(destination);
      } else {
        print(
            "NavigationCubit: Conditions not met for route calculation. CurrentPos: $_currentPosition, state.dest: ${state.destination}, new dest: $destination, status: ${state.status}");
      }
    } catch (e) {
      print("NavigationCubit: Error processing navigation data: $e");
      emit(state.copyWith(
        status: NavigationStatus.error,
        error: 'Error processing navigation data: $e',
      ));
    }
  }

  void _onGpsData(GpsData data) {
    final position = LatLng(data.latitude, data.longitude);
    _currentPosition = position;

    final currentState = state;

    // If we're not navigating, just update position
    if (!currentState.isNavigating || currentState.route == null) {
      return;
    }

    // Update navigation state based on current position
    _updateNavigationState(position);
  }

  void _updateNavigationState(LatLng position) {
    final route = state.route;
    final destination = state.destination;

    if (route == null || destination == null) {
      return;
    }

    // Calculate distance to destination
    final distanceToDestination = distanceCalculator.as(
      LengthUnit.Meter,
      position,
      destination,
    );

    // Check if we've arrived
    if (distanceToDestination < _arrivalProximityMeters) {
      emit(state.copyWith(
        status: NavigationStatus.arrived,
        distanceToDestination: distanceToDestination,
      ));
      return;
    }

    // Find closest point on route and check for deviation
    final (closestPoint, segmentIndex, distanceFromRoute) = RouteHelpers.findClosestPointOnRoute(
      position,
      route.waypoints,
    );

    // Check if we're off route
    final isOffRoute = distanceFromRoute > _offRouteTolerance;

    // Find next instruction
    final nextInstruction = RouteHelpers.findNextInstruction(position, route);

    emit(state.copyWith(
      nextInstruction: nextInstruction,
      distanceToDestination: distanceToDestination,
      distanceFromRoute: distanceFromRoute,
      isOffRoute: isOffRoute,
    ));

    // Check if we need to reroute
    if (isOffRoute && (_lastReroute == null || DateTime.now().difference(_lastReroute!) > const Duration(seconds: 5))) {
      _reroute(position, destination);
    }
  }

  Future<void> _reroute(LatLng position, LatLng destination) async {
    _lastReroute = DateTime.now();

    emit(state.copyWith(status: NavigationStatus.rerouting));

    try {
      final valhallaService = ValhallaService(serverURL: AppConfig.valhallaEndpoint);
      final route = await valhallaService.getRoute(position, destination);

      if (route.waypoints.isEmpty) {
        emit(state.copyWith(
          status: NavigationStatus.error,
          error: 'Could not calculate new route',
        ));
        return;
      }

      final nextInstruction = route.instructions.isNotEmpty ? route.instructions.first : null;
      final distanceToDestination = distanceCalculator.as(
        LengthUnit.Meter,
        position,
        destination,
      );

      emit(state.copyWith(
        route: route,
        nextInstruction: nextInstruction,
        status: NavigationStatus.navigating,
        distanceToDestination: distanceToDestination,
        distanceFromRoute: 0.0,
        isOffRoute: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NavigationStatus.error,
        error: 'Failed to reroute: $e',
      ));
    }
  }
}
