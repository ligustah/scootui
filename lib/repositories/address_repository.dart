import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_tile/vector_tile.dart';

import 'tiles_repository.dart' as tiles;

part 'address_repository.freezed.dart';
part 'address_repository.g.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    required String id,
    required LatLng coordinates,
    required double x,
    required double y,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

@freezed
abstract class AddressDatabase with _$AddressDatabase {
  const factory AddressDatabase({
    required String mapHash,
    required Map<String, Address> addresses,
  }) = _AddressDatabase;

  factory AddressDatabase.fromJson(Map<String, dynamic> json) =>
      _$AddressDatabaseFromJson(json);
}

@freezed
sealed class Addresses with _$Addresses {
  const factory Addresses.success(AddressDatabase database) = Success;
  const factory Addresses.notFound() = NotFound;
  const factory Addresses.error(String message) = Error;
}

const _addressDatabaseFilename = 'address_database.json';

class AddressRepository {
  static AddressRepository create(BuildContext context) => AddressRepository();

  Future<Addresses> loadDatabase() async {
    final token = RootIsolateToken.instance;

    return await Isolate.run(() async {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token!);

      final file = await _getFile();
      if (file == null) {
        return const Addresses.error('File not found');
      }

      if (!await file.exists()) {
        return const Addresses.notFound();
      }

      final json = await file.readAsString();
      return Addresses.success(AddressDatabase.fromJson(jsonDecode(json)));
    });
  }

  Future<Addresses> buildDatabase(tiles.TilesRepository tilesRepository) async {
    final token = RootIsolateToken.instance;

    return await Isolate.run(() async {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token!);

      final addresses = await _processTiles(tilesRepository);

      Future<Addresses> saveAndReturnDatabase(AddressDatabase database) async {
        await _saveDatabase(database);
        return Addresses.success(database);
      }

      return switch (addresses) {
        Success(:final database) => await saveAndReturnDatabase(database),
        NotFound() => const Addresses.error('Map hash not found'),
        Error(:final message) => Addresses.error(message),
      };
    });
  }

  Future<File?> _getFile() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      return File('${appDir.path}/scootui/$_addressDatabaseFilename');
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveDatabase(AddressDatabase database) async {
    final file = await _getFile();
    if (file == null) {
      // TODO: actually handle this
      return;
    }

    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(database.toJson()));
  }
}

String _toBase32(int number) {
  const chars = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
  if (number == 0) return '0';
  var result = '';
  while (number > 0) {
    result = chars[number % 32] + result;
    number = number ~/ 32;
  }
  return result;
}

Future<Addresses> _processTiles(tiles.TilesRepository tilesRepository) async {
  final mapHash = await tilesRepository.getMapHash();
  if (mapHash == null) {
    return const Addresses.error('Map hash not found');
  }

  final mbTiles = await tilesRepository.getMbTiles();
  switch (mbTiles) {
    case tiles.Success(:final mbTiles):
      final addresses = _extractAddresses(mbTiles);
      mbTiles.dispose();
      return Addresses.success(
          AddressDatabase(mapHash: mapHash, addresses: addresses));
    case tiles.NotFound():
      return const Addresses.error('Map not found');
    case tiles.Error(:final message):
      return Addresses.error(message);
  }
}

Map<String, Address> _extractAddresses(MbTiles mbTiles) {
  final addresses = <String, Address>{};
  final coordinates = _getTileCoordinatesForBounds(mbTiles, 14);
  var currentAddressId = 0;

  for (var coordinate in coordinates) {
    final tile = mbTiles.getTile(x: coordinate.x, y: coordinate.y, z: 14);
    if (tile == null) {
      continue;
    }

    final vectorTile = VectorTile.fromBytes(bytes: tile);
    try {
      final addressesLayer =
          vectorTile.layers.firstWhere((layer) => layer.name == 'addresses');
      final features = addressesLayer.features;
      final extent = addressesLayer.extent;

      for (var feature in features) {
        final geometry = feature.decodeGeometry();
        if (geometry is GeometryPoint) {
          final coordinates = geometry.coordinates;
          // Convert from tile coordinates to geographic coordinates
          final n = math.pow(2.0, 14).toDouble();
          final lon =
              (coordinate.x + coordinates[0] / extent) / n * 360.0 - 180.0;
          final y = 1 -
              (coordinate.y + coordinates[1] / extent) / n; // Flip y for TMS
          final z = math.pi * (1 - 2 * y);
          final latRad = math.atan((math.exp(z) - math.exp(-z)) / 2);
          final lat = latRad * 180.0 / math.pi;

          // Assign ID and create mapping
          final id = currentAddressId++;
          final base32Id = _toBase32(id);
          addresses[base32Id] = Address(
              id: base32Id,
              coordinates: LatLng(lat, lon),
              x: coordinates[0],
              y: coordinates[1]);
        }
      }
    } on StateError {
      continue;
    }
  }

  return addresses;
}

List<math.Point<int>> _getTileCoordinatesForBounds(MbTiles tiles, int zoom) {
  final meta = tiles.getMetadata();
  final bounds = meta.bounds;
  if (bounds == null) {
    throw Exception('No bounds found in MBTiles metadata');
  }

  final minTileX = _lonToTileX(bounds.left, zoom);
  final maxTileX = _lonToTileX(bounds.right, zoom);
  final minTileY = _latToTileYTMS(bounds.top, zoom);
  final maxTileY = _latToTileYTMS(bounds.bottom, zoom);
  final coordinates = <math.Point<int>>[];

  for (var x = minTileX; x <= maxTileX; x++) {
    final startY = math.min(minTileY, maxTileY);
    final endY = math.max(minTileY, maxTileY);

    for (var y = startY; y <= endY; y++) {
      coordinates.add(math.Point(x, y));
    }
  }

  return coordinates;
}

int _lonToTileX(double lon, int zoom) {
  final x = ((lon + 180) / 360 * (1 << zoom)).floor();
  return x;
}

int _latToTileYTMS(double lat, int zoom) {
  final latRad = lat * (math.pi / 180);
  final n = math.pow(2.0, zoom).toDouble();
  final y =
      (1.0 - math.log(math.tan(latRad) + 1.0 / math.cos(latRad)) / math.pi) /
          2.0 *
          n;
  final tmsY = (n - 1 - y).floor();
  return tmsY + 1;
}
