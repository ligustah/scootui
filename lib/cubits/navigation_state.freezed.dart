// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'navigation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NavigationState {
  Route? get route;
  RouteInstruction? get currentInstruction;
  List<RouteInstruction> get upcomingInstructions;
  LatLng? get destination;
  NavigationStatus get status;
  String? get error;
  double get distanceToDestination;
  double get distanceFromRoute;
  bool get isOffRoute;
  LatLng? get snappedPosition;

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavigationStateCopyWith<NavigationState> get copyWith =>
      _$NavigationStateCopyWithImpl<NavigationState>(
          this as NavigationState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavigationState &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.currentInstruction, currentInstruction) ||
                other.currentInstruction == currentInstruction) &&
            const DeepCollectionEquality()
                .equals(other.upcomingInstructions, upcomingInstructions) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.distanceToDestination, distanceToDestination) ||
                other.distanceToDestination == distanceToDestination) &&
            (identical(other.distanceFromRoute, distanceFromRoute) ||
                other.distanceFromRoute == distanceFromRoute) &&
            (identical(other.isOffRoute, isOffRoute) ||
                other.isOffRoute == isOffRoute) &&
            (identical(other.snappedPosition, snappedPosition) ||
                other.snappedPosition == snappedPosition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      route,
      currentInstruction,
      const DeepCollectionEquality().hash(upcomingInstructions),
      destination,
      status,
      error,
      distanceToDestination,
      distanceFromRoute,
      isOffRoute,
      snappedPosition);

  @override
  String toString() {
    return 'NavigationState(route: $route, currentInstruction: $currentInstruction, upcomingInstructions: $upcomingInstructions, destination: $destination, status: $status, error: $error, distanceToDestination: $distanceToDestination, distanceFromRoute: $distanceFromRoute, isOffRoute: $isOffRoute, snappedPosition: $snappedPosition)';
  }
}

/// @nodoc
abstract mixin class $NavigationStateCopyWith<$Res> {
  factory $NavigationStateCopyWith(
          NavigationState value, $Res Function(NavigationState) _then) =
      _$NavigationStateCopyWithImpl;
  @useResult
  $Res call(
      {Route? route,
      RouteInstruction? currentInstruction,
      List<RouteInstruction> upcomingInstructions,
      LatLng? destination,
      NavigationStatus status,
      String? error,
      double distanceToDestination,
      double distanceFromRoute,
      bool isOffRoute,
      LatLng? snappedPosition});

  $RouteCopyWith<$Res>? get route;
  $RouteInstructionCopyWith<$Res>? get currentInstruction;
}

/// @nodoc
class _$NavigationStateCopyWithImpl<$Res>
    implements $NavigationStateCopyWith<$Res> {
  _$NavigationStateCopyWithImpl(this._self, this._then);

  final NavigationState _self;
  final $Res Function(NavigationState) _then;

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? route = freezed,
    Object? currentInstruction = freezed,
    Object? upcomingInstructions = null,
    Object? destination = freezed,
    Object? status = null,
    Object? error = freezed,
    Object? distanceToDestination = null,
    Object? distanceFromRoute = null,
    Object? isOffRoute = null,
    Object? snappedPosition = freezed,
  }) {
    return _then(_self.copyWith(
      route: freezed == route
          ? _self.route
          : route // ignore: cast_nullable_to_non_nullable
              as Route?,
      currentInstruction: freezed == currentInstruction
          ? _self.currentInstruction
          : currentInstruction // ignore: cast_nullable_to_non_nullable
              as RouteInstruction?,
      upcomingInstructions: null == upcomingInstructions
          ? _self.upcomingInstructions
          : upcomingInstructions // ignore: cast_nullable_to_non_nullable
              as List<RouteInstruction>,
      destination: freezed == destination
          ? _self.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as NavigationStatus,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      distanceToDestination: null == distanceToDestination
          ? _self.distanceToDestination
          : distanceToDestination // ignore: cast_nullable_to_non_nullable
              as double,
      distanceFromRoute: null == distanceFromRoute
          ? _self.distanceFromRoute
          : distanceFromRoute // ignore: cast_nullable_to_non_nullable
              as double,
      isOffRoute: null == isOffRoute
          ? _self.isOffRoute
          : isOffRoute // ignore: cast_nullable_to_non_nullable
              as bool,
      snappedPosition: freezed == snappedPosition
          ? _self.snappedPosition
          : snappedPosition // ignore: cast_nullable_to_non_nullable
              as LatLng?,
    ));
  }

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RouteCopyWith<$Res>? get route {
    if (_self.route == null) {
      return null;
    }

    return $RouteCopyWith<$Res>(_self.route!, (value) {
      return _then(_self.copyWith(route: value));
    });
  }

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RouteInstructionCopyWith<$Res>? get currentInstruction {
    if (_self.currentInstruction == null) {
      return null;
    }

    return $RouteInstructionCopyWith<$Res>(_self.currentInstruction!, (value) {
      return _then(_self.copyWith(currentInstruction: value));
    });
  }
}

/// @nodoc

class _NavigationState extends NavigationState {
  const _NavigationState(
      {this.route = null,
      this.currentInstruction = null,
      final List<RouteInstruction> upcomingInstructions = const [],
      this.destination = null,
      this.status = NavigationStatus.idle,
      this.error = null,
      this.distanceToDestination = 0.0,
      this.distanceFromRoute = 0.0,
      this.isOffRoute = false,
      this.snappedPosition = null})
      : _upcomingInstructions = upcomingInstructions,
        super._();

