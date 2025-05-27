// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'valhalla_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ValhallaResponse {
  Trip get trip;

  /// Create a copy of ValhallaResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ValhallaResponseCopyWith<ValhallaResponse> get copyWith =>
      _$ValhallaResponseCopyWithImpl<ValhallaResponse>(
          this as ValhallaResponse, _$identity);

  /// Serializes this ValhallaResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ValhallaResponse &&
            (identical(other.trip, trip) || other.trip == trip));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, trip);

  @override
  String toString() {
    return 'ValhallaResponse(trip: $trip)';
  }
}

/// @nodoc
abstract mixin class $ValhallaResponseCopyWith<$Res> {
  factory $ValhallaResponseCopyWith(
          ValhallaResponse value, $Res Function(ValhallaResponse) _then) =
      _$ValhallaResponseCopyWithImpl;
  @useResult
  $Res call({Trip trip});

  $TripCopyWith<$Res> get trip;
}

/// @nodoc
class _$ValhallaResponseCopyWithImpl<$Res>
    implements $ValhallaResponseCopyWith<$Res> {
  _$ValhallaResponseCopyWithImpl(this._self, this._then);

  final ValhallaResponse _self;
  final $Res Function(ValhallaResponse) _then;

  /// Create a copy of ValhallaResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trip = null,
  }) {
    return _then(_self.copyWith(
      trip: null == trip
          ? _self.trip
          : trip // ignore: cast_nullable_to_non_nullable
              as Trip,
    ));
  }

  /// Create a copy of ValhallaResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripCopyWith<$Res> get trip {
    return $TripCopyWith<$Res>(_self.trip, (value) {
      return _then(_self.copyWith(trip: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _ValhallaResponse implements ValhallaResponse {
  const _ValhallaResponse({required this.trip});
  factory _ValhallaResponse.fromJson(Map<String, dynamic> json) =>
      _$ValhallaResponseFromJson(json);

  @override
  final Trip trip;

  /// Create a copy of ValhallaResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ValhallaResponseCopyWith<_ValhallaResponse> get copyWith =>
      __$ValhallaResponseCopyWithImpl<_ValhallaResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ValhallaResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ValhallaResponse &&
            (identical(other.trip, trip) || other.trip == trip));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, trip);

  @override
  String toString() {
    return 'ValhallaResponse(trip: $trip)';
  }
}

/// @nodoc
abstract mixin class _$ValhallaResponseCopyWith<$Res>
    implements $ValhallaResponseCopyWith<$Res> {
  factory _$ValhallaResponseCopyWith(
          _ValhallaResponse value, $Res Function(_ValhallaResponse) _then) =
      __$ValhallaResponseCopyWithImpl;
  @override
  @useResult
  $Res call({Trip trip});

  @override
  $TripCopyWith<$Res> get trip;
}

/// @nodoc
class __$ValhallaResponseCopyWithImpl<$Res>
    implements _$ValhallaResponseCopyWith<$Res> {
  __$ValhallaResponseCopyWithImpl(this._self, this._then);

  final _ValhallaResponse _self;
  final $Res Function(_ValhallaResponse) _then;

  /// Create a copy of ValhallaResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? trip = null,
  }) {
    return _then(_ValhallaResponse(
      trip: null == trip
          ? _self.trip
          : trip // ignore: cast_nullable_to_non_nullable
              as Trip,
    ));
  }

  /// Create a copy of ValhallaResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripCopyWith<$Res> get trip {
    return $TripCopyWith<$Res>(_self.trip, (value) {
      return _then(_self.copyWith(trip: value));
    });
  }
}

/// @nodoc
mixin _$Trip {
  List<Leg> get legs;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TripCopyWith<Trip> get copyWith =>
      _$TripCopyWithImpl<Trip>(this as Trip, _$identity);

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Trip &&
            const DeepCollectionEquality().equals(other.legs, legs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(legs));

  @override
  String toString() {
    return 'Trip(legs: $legs)';
  }
}

/// @nodoc
abstract mixin class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) _then) =
      _$TripCopyWithImpl;
  @useResult
  $Res call({List<Leg> legs});
}

