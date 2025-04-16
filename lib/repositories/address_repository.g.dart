// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
      id: json['id'] as String,
      coordinates: LatLng.fromJson(json['coordinates'] as Map<String, dynamic>),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
      'id': instance.id,
      'coordinates': instance.coordinates,
      'x': instance.x,
      'y': instance.y,
    };

_AddressDatabase _$AddressDatabaseFromJson(Map<String, dynamic> json) =>
    _AddressDatabase(
      mapHash: json['mapHash'] as String,
      addresses: (json['addresses'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Address.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$AddressDatabaseToJson(_AddressDatabase instance) =>
    <String, dynamic>{
      'mapHash': instance.mapHash,
      'addresses': instance.addresses,
    };
