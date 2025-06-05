import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../config.dart';
import '../routing/models.dart';
import '../routing/route_helpers.dart';
import '../routing/valhalla.dart';
import '../services/toast_service.dart';
import '../state/gps.dart';
import '../state/navigation.dart';
import 'mdb_cubits.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  late final StreamSubscription<GpsData> _gpsSub;
  late final StreamSubscription<NavigationData> _navigationSub;
  final NavigationSync _navigationSync;

  static const double _arrivalProximityMeters = 100.0;
  static const double _offRouteTolerance = 40.0; // meters
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
        const errorMsg = 'Current position not available';
        ToastService.showError(errorMsg);
        emit(state.copyWith(
          status: NavigationStatus.error,
          error: errorMsg,
        ));
        return;
      }

      final valhallaService = ValhallaService(serverURL: AppConfig.valhallaEndpoint);
      final route = await valhallaService.getRoute(position, destination);

      if (route.waypoints.isEmpty) {
        const errorMsg = 'Could not calculate route';
        ToastService.showError(errorMsg);
        emit(state.copyWith(
          status: NavigationStatus.error,
          error: errorMsg,
        ));
        return;
      }

      final upcomingInstructions = RouteHelpers.findUpcomingInstructions(position, route);
      final distanceToDestination = distanceCalculator.as(
        LengthUnit.Meter,
        position,
        destination,
      );

      emit(state.copyWith(
        route: route,
        upcomingInstructions: upcomingInstructions,
        status: NavigationStatus.navigating,
        distanceToDestination: distanceToDestination,
        error: null,
      ));
    } catch (e) {
      final errorMsg = 'Failed to calculate route: $e';
      ToastService.showError(errorMsg);
      emit(state.copyWith(
        status: NavigationStatus.error,
        error: errorMsg,
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
        ToastService.showInfo('New navigation destination received. Calculating route...');
        _calculateRoute(destination);
      } else {
        print(
            "NavigationCubit: Conditions not met for route calculation. CurrentPos: $_currentPosition, state.dest: ${state.destination}, new dest: $destination, status: ${state.status}");
      }
    } catch (e) {
      print("NavigationCubit: Error processing navigation data: $e");
      final errorMsg = 'Error processing navigation data: $e';
      ToastService.showError(errorMsg);
      emit(state.copyWith(
        status: NavigationStatus.error,
        error: errorMsg,
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
      ToastService.showSuccess('You have arrived at your destination!');
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

    // Debug logging for off-route detection
    print(
        "NavigationCubit: Position: $position, Distance from route: ${distanceFromRoute.toStringAsFixed(1)}m, Tolerance: ${_offRouteTolerance}m");

    // Check if we're off route
    final isOffRoute = distanceFromRoute > _offRouteTolerance;
    print("NavigationCubit: isOffRoute: $isOffRoute, current state isOffRoute: ${state.isOffRoute}");

    // Find upcoming instructions
    var upcomingInstructions = RouteHelpers.findUpcomingInstructions(position, route);

    // If off-route, insert a "return to route" instruction at the beginning
    if (isOffRoute) {
      final returnInstruction = RouteInstruction.other(
        distance: distanceFromRoute,
        location: closestPoint,
        originalShapeIndex: 0,
        instructionText: "Return to the route",
      );
      upcomingInstructions = [returnInstruction, ...upcomingInstructions];
      print(
          "NavigationCubit: Added return instruction. First instruction: ${upcomingInstructions.first.instructionText}, distance: ${upcomingInstructions.first.distance}");
    }

    emit(state.copyWith(
      upcomingInstructions: upcomingInstructions,
      distanceToDestination: distanceToDestination,
      distanceFromRoute: distanceFromRoute,
      isOffRoute: isOffRoute,
    ));

    // Check if we need to reroute
    if (isOffRoute && (_lastReroute == null || DateTime.now().difference(_lastReroute!) > const Duration(seconds: 5))) {
      ToastService.showWarning('Off route. Attempting to reroute...');
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
        const errorMsg = 'Could not calculate new route';
        ToastService.showError(errorMsg);
        emit(state.copyWith(
          status: NavigationStatus.error,
          error: errorMsg,
        ));
        return;
      }

      emit(state.copyWith(
        route: route,
        status: NavigationStatus.navigating,
        error: null,
      ));

      // Recalculate navigation state with the new route
      _updateNavigationState(position);
    } catch (e) {
      final errorMsg = 'Failed to reroute: $e';
      ToastService.showError(errorMsg);
      emit(state.copyWith(
        status: NavigationStatus.error,
        error: errorMsg,
      ));
    }
  }
}
