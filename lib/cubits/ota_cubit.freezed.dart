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

class OtaStatusBar implements OtaState {
  const OtaStatusBar({required this.status, required this.statusText});

  final OtaStatus status;
  final String statusText;

  /// Create a copy of OtaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OtaStatusBarCopyWith<OtaStatusBar> get copyWith =>
      _$OtaStatusBarCopyWithImpl<OtaStatusBar>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OtaStatusBar &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusText, statusText) ||
                other.statusText == statusText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, statusText);

  @override
  String toString() {
    return 'OtaState.statusBar(status: $status, statusText: $statusText)';
  }
}

/// @nodoc
abstract mixin class $OtaStatusBarCopyWith<$Res>
    implements $OtaStateCopyWith<$Res> {
  factory $OtaStatusBarCopyWith(
          OtaStatusBar value, $Res Function(OtaStatusBar) _then) =
      _$OtaStatusBarCopyWithImpl;
  @useResult
  $Res call({OtaStatus status, String statusText});
}

/// @nodoc
class _$OtaStatusBarCopyWithImpl<$Res> implements $OtaStatusBarCopyWith<$Res> {
  _$OtaStatusBarCopyWithImpl(this._self, this._then);

  final OtaStatusBar _self;
  final $Res Function(OtaStatusBar) _then;

  /// Create a copy of OtaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? statusText = null,
  }) {
    return _then(OtaStatusBar(
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

// dart format on