  @override
  @JsonKey()
  final Route? route;
  @override
  @JsonKey()
  final RouteInstruction? currentInstruction;
  final List<RouteInstruction> _upcomingInstructions;
  @override
  @JsonKey()
  List<RouteInstruction> get upcomingInstructions {
    if (_upcomingInstructions is EqualUnmodifiableListView)
      return _upcomingInstructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upcomingInstructions);
  }

  @override
  @JsonKey()
  final LatLng? destination;
  @override
  @JsonKey()
  final NavigationStatus status;
  @override
  @JsonKey()
  final String? error;
  @override
  @JsonKey()
  final double distanceToDestination;
  @override
  @JsonKey()
  final double distanceFromRoute;
  @override
  @JsonKey()
  final bool isOffRoute;
  @override
  @JsonKey()
  final LatLng? snappedPosition;

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavigationStateCopyWith<_NavigationState> get copyWith =>
      __$NavigationStateCopyWithImpl<_NavigationState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavigationState &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.currentInstruction, currentInstruction) ||
                other.currentInstruction == currentInstruction) &&
            const DeepCollectionEquality()
                .equals(other._upcomingInstructions, _upcomingInstructions) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.distanceToDestination, distanceToDestination) ||
                other.distanceToDestination == distanceToDestination) &&
            (identical(other.distanceFromRoute, distanceFromRoute) ||
                other.distanceFromRoute == distanceFromRoute) &&
            (identical(other.isOffRoute, isOffRoute) ||
                other.isOffRoute == isOffRoute) &&
            (identical(other.snappedPosition, snappedPosition) ||
                other.snappedPosition == snappedPosition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      route,
      currentInstruction,
      const DeepCollectionEquality().hash(_upcomingInstructions),
      destination,
      status,
      error,
      distanceToDestination,
      distanceFromRoute,
      isOffRoute,
      snappedPosition);

  @override
  String toString() {
    return 'NavigationState(route: $route, currentInstruction: $currentInstruction, upcomingInstructions: $upcomingInstructions, destination: $destination, status: $status, error: $error, distanceToDestination: $distanceToDestination, distanceFromRoute: $distanceFromRoute, isOffRoute: $isOffRoute, snappedPosition: $snappedPosition)';
  }
}

/// @nodoc
abstract mixin class _$NavigationStateCopyWith<$Res>
    implements $NavigationStateCopyWith<$Res> {
  factory _$NavigationStateCopyWith(
          _NavigationState value, $Res Function(_NavigationState) _then) =
      __$NavigationStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Route? route,
      RouteInstruction? currentInstruction,
      List<RouteInstruction> upcomingInstructions,
      LatLng? destination,
      NavigationStatus status,
      String? error,
      double distanceToDestination,
      double distanceFromRoute,
      bool isOffRoute,
      LatLng? snappedPosition});

  @override
  $RouteCopyWith<$Res>? get route;
  @override
  $RouteInstructionCopyWith<$Res>? get currentInstruction;
}

/// @nodoc
class __$NavigationStateCopyWithImpl<$Res>
    implements _$NavigationStateCopyWith<$Res> {
  __$NavigationStateCopyWithImpl(this._self, this._then);

  final _NavigationState _self;
  final $Res Function(_NavigationState) _then;

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? route = freezed,
    Object? currentInstruction = freezed,
    Object? upcomingInstructions = null,
    Object? destination = freezed,
    Object? status = null,
    Object? error = freezed,
    Object? distanceToDestination = null,
    Object? distanceFromRoute = null,
    Object? isOffRoute = null,
    Object? snappedPosition = freezed,
  }) {
    return _then(_NavigationState(
      route: freezed == route
          ? _self.route
          : route // ignore: cast_nullable_to_non_nullable
              as Route?,
      currentInstruction: freezed == currentInstruction
          ? _self.currentInstruction
          : currentInstruction // ignore: cast_nullable_to_non_nullable
              as RouteInstruction?,
      upcomingInstructions: null == upcomingInstructions
          ? _self._upcomingInstructions
          : upcomingInstructions // ignore: cast_nullable_to_non_nullable
              as List<RouteInstruction>,
      destination: freezed == destination
          ? _self.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as NavigationStatus,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      distanceToDestination: null == distanceToDestination
          ? _self.distanceToDestination
          : distanceToDestination // ignore: cast_nullable_to_non_nullable
              as double,
      distanceFromRoute: null == distanceFromRoute
          ? _self.distanceFromRoute
          : distanceFromRoute // ignore: cast_nullable_to_non_nullable
              as double,
      isOffRoute: null == isOffRoute
          ? _self.isOffRoute
          : isOffRoute // ignore: cast_nullable_to_non_nullable
              as bool,
      snappedPosition: freezed == snappedPosition
          ? _self.snappedPosition
          : snappedPosition // ignore: cast_nullable_to_non_nullable
              as LatLng?,
    ));
  }

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RouteCopyWith<$Res>? get route {
    if (_self.route == null) {
      return null;
    }

    return $RouteCopyWith<$Res>(_self.route!, (value) {
      return _then(_self.copyWith(route: value));
    });
  }

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RouteInstructionCopyWith<$Res>? get currentInstruction {
    if (_self.currentInstruction == null) {
      return null;
    }

    return $RouteInstructionCopyWith<$Res>(_self.currentInstruction!, (value) {
      return _then(_self.copyWith(currentInstruction: value));
    });
  }
}

// dart format on
