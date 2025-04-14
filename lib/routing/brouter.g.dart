// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brouter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BRouterProperties _$BRouterPropertiesFromJson(Map<String, dynamic> json) =>
    _BRouterProperties(
      creator: json['creator'] as String,
      name: json['name'] as String,
      trackLength: json['track-length'] as String,
      filteredAscend: json['filtered ascend'] as String,
      plainAscend: json['plain-ascend'] as String,
      totalTime: json['total-time'] as String,
      totalEnergy: json['total-energy'] as String,
      voiceHints: (json['voicehints'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      cost: json['cost'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      times: (json['times'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$BRouterPropertiesToJson(_BRouterProperties instance) =>
    <String, dynamic>{
      'creator': instance.creator,
      'name': instance.name,
      'track-length': instance.trackLength,
      'filtered ascend': instance.filteredAscend,
      'plain-ascend': instance.plainAscend,
      'total-time': instance.totalTime,
      'total-energy': instance.totalEnergy,
      'voicehints': instance.voiceHints,
      'cost': instance.cost,
      'messages': instance.messages,
      'times': instance.times,
    };