/// @nodoc
class _$TripCopyWithImpl<$Res> implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._self, this._then);

  final Trip _self;
  final $Res Function(Trip) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? legs = null,
  }) {
    return _then(_self.copyWith(
      legs: null == legs
          ? _self.legs
          : legs // ignore: cast_nullable_to_non_nullable
              as List<Leg>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Trip implements Trip {
  const _Trip({required final List<Leg> legs}) : _legs = legs;
  factory _Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  final List<Leg> _legs;
  @override
  List<Leg> get legs {
    if (_legs is EqualUnmodifiableListView) return _legs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_legs);
  }

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TripCopyWith<_Trip> get copyWith =>
      __$TripCopyWithImpl<_Trip>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TripToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Trip &&
            const DeepCollectionEquality().equals(other._legs, _legs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_legs));

  @override
  String toString() {
    return 'Trip(legs: $legs)';
  }
}

/// @nodoc
abstract mixin class _$TripCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$TripCopyWith(_Trip value, $Res Function(_Trip) _then) =
      __$TripCopyWithImpl;
  @override
  @useResult
  $Res call({List<Leg> legs});
}

/// @nodoc
class __$TripCopyWithImpl<$Res> implements _$TripCopyWith<$Res> {
  __$TripCopyWithImpl(this._self, this._then);

  final _Trip _self;
  final $Res Function(_Trip) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? legs = null,
  }) {
    return _then(_Trip(
      legs: null == legs
          ? _self._legs
          : legs // ignore: cast_nullable_to_non_nullable
              as List<Leg>,
    ));
  }
}

/// @nodoc
mixin _$Leg {
  List<Maneuver> get maneuvers;
  Summary get summary;
  String get shape;

  /// Create a copy of Leg
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LegCopyWith<Leg> get copyWith =>
      _$LegCopyWithImpl<Leg>(this as Leg, _$identity);

  /// Serializes this Leg to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Leg &&
            const DeepCollectionEquality().equals(other.maneuvers, maneuvers) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.shape, shape) || other.shape == shape));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(maneuvers), summary, shape);

  @override
  String toString() {
    return 'Leg(maneuvers: $maneuvers, summary: $summary, shape: $shape)';
  }
}

/// @nodoc
abstract mixin class $LegCopyWith<$Res> {
  factory $LegCopyWith(Leg value, $Res Function(Leg) _then) = _$LegCopyWithImpl;
  @useResult
  $Res call({List<Maneuver> maneuvers, Summary summary, String shape});

  $SummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$LegCopyWithImpl<$Res> implements $LegCopyWith<$Res> {
  _$LegCopyWithImpl(this._self, this._then);

  final Leg _self;
  final $Res Function(Leg) _then;

  /// Create a copy of Leg
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maneuvers = null,
    Object? summary = null,
    Object? shape = null,
  }) {
    return _then(_self.copyWith(
      maneuvers: null == maneuvers
          ? _self.maneuvers
          : maneuvers // ignore: cast_nullable_to_non_nullable
              as List<Maneuver>,
      summary: null == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as Summary,
      shape: null == shape
          ? _self.shape
          : shape // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of Leg
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SummaryCopyWith<$Res> get summary {
    return $SummaryCopyWith<$Res>(_self.summary, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Leg implements Leg {
  const _Leg(
      {required final List<Maneuver> maneuvers,
      required this.summary,
      required this.shape})
      : _maneuvers = maneuvers;
  factory _Leg.fromJson(Map<String, dynamic> json) => _$LegFromJson(json);

  final List<Maneuver> _maneuvers;
  @override
  List<Maneuver> get maneuvers {
    if (_maneuvers is EqualUnmodifiableListView) return _maneuvers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_maneuvers);
  }

  @override
  final Summary summary;
  @override
  final String shape;

  /// Create a copy of Leg
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LegCopyWith<_Leg> get copyWith =>
      __$LegCopyWithImpl<_Leg>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LegToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Leg &&
            const DeepCollectionEquality()
                .equals(other._maneuvers, _maneuvers) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.shape, shape) || other.shape == shape));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_maneuvers), summary, shape);

  @override
  String toString() {
    return 'Leg(maneuvers: $maneuvers, summary: $summary, shape: $shape)';
  }
}

