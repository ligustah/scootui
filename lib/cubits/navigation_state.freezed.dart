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
  RouteInstruction? get nextInstruction;
  LatLng? get destination;
  NavigationStatus get status;
  String? get error;
  double get distanceToDestination;
  double get distanceFromRoute;
  bool get isOffRoute;

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
            (identical(other.nextInstruction, nextInstruction) ||
                other.nextInstruction == nextInstruction) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.distanceToDestination, distanceToDestination) ||
                other.distanceToDestination == distanceToDestination) &&
            (identical(other.distanceFromRoute, distanceFromRoute) ||
                other.distanceFromRoute == distanceFromRoute) &&
            (identical(other.isOffRoute, isOffRoute) ||
                other.isOffRoute == isOffRoute));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      route,
      currentInstruction,
      nextInstruction,
      destination,
      status,
      error,
      distanceToDestination,
      distanceFromRoute,
      isOffRoute);

  @override
  String toString() {
    return 'NavigationState(route: $route, currentInstruction: $currentInstruction, nextInstruction: $nextInstruction, destination: $destination, status: $status, error: $error, distanceToDestination: $distanceToDestination, distanceFromRoute: $distanceFromRoute, isOffRoute: $isOffRoute)';
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
      RouteInstruction? nextInstruction,
      LatLng? destination,
      NavigationStatus status,
      String? error,
      double distanceToDestination,
      double distanceFromRoute,
      bool isOffRoute});

  $RouteCopyWith<$Res>? get route;
  $RouteInstructionCopyWith<$Res>? get currentInstruction;
  $RouteInstructionCopyWith<$Res>? get nextInstruction;
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
    Object? nextInstruction = freezed,
    Object? destination = freezed,
    Object? status = null,
    Object? error = freezed,
    Object? distanceToDestination = null,
    Object? distanceFromRoute = null,
    Object? isOffRoute = null,
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
      nextInstruction: freezed == nextInstruction
          ? _self.nextInstruction
          : nextInstruction // ignore: cast_nullable_to_non_nullable
              as RouteInstruction?,
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

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RouteInstructionCopyWith<$Res>? get nextInstruction {
    if (_self.nextInstruction == null) {
      return null;
    }

    return $RouteInstructionCopyWith<$Res>(_self.nextInstruction!, (value) {
      return _then(_self.copyWith(nextInstruction: value));
    });
  }
}

/// @nodoc

class _NavigationState extends NavigationState {
  const _NavigationState(
      {this.route = null,
      this.currentInstruction = null,
      this.nextInstruction = null,
      this.destination = null,
      this.status = NavigationStatus.idle,
      this.error = null,
      this.distanceToDestination = 0.0,
      this.distanceFromRoute = 0.0,
      this.isOffRoute = false})
      : super._();

  @override
  @JsonKey()
  final Route? route;
  @override
  @JsonKey()
  final RouteInstruction? currentInstruction;
  @override
  @JsonKey()
  final RouteInstruction? nextInstruction;
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
            (identical(other.nextInstruction, nextInstruction) ||
                other.nextInstruction == nextInstruction) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.distanceToDestination, distanceToDestination) ||
                other.distanceToDestination == distanceToDestination) &&
            (identical(other.distanceFromRoute, distanceFromRoute) ||
                other.distanceFromRoute == distanceFromRoute) &&
            (identical(other.isOffRoute, isOffRoute) ||
                other.isOffRoute == isOffRoute));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      route,
      currentInstruction,
      nextInstruction,
      destination,
      status,
      error,
      distanceToDestination,
      distanceFromRoute,
      isOffRoute);

  @override
  String toString() {
    return 'NavigationState(route: $route, currentInstruction: $currentInstruction, nextInstruction: $nextInstruction, destination: $destination, status: $status, error: $error, distanceToDestination: $distanceToDestination, distanceFromRoute: $distanceFromRoute, isOffRoute: $isOffRoute)';
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
      RouteInstruction? nextInstruction,
      LatLng? destination,
      NavigationStatus status,
      String? error,
      double distanceToDestination,
      double distanceFromRoute,
      bool isOffRoute});

  @override
  $RouteCopyWith<$Res>? get route;
  @override
  $RouteInstructionCopyWith<$Res>? get currentInstruction;
  @override
  $RouteInstructionCopyWith<$Res>? get nextInstruction;
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
    Object? nextInstruction = freezed,
    Object? destination = freezed,
    Object? status = null,
    Object? error = freezed,
    Object? distanceToDestination = null,
    Object? distanceFromRoute = null,
    Object? isOffRoute = null,
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
      nextInstruction: freezed == nextInstruction
          ? _self.nextInstruction
          : nextInstruction // ignore: cast_nullable_to_non_nullable
              as RouteInstruction?,
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

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RouteInstructionCopyWith<$Res>? get nextInstruction {
    if (_self.nextInstruction == null) {
      return null;
    }

    return $RouteInstructionCopyWith<$Res>(_self.nextInstruction!, (value) {
      return _then(_self.copyWith(nextInstruction: value));
    });
  }
}

// dart format on
