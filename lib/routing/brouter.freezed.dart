// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brouter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BRouterProperties implements DiagnosticableTreeMixin {
  String get creator;
  String get name;
  @JsonKey(name: 'track-length')
  String get trackLength;
  @JsonKey(name: 'filtered ascend')
  String get filteredAscend;
  @JsonKey(name: 'plain-ascend')
  String get plainAscend;
  @JsonKey(name: 'total-time')
  String get totalTime;
  @JsonKey(name: 'total-energy')
  String get totalEnergy;
  @JsonKey(name: 'voicehints')
  List<List<int>> get voiceHints;
  String get cost;
  List<List<String>> get messages;
  List<double> get times;

  /// Create a copy of BRouterProperties
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BRouterPropertiesCopyWith<BRouterProperties> get copyWith =>
      _$BRouterPropertiesCopyWithImpl<BRouterProperties>(
          this as BRouterProperties, _$identity);

  /// Serializes this BRouterProperties to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'BRouterProperties'))
      ..add(DiagnosticsProperty('creator', creator))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('trackLength', trackLength))
      ..add(DiagnosticsProperty('filteredAscend', filteredAscend))
      ..add(DiagnosticsProperty('plainAscend', plainAscend))
      ..add(DiagnosticsProperty('totalTime', totalTime))
      ..add(DiagnosticsProperty('totalEnergy', totalEnergy))
      ..add(DiagnosticsProperty('voiceHints', voiceHints))
      ..add(DiagnosticsProperty('cost', cost))
      ..add(DiagnosticsProperty('messages', messages))
      ..add(DiagnosticsProperty('times', times));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BRouterProperties &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.trackLength, trackLength) ||
                other.trackLength == trackLength) &&
            (identical(other.filteredAscend, filteredAscend) ||
                other.filteredAscend == filteredAscend) &&
            (identical(other.plainAscend, plainAscend) ||
                other.plainAscend == plainAscend) &&
            (identical(other.totalTime, totalTime) ||
                other.totalTime == totalTime) &&
            (identical(other.totalEnergy, totalEnergy) ||
                other.totalEnergy == totalEnergy) &&
            const DeepCollectionEquality()
                .equals(other.voiceHints, voiceHints) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            const DeepCollectionEquality().equals(other.messages, messages) &&
            const DeepCollectionEquality().equals(other.times, times));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      creator,
      name,
      trackLength,
      filteredAscend,
      plainAscend,
      totalTime,
      totalEnergy,
      const DeepCollectionEquality().hash(voiceHints),
      cost,
      const DeepCollectionEquality().hash(messages),
      const DeepCollectionEquality().hash(times));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BRouterProperties(creator: $creator, name: $name, trackLength: $trackLength, filteredAscend: $filteredAscend, plainAscend: $plainAscend, totalTime: $totalTime, totalEnergy: $totalEnergy, voiceHints: $voiceHints, cost: $cost, messages: $messages, times: $times)';
  }
}

/// @nodoc
abstract mixin class $BRouterPropertiesCopyWith<$Res> {
  factory $BRouterPropertiesCopyWith(
          BRouterProperties value, $Res Function(BRouterProperties) _then) =
      _$BRouterPropertiesCopyWithImpl;
  @useResult
  $Res call(
      {String creator,
      String name,
      @JsonKey(name: 'track-length') String trackLength,
      @JsonKey(name: 'filtered ascend') String filteredAscend,
      @JsonKey(name: 'plain-ascend') String plainAscend,
      @JsonKey(name: 'total-time') String totalTime,
      @JsonKey(name: 'total-energy') String totalEnergy,
      @JsonKey(name: 'voicehints') List<List<int>> voiceHints,
      String cost,
      List<List<String>> messages,
      List<double> times});
}

