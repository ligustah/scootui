// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MapState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MapState()';
  }
}

/// @nodoc
class $MapStateCopyWith<$Res> {
  $MapStateCopyWith(MapState _, $Res Function(MapState) __);
}

/// @nodoc

class MapInitial implements MapState {
  const MapInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MapInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MapState.initial()';
  }
}

/// @nodoc

class MapLoading implements MapState {
  const MapLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MapLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MapState.loading()';
  }
}

/// @nodoc

class MapUnavailable implements MapState {
  const MapUnavailable(this.error);

  final String error;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MapUnavailableCopyWith<MapUnavailable> get copyWith =>
      _$MapUnavailableCopyWithImpl<MapUnavailable>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MapUnavailable &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'MapState.unavailable(error: $error)';
  }
}

/// @nodoc
abstract mixin class $MapUnavailableCopyWith<$Res>
    implements $MapStateCopyWith<$Res> {
  factory $MapUnavailableCopyWith(
          MapUnavailable value, $Res Function(MapUnavailable) _then) =
      _$MapUnavailableCopyWithImpl;
  @useResult
  $Res call({String error});
}

/// @nodoc
class _$MapUnavailableCopyWithImpl<$Res>
    implements $MapUnavailableCopyWith<$Res> {
  _$MapUnavailableCopyWithImpl(this._self, this._then);

  final MapUnavailable _self;
  final $Res Function(MapUnavailable) _then;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(MapUnavailable(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class MapLoaded implements MapState {
  const MapLoaded(
      {required this.mbTiles,
      required this.position,
      required this.orientation,
      required this.controller,
      required this.theme,
      this.onReady,
      this.isReady = false,
      this.minZoom = 0,
      this.maxZoom = 18});

  final MbTiles mbTiles;
  final LatLng position;
  final double orientation;
  final MapController controller;
  final Theme theme;
  final void Function()? onReady;
  @JsonKey()
  final bool isReady;
  @JsonKey()
  final double minZoom;
  @JsonKey()
  final double maxZoom;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MapLoadedCopyWith<MapLoaded> get copyWith =>
      _$MapLoadedCopyWithImpl<MapLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MapLoaded &&
            (identical(other.mbTiles, mbTiles) || other.mbTiles == mbTiles) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.orientation, orientation) ||
                other.orientation == orientation) &&
            (identical(other.controller, controller) ||
                other.controller == controller) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.onReady, onReady) || other.onReady == onReady) &&
            (identical(other.isReady, isReady) || other.isReady == isReady) &&
            (identical(other.minZoom, minZoom) || other.minZoom == minZoom) &&
            (identical(other.maxZoom, maxZoom) || other.maxZoom == maxZoom));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mbTiles, position, orientation,
      controller, theme, onReady, isReady, minZoom, maxZoom);

  @override
  String toString() {
    return 'MapState.loaded(mbTiles: $mbTiles, position: $position, orientation: $orientation, controller: $controller, theme: $theme, onReady: $onReady, isReady: $isReady, minZoom: $minZoom, maxZoom: $maxZoom)';
  }
}

/// @nodoc
abstract mixin class $MapLoadedCopyWith<$Res>
    implements $MapStateCopyWith<$Res> {
  factory $MapLoadedCopyWith(MapLoaded value, $Res Function(MapLoaded) _then) =
      _$MapLoadedCopyWithImpl;
  @useResult
  $Res call(
      {MbTiles mbTiles,
      LatLng position,
      double orientation,
      MapController controller,
      Theme theme,
      void Function()? onReady,
      bool isReady,
      double minZoom,
      double maxZoom});
}

/// @nodoc
class _$MapLoadedCopyWithImpl<$Res> implements $MapLoadedCopyWith<$Res> {
  _$MapLoadedCopyWithImpl(this._self, this._then);

  final MapLoaded _self;
  final $Res Function(MapLoaded) _then;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mbTiles = null,
    Object? position = null,
    Object? orientation = null,
    Object? controller = null,
    Object? theme = null,
    Object? onReady = freezed,
    Object? isReady = null,
    Object? minZoom = null,
    Object? maxZoom = null,
  }) {
    return _then(MapLoaded(
      mbTiles: null == mbTiles
          ? _self.mbTiles
          : mbTiles // ignore: cast_nullable_to_non_nullable
              as MbTiles,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as LatLng,
      orientation: null == orientation
          ? _self.orientation
          : orientation // ignore: cast_nullable_to_non_nullable
              as double,
      controller: null == controller
          ? _self.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as MapController,
      theme: null == theme
          ? _self.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as Theme,
      onReady: freezed == onReady
          ? _self.onReady
          : onReady // ignore: cast_nullable_to_non_nullable
              as void Function()?,
      isReady: null == isReady
          ? _self.isReady
          : isReady // ignore: cast_nullable_to_non_nullable
              as bool,
      minZoom: null == minZoom
          ? _self.minZoom
          : minZoom // ignore: cast_nullable_to_non_nullable
              as double,
      maxZoom: null == maxZoom
          ? _self.maxZoom
          : maxZoom // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