/// @nodoc
abstract mixin class _$LegCopyWith<$Res> implements $LegCopyWith<$Res> {
  factory _$LegCopyWith(_Leg value, $Res Function(_Leg) _then) =
      __$LegCopyWithImpl;
  @override
  @useResult
  $Res call({List<Maneuver> maneuvers, Summary summary, String shape});

  @override
  $SummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$LegCopyWithImpl<$Res> implements _$LegCopyWith<$Res> {
  __$LegCopyWithImpl(this._self, this._then);

  final _Leg _self;
  final $Res Function(_Leg) _then;

  /// Create a copy of Leg
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? maneuvers = null,
    Object? summary = null,
    Object? shape = null,
  }) {
    return _then(_Leg(
      maneuvers: null == maneuvers
          ? _self._maneuvers
          : maneuvers // ignore: cast_nullable_to_non_nullable
              as List<Maneuver>,
      summary: null == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as Summary,
      shape: null == shape
          ? _self.shape
          : shape // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of Leg
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SummaryCopyWith<$Res> get summary {
    return $SummaryCopyWith<$Res>(_self.summary, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }
}

/// @nodoc
mixin _$Maneuver {
  int get type;
  double get length;
  @JsonKey(name: 'begin_shape_index')
  int? get beginShapeIndex;
  @JsonKey(name: 'roundabout_exit_count')
  int? get roundaboutExitCount;

  /// Create a copy of Maneuver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ManeuverCopyWith<Maneuver> get copyWith =>
      _$ManeuverCopyWithImpl<Maneuver>(this as Maneuver, _$identity);

  /// Serializes this Maneuver to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Maneuver &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.length, length) || other.length == length) &&
            (identical(other.beginShapeIndex, beginShapeIndex) ||
                other.beginShapeIndex == beginShapeIndex) &&
            (identical(other.roundaboutExitCount, roundaboutExitCount) ||
                other.roundaboutExitCount == roundaboutExitCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, length, beginShapeIndex, roundaboutExitCount);

  @override
  String toString() {
    return 'Maneuver(type: $type, length: $length, beginShapeIndex: $beginShapeIndex, roundaboutExitCount: $roundaboutExitCount)';
  }
}

/// @nodoc
abstract mixin class $ManeuverCopyWith<$Res> {
  factory $ManeuverCopyWith(Maneuver value, $Res Function(Maneuver) _then) =
      _$ManeuverCopyWithImpl;
  @useResult
  $Res call(
      {int type,
      double length,
      @JsonKey(name: 'begin_shape_index') int? beginShapeIndex,
      @JsonKey(name: 'roundabout_exit_count') int? roundaboutExitCount});
}

/// @nodoc
class _$ManeuverCopyWithImpl<$Res> implements $ManeuverCopyWith<$Res> {
  _$ManeuverCopyWithImpl(this._self, this._then);

  final Maneuver _self;
  final $Res Function(Maneuver) _then;

  /// Create a copy of Maneuver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? length = null,
    Object? beginShapeIndex = freezed,
    Object? roundaboutExitCount = freezed,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      length: null == length
          ? _self.length
          : length // ignore: cast_nullable_to_non_nullable
              as double,
      beginShapeIndex: freezed == beginShapeIndex
          ? _self.beginShapeIndex
          : beginShapeIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      roundaboutExitCount: freezed == roundaboutExitCount
          ? _self.roundaboutExitCount
          : roundaboutExitCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Maneuver implements Maneuver {
  const _Maneuver(
      {required this.type,
      required this.length,
      @JsonKey(name: 'begin_shape_index') this.beginShapeIndex,
      @JsonKey(name: 'roundabout_exit_count') this.roundaboutExitCount});
  factory _Maneuver.fromJson(Map<String, dynamic> json) =>
      _$ManeuverFromJson(json);

  @override
  final int type;
  @override
  final double length;
  @override
  @JsonKey(name: 'begin_shape_index')
  final int? beginShapeIndex;
  @override
  @JsonKey(name: 'roundabout_exit_count')
  final int? roundaboutExitCount;

  /// Create a copy of Maneuver
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ManeuverCopyWith<_Maneuver> get copyWith =>
      __$ManeuverCopyWithImpl<_Maneuver>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ManeuverToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Maneuver &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.length, length) || other.length == length) &&
            (identical(other.beginShapeIndex, beginShapeIndex) ||
                other.beginShapeIndex == beginShapeIndex) &&
            (identical(other.roundaboutExitCount, roundaboutExitCount) ||
                other.roundaboutExitCount == roundaboutExitCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, length, beginShapeIndex, roundaboutExitCount);

  @override
  String toString() {
    return 'Maneuver(type: $type, length: $length, beginShapeIndex: $beginShapeIndex, roundaboutExitCount: $roundaboutExitCount)';
  }
}

/// @nodoc
abstract mixin class _$ManeuverCopyWith<$Res>
    implements $ManeuverCopyWith<$Res> {
  factory _$ManeuverCopyWith(_Maneuver value, $Res Function(_Maneuver) _then) =
      __$ManeuverCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int type,
      double length,
      @JsonKey(name: 'begin_shape_index') int? beginShapeIndex,
      @JsonKey(name: 'roundabout_exit_count') int? roundaboutExitCount});
}

