// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ota_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OtaState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OtaState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OtaState()';
  }
}

/// @nodoc
class $OtaStateCopyWith<$Res> {
  $OtaStateCopyWith(OtaState _, $Res Function(OtaState) __);
}

/// @nodoc

class OtaInactive implements OtaState {
  const OtaInactive();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OtaInactive);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OtaState.inactive()';
  }
}

/// @nodoc

class OtaMinimal implements OtaState {
  const OtaMinimal({required this.status, required this.statusText});

  final OtaStatus status;
  final String statusText;

  /// Create a copy of OtaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OtaMinimalCopyWith<OtaMinimal> get copyWith =>
      _$OtaMinimalCopyWithImpl<OtaMinimal>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OtaMinimal &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusText, statusText) ||
                other.statusText == statusText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, statusText);

  @override
  String toString() {
    return 'OtaState.minimal(status: $status, statusText: $statusText)';
  }
}

/// @nodoc
abstract mixin class $OtaMinimalCopyWith<$Res>
    implements $OtaStateCopyWith<$Res> {
  factory $OtaMinimalCopyWith(
          OtaMinimal value, $Res Function(OtaMinimal) _then) =
      _$OtaMinimalCopyWithImpl;
  @useResult
  $Res call({OtaStatus status, String statusText});
}

/// @nodoc
class _$OtaMinimalCopyWithImpl<$Res> implements $OtaMinimalCopyWith<$Res> {
  _$OtaMinimalCopyWithImpl(this._self, this._then);

  final OtaMinimal _self;
  final $Res Function(OtaMinimal) _then;

  /// Create a copy of OtaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? statusText = null,
  }) {
    return _then(OtaMinimal(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OtaStatus,
      statusText: null == statusText
          ? _self.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class OtaFullScreen implements OtaState {
  const OtaFullScreen(
      {required this.status, required this.statusText, required this.isParked});

  final OtaStatus status;
  final String statusText;
  final bool isParked;

  /// Create a copy of OtaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OtaFullScreenCopyWith<OtaFullScreen> get copyWith =>
      _$OtaFullScreenCopyWithImpl<OtaFullScreen>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OtaFullScreen &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusText, statusText) ||
                other.statusText == statusText) &&
            (identical(other.isParked, isParked) ||
                other.isParked == isParked));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, statusText, isParked);

  @override
  String toString() {
    return 'OtaState.fullScreen(status: $status, statusText: $statusText, isParked: $isParked)';
  }
}

/// @nodoc
abstract mixin class $OtaFullScreenCopyWith<$Res>
    implements $OtaStateCopyWith<$Res> {
  factory $OtaFullScreenCopyWith(
          OtaFullScreen value, $Res Function(OtaFullScreen) _then) =
      _$OtaFullScreenCopyWithImpl;
  @useResult
  $Res call({OtaStatus status, String statusText, bool isParked});
}

/// @nodoc
class _$OtaFullScreenCopyWithImpl<$Res>
    implements $OtaFullScreenCopyWith<$Res> {
  _$OtaFullScreenCopyWithImpl(this._self, this._then);

  final OtaFullScreen _self;
  final $Res Function(OtaFullScreen) _then;

  /// Create a copy of OtaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? statusText = null,
    Object? isParked = null,
  }) {
    return _then(OtaFullScreen(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OtaStatus,
      statusText: null == statusText
          ? _self.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String,
      isParked: null == isParked
          ? _self.isParked
          : isParked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
