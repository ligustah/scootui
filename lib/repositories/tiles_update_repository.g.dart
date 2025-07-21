// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiles_update_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TilesVersions _$TilesVersionsFromJson(Map<String, dynamic> json) =>
    _TilesVersions(
      region: json['region'] as String?,
      releaseDates: json['releaseDates'] == null
          ? null
          : TilesReleaseDates.fromJson(
              json['releaseDates'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TilesVersionsToJson(_TilesVersions instance) =>
    <String, dynamic>{
      'region': instance.region,
      'releaseDates': instance.releaseDates,
    };

_TilesReleaseDates _$TilesReleaseDatesFromJson(Map<String, dynamic> json) =>
    _TilesReleaseDates(
      valhallaDate: DateTime.parse(json['valhallaDate'] as String),
      osmDate: DateTime.parse(json['osmDate'] as String),
    );

Map<String, dynamic> _$TilesReleaseDatesToJson(_TilesReleaseDates instance) =>
    <String, dynamic>{
      'valhallaDate': instance.valhallaDate.toIso8601String(),
      'osmDate': instance.osmDate.toIso8601String(),
    };