/// @nodoc
class __$ManeuverCopyWithImpl<$Res> implements _$ManeuverCopyWith<$Res> {
  __$ManeuverCopyWithImpl(this._self, this._then);

  final _Maneuver _self;
  final $Res Function(_Maneuver) _then;

  /// Create a copy of Maneuver
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? length = null,
    Object? beginShapeIndex = freezed,
    Object? roundaboutExitCount = freezed,
  }) {
    return _then(_Maneuver(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      length: null == length
          ? _self.length
          : length // ignore: cast_nullable_to_non_nullable
              as double,
      beginShapeIndex: freezed == beginShapeIndex
          ? _self.beginShapeIndex
          : beginShapeIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      roundaboutExitCount: freezed == roundaboutExitCount
          ? _self.roundaboutExitCount
          : roundaboutExitCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$Summary {
  double get length;
  int get time;

  /// Create a copy of Summary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SummaryCopyWith<Summary> get copyWith =>
      _$SummaryCopyWithImpl<Summary>(this as Summary, _$identity);

  /// Serializes this Summary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Summary &&
            (identical(other.length, length) || other.length == length) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, length, time);

  @override
  String toString() {
    return 'Summary(length: $length, time: $time)';
  }
}

/// @nodoc
abstract mixin class $SummaryCopyWith<$Res> {
  factory $SummaryCopyWith(Summary value, $Res Function(Summary) _then) =
      _$SummaryCopyWithImpl;
  @useResult
  $Res call({double length, int time});
}

/// @nodoc
class _$SummaryCopyWithImpl<$Res> implements $SummaryCopyWith<$Res> {
  _$SummaryCopyWithImpl(this._self, this._then);

  final Summary _self;
  final $Res Function(Summary) _then;

  /// Create a copy of Summary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? length = null,
    Object? time = null,
  }) {
    return _then(_self.copyWith(
      length: null == length
          ? _self.length
          : length // ignore: cast_nullable_to_non_nullable
              as double,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Summary implements Summary {
  const _Summary({required this.length, required this.time});
  factory _Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);

  @override
  final double length;
  @override
  final int time;

  /// Create a copy of Summary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SummaryCopyWith<_Summary> get copyWith =>
      __$SummaryCopyWithImpl<_Summary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Summary &&
            (identical(other.length, length) || other.length == length) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, length, time);

  @override
  String toString() {
    return 'Summary(length: $length, time: $time)';
  }
}

/// @nodoc
abstract mixin class _$SummaryCopyWith<$Res> implements $SummaryCopyWith<$Res> {
  factory _$SummaryCopyWith(_Summary value, $Res Function(_Summary) _then) =
      __$SummaryCopyWithImpl;
  @override
  @useResult
  $Res call({double length, int time});
}

/// @nodoc
class __$SummaryCopyWithImpl<$Res> implements _$SummaryCopyWith<$Res> {
  __$SummaryCopyWithImpl(this._self, this._then);

  final _Summary _self;
  final $Res Function(_Summary) _then;

  /// Create a copy of Summary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? length = null,
    Object? time = null,
  }) {
    return _then(_Summary(
      length: null == length
          ? _self.length
          : length // ignore: cast_nullable_to_non_nullable
              as double,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
