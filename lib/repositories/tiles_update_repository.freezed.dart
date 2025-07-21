// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tiles_update_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TilesVersions {
  String? get region;
  TilesReleaseDates? get releaseDates;

  /// Create a copy of TilesVersions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TilesVersionsCopyWith<TilesVersions> get copyWith =>
      _$TilesVersionsCopyWithImpl<TilesVersions>(
          this as TilesVersions, _$identity);

  /// Serializes this TilesVersions to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TilesVersions &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.releaseDates, releaseDates) ||
                other.releaseDates == releaseDates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, region, releaseDates);

  @override
  String toString() {
    return 'TilesVersions(region: $region, releaseDates: $releaseDates)';
  }
}

/// @nodoc
abstract mixin class $TilesVersionsCopyWith<$Res> {
  factory $TilesVersionsCopyWith(
          TilesVersions value, $Res Function(TilesVersions) _then) =
      _$TilesVersionsCopyWithImpl;
  @useResult
  $Res call({String? region, TilesReleaseDates? releaseDates});

  $TilesReleaseDatesCopyWith<$Res>? get releaseDates;
}

/// @nodoc
class _$TilesVersionsCopyWithImpl<$Res>
    implements $TilesVersionsCopyWith<$Res> {
  _$TilesVersionsCopyWithImpl(this._self, this._then);

  final TilesVersions _self;
  final $Res Function(TilesVersions) _then;

  /// Create a copy of TilesVersions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? region = freezed,
    Object? releaseDates = freezed,
  }) {
    return _then(_self.copyWith(
      region: freezed == region
          ? _self.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDates: freezed == releaseDates
          ? _self.releaseDates
          : releaseDates // ignore: cast_nullable_to_non_nullable
              as TilesReleaseDates?,
    ));
  }

  /// Create a copy of TilesVersions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TilesReleaseDatesCopyWith<$Res>? get releaseDates {
    if (_self.releaseDates == null) {
      return null;
    }

    return $TilesReleaseDatesCopyWith<$Res>(_self.releaseDates!, (value) {
      return _then(_self.copyWith(releaseDates: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TilesVersions extends TilesVersions {
  const _TilesVersions({this.region, this.releaseDates}) : super._();
  factory _TilesVersions.fromJson(Map<String, dynamic> json) =>
      _$TilesVersionsFromJson(json);

  @override
  final String? region;
  @override
  final TilesReleaseDates? releaseDates;

  /// Create a copy of TilesVersions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TilesVersionsCopyWith<_TilesVersions> get copyWith =>
      __$TilesVersionsCopyWithImpl<_TilesVersions>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TilesVersionsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TilesVersions &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.releaseDates, releaseDates) ||
                other.releaseDates == releaseDates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, region, releaseDates);

  @override
  String toString() {
    return 'TilesVersions(region: $region, releaseDates: $releaseDates)';
  }
}

/// @nodoc
abstract mixin class _$TilesVersionsCopyWith<$Res>
    implements $TilesVersionsCopyWith<$Res> {
  factory _$TilesVersionsCopyWith(
          _TilesVersions value, $Res Function(_TilesVersions) _then) =
      __$TilesVersionsCopyWithImpl;
  @override
  @useResult
  $Res call({String? region, TilesReleaseDates? releaseDates});

  @override
  $TilesReleaseDatesCopyWith<$Res>? get releaseDates;
}

/// @nodoc
class __$TilesVersionsCopyWithImpl<$Res>
    implements _$TilesVersionsCopyWith<$Res> {
  __$TilesVersionsCopyWithImpl(this._self, this._then);

  final _TilesVersions _self;
  final $Res Function(_TilesVersions) _then;

  /// Create a copy of TilesVersions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? region = freezed,
    Object? releaseDates = freezed,
  }) {
    return _then(_TilesVersions(
      region: freezed == region
          ? _self.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDates: freezed == releaseDates
          ? _self.releaseDates
          : releaseDates // ignore: cast_nullable_to_non_nullable
              as TilesReleaseDates?,
    ));
  }

  /// Create a copy of TilesVersions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TilesReleaseDatesCopyWith<$Res>? get releaseDates {
    if (_self.releaseDates == null) {
      return null;
    }

    return $TilesReleaseDatesCopyWith<$Res>(_self.releaseDates!, (value) {
      return _then(_self.copyWith(releaseDates: value));
    });
  }
}