/// @nodoc
class _$BRouterPropertiesCopyWithImpl<$Res>
    implements $BRouterPropertiesCopyWith<$Res> {
  _$BRouterPropertiesCopyWithImpl(this._self, this._then);

  final BRouterProperties _self;
  final $Res Function(BRouterProperties) _then;

  /// Create a copy of BRouterProperties
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creator = null,
    Object? name = null,
    Object? trackLength = null,
    Object? filteredAscend = null,
    Object? plainAscend = null,
    Object? totalTime = null,
    Object? totalEnergy = null,
    Object? voiceHints = null,
    Object? cost = null,
    Object? messages = null,
    Object? times = null,
  }) {
    return _then(_self.copyWith(
      creator: null == creator
          ? _self.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      trackLength: null == trackLength
          ? _self.trackLength
          : trackLength // ignore: cast_nullable_to_non_nullable
              as String,
      filteredAscend: null == filteredAscend
          ? _self.filteredAscend
          : filteredAscend // ignore: cast_nullable_to_non_nullable
              as String,
      plainAscend: null == plainAscend
          ? _self.plainAscend
          : plainAscend // ignore: cast_nullable_to_non_nullable
              as String,
      totalTime: null == totalTime
          ? _self.totalTime
          : totalTime // ignore: cast_nullable_to_non_nullable
              as String,
      totalEnergy: null == totalEnergy
          ? _self.totalEnergy
          : totalEnergy // ignore: cast_nullable_to_non_nullable
              as String,
      voiceHints: null == voiceHints
          ? _self.voiceHints
          : voiceHints // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
      cost: null == cost
          ? _self.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _self.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<List<String>>,
      times: null == times
          ? _self.times
          : times // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _BRouterProperties extends BRouterProperties
    with DiagnosticableTreeMixin {
  const _BRouterProperties(
      {required this.creator,
      required this.name,
      @JsonKey(name: 'track-length') required this.trackLength,
      @JsonKey(name: 'filtered ascend') required this.filteredAscend,
      @JsonKey(name: 'plain-ascend') required this.plainAscend,
      @JsonKey(name: 'total-time') required this.totalTime,
      @JsonKey(name: 'total-energy') required this.totalEnergy,
      @JsonKey(name: 'voicehints') required final List<List<int>> voiceHints,
      required this.cost,
      required final List<List<String>> messages,
      required final List<double> times})
      : _voiceHints = voiceHints,
        _messages = messages,
        _times = times,
        super._();
  factory _BRouterProperties.fromJson(Map<String, dynamic> json) =>
      _$BRouterPropertiesFromJson(json);

  @override
  final String creator;
  @override
  final String name;
  @override
  @JsonKey(name: 'track-length')
  final String trackLength;
  @override
  @JsonKey(name: 'filtered ascend')
  final String filteredAscend;
  @override
  @JsonKey(name: 'plain-ascend')
  final String plainAscend;
  @override
  @JsonKey(name: 'total-time')
  final String totalTime;
  @override
  @JsonKey(name: 'total-energy')
  final String totalEnergy;
  final List<List<int>> _voiceHints;
  @override
  @JsonKey(name: 'voicehints')
  List<List<int>> get voiceHints {
    if (_voiceHints is EqualUnmodifiableListView) return _voiceHints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_voiceHints);
  }

  @override
  final String cost;
  final List<List<String>> _messages;
  @override
  List<List<String>> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  final List<double> _times;
  @override
  List<double> get times {
    if (_times is EqualUnmodifiableListView) return _times;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_times);
  }

  /// Create a copy of BRouterProperties
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BRouterPropertiesCopyWith<_BRouterProperties> get copyWith =>
      __$BRouterPropertiesCopyWithImpl<_BRouterProperties>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BRouterPropertiesToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'BRouterProperties'))
      ..add(DiagnosticsProperty('creator', creator))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('trackLength', trackLength))
      ..add(DiagnosticsProperty('filteredAscend', filteredAscend))
      ..add(DiagnosticsProperty('plainAscend', plainAscend))
      ..add(DiagnosticsProperty('totalTime', totalTime))
      ..add(DiagnosticsProperty('totalEnergy', totalEnergy))
      ..add(DiagnosticsProperty('voiceHints', voiceHints))
      ..add(DiagnosticsProperty('cost', cost))
      ..add(DiagnosticsProperty('messages', messages))
      ..add(DiagnosticsProperty('times', times));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BRouterProperties &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.trackLength, trackLength) ||
                other.trackLength == trackLength) &&
            (identical(other.filteredAscend, filteredAscend) ||
                other.filteredAscend == filteredAscend) &&
            (identical(other.plainAscend, plainAscend) ||
                other.plainAscend == plainAscend) &&
            (identical(other.totalTime, totalTime) ||
                other.totalTime == totalTime) &&
            (identical(other.totalEnergy, totalEnergy) ||
                other.totalEnergy == totalEnergy) &&
            const DeepCollectionEquality()
                .equals(other._voiceHints, _voiceHints) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            const DeepCollectionEquality().equals(other._times, _times));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      creator,
      name,
      trackLength,
      filteredAscend,
      plainAscend,
      totalTime,
      totalEnergy,
      const DeepCollectionEquality().hash(_voiceHints),
      cost,
      const DeepCollectionEquality().hash(_messages),
      const DeepCollectionEquality().hash(_times));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BRouterProperties(creator: $creator, name: $name, trackLength: $trackLength, filteredAscend: $filteredAscend, plainAscend: $plainAscend, totalTime: $totalTime, totalEnergy: $totalEnergy, voiceHints: $voiceHints, cost: $cost, messages: $messages, times: $times)';
  }
}