/// @nodoc
mixin _$TilesReleaseDates {
  DateTime get valhallaDate;
  DateTime get osmDate;

  /// Create a copy of TilesReleaseDates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TilesReleaseDatesCopyWith<TilesReleaseDates> get copyWith =>
      _$TilesReleaseDatesCopyWithImpl<TilesReleaseDates>(
          this as TilesReleaseDates, _$identity);

  /// Serializes this TilesReleaseDates to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TilesReleaseDates &&
            (identical(other.valhallaDate, valhallaDate) ||
                other.valhallaDate == valhallaDate) &&
            (identical(other.osmDate, osmDate) || other.osmDate == osmDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, valhallaDate, osmDate);

  @override
  String toString() {
    return 'TilesReleaseDates(valhallaDate: $valhallaDate, osmDate: $osmDate)';
  }
}

/// @nodoc
abstract mixin class $TilesReleaseDatesCopyWith<$Res> {
  factory $TilesReleaseDatesCopyWith(
          TilesReleaseDates value, $Res Function(TilesReleaseDates) _then) =
      _$TilesReleaseDatesCopyWithImpl;
  @useResult
  $Res call({DateTime valhallaDate, DateTime osmDate});
}

/// @nodoc
class _$TilesReleaseDatesCopyWithImpl<$Res>
    implements $TilesReleaseDatesCopyWith<$Res> {
  _$TilesReleaseDatesCopyWithImpl(this._self, this._then);

  final TilesReleaseDates _self;
  final $Res Function(TilesReleaseDates) _then;

  /// Create a copy of TilesReleaseDates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? valhallaDate = null,
    Object? osmDate = null,
  }) {
    return _then(_self.copyWith(
      valhallaDate: null == valhallaDate
          ? _self.valhallaDate
          : valhallaDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      osmDate: null == osmDate
          ? _self.osmDate
          : osmDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TilesReleaseDates extends TilesReleaseDates {
  const _TilesReleaseDates({required this.valhallaDate, required this.osmDate})
      : super._();
  factory _TilesReleaseDates.fromJson(Map<String, dynamic> json) =>
      _$TilesReleaseDatesFromJson(json);

  @override
  final DateTime valhallaDate;
  @override
  final DateTime osmDate;

  /// Create a copy of TilesReleaseDates
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TilesReleaseDatesCopyWith<_TilesReleaseDates> get copyWith =>
      __$TilesReleaseDatesCopyWithImpl<_TilesReleaseDates>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TilesReleaseDatesToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TilesReleaseDates &&
            (identical(other.valhallaDate, valhallaDate) ||
                other.valhallaDate == valhallaDate) &&
            (identical(other.osmDate, osmDate) || other.osmDate == osmDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, valhallaDate, osmDate);

  @override
  String toString() {
    return 'TilesReleaseDates(valhallaDate: $valhallaDate, osmDate: $osmDate)';
  }
}

/// @nodoc
abstract mixin class _$TilesReleaseDatesCopyWith<$Res>
    implements $TilesReleaseDatesCopyWith<$Res> {
  factory _$TilesReleaseDatesCopyWith(
          _TilesReleaseDates value, $Res Function(_TilesReleaseDates) _then) =
      __$TilesReleaseDatesCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime valhallaDate, DateTime osmDate});
}

/// @nodoc
class __$TilesReleaseDatesCopyWithImpl<$Res>
    implements _$TilesReleaseDatesCopyWith<$Res> {
  __$TilesReleaseDatesCopyWithImpl(this._self, this._then);

  final _TilesReleaseDates _self;
  final $Res Function(_TilesReleaseDates) _then;

  /// Create a copy of TilesReleaseDates
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? valhallaDate = null,
    Object? osmDate = null,
  }) {
    return _then(_TilesReleaseDates(
      valhallaDate: null == valhallaDate
          ? _self.valhallaDate
          : valhallaDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      osmDate: null == osmDate
          ? _self.osmDate
          : osmDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