/// @nodoc
abstract mixin class _$BRouterPropertiesCopyWith<$Res>
    implements $BRouterPropertiesCopyWith<$Res> {
  factory _$BRouterPropertiesCopyWith(
          _BRouterProperties value, $Res Function(_BRouterProperties) _then) =
      __$BRouterPropertiesCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String creator,
      String name,
      @JsonKey(name: 'track-length') String trackLength,
      @JsonKey(name: 'filtered ascend') String filteredAscend,
      @JsonKey(name: 'plain-ascend') String plainAscend,
      @JsonKey(name: 'total-time') String totalTime,
      @JsonKey(name: 'total-energy') String totalEnergy,
      @JsonKey(name: 'voicehints') List<List<int>> voiceHints,
      String cost,
      List<List<String>> messages,
      List<double> times});
}

/// @nodoc
class __$BRouterPropertiesCopyWithImpl<$Res>
    implements _$BRouterPropertiesCopyWith<$Res> {
  __$BRouterPropertiesCopyWithImpl(this._self, this._then);

  final _BRouterProperties _self;
  final $Res Function(_BRouterProperties) _then;

  /// Create a copy of BRouterProperties
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? creator = null,
    Object? name = null,
    Object? trackLength = null,
    Object? filteredAscend = null,
    Object? plainAscend = null,
    Object? totalTime = null,
    Object? totalEnergy = null,
    Object? voiceHints = null,
    Object? cost = null,
    Object? messages = null,
    Object? times = null,
  }) {
    return _then(_BRouterProperties(
      creator: null == creator
          ? _self.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      trackLength: null == trackLength
          ? _self.trackLength
          : trackLength // ignore: cast_nullable_to_non_nullable
              as String,
      filteredAscend: null == filteredAscend
          ? _self.filteredAscend
          : filteredAscend // ignore: cast_nullable_to_non_nullable
              as String,
      plainAscend: null == plainAscend
          ? _self.plainAscend
          : plainAscend // ignore: cast_nullable_to_non_nullable
              as String,
      totalTime: null == totalTime
          ? _self.totalTime
          : totalTime // ignore: cast_nullable_to_non_nullable
              as String,
      totalEnergy: null == totalEnergy
          ? _self.totalEnergy
          : totalEnergy // ignore: cast_nullable_to_non_nullable
              as String,
      voiceHints: null == voiceHints
          ? _self._voiceHints
          : voiceHints // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
      cost: null == cost
          ? _self.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _self._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<List<String>>,
      times: null == times
          ? _self._times
          : times // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ));
  }
}

// dart format on
