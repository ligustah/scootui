import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../repositories/address_repository.dart';

part 'map_service.freezed.dart';

/// Exception thrown when the map data is not available or fails to load.
class MapUnavailableException implements Exception {
  final String message;
  MapUnavailableException(this.message);
  @override
  String toString() => 'MapUnavailableException: $message';
}

class MapService {
  late final Isolate _isolate;
  late final SendPort _sendPort;
  final _receivePort = ReceivePort();

  final _pendingTileRequests = <String, Completer<Uint8List>>{};
  final _pendingAddressRequests = <String, Completer<Address?>>{};
  final _pendingUpdateRequests = <String, Completer<void>>{};
  final _initCompleter = Completer<MbTilesMetadata>();
  int _nextRequestId = 0;

  MapService();

  /// Initializes the map service and starts the background isolate.
  /// This should be called once at startup.
  Future<void> init() async {
    _receivePort.listen(_handleResponse);
    final token = RootIsolateToken.instance;
    if (token == null) {
      throw Exception('RootIsolateToken is not available');
    }
    _isolate = await Isolate.spawn(
      _startRemoteIsolate,
      _IsolateInit(
        sendPort: _receivePort.sendPort,
        token: token,
      ),
    );
  }

  /// Returns the map metadata. Throws [MapUnavailableException] if initialization fails.
  Future<MbTilesMetadata> getMetadata() => _initCompleter.future;

  Future<String?> getMapFilename() async {
    // This logic is now part of the service.
    try {
      final appDir = await getApplicationDocumentsDirectory();
      return '${appDir.path}/maps/map.mbtiles';
    } catch (e) {
      return null;
    }
  }

  Future<void> updateMap(String newMapPath) {
    final requestId = (_nextRequestId++).toString();
    final completer = Completer<void>();
    _pendingUpdateRequests[requestId] = completer;
    _sendPort.send(Request.reloadMap(requestId, newMapPath));
    return completer.future;
  }

  Future<Uint8List> getTile(TileIdentity tile) {
    final requestId = '${tile.z}/${tile.x}/${tile.y}';
    final completer = Completer<Uint8List>();
    _pendingTileRequests[requestId] = completer;
    _sendPort.send(Request.getTile(requestId, tile));
    return completer.future;
  }

  Future<Address?> findAddress(String id) {
    final completer = Completer<Address?>();
    _pendingAddressRequests[id] = completer;
    _sendPort.send(Request.findAddress(id));
    return completer.future;
  }

  void _handleResponse(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _sendPort.send(const Request.init());
    } else if (message is Response) {
      switch (message) {
        case _InitResponse(:final metadata):
          _initCompleter.complete(metadata);
        case _ErrorResponse(:final message):
          _initCompleter.completeError(MapUnavailableException(message));
        case _TileResponse(:final requestId, :final tile):
          _pendingTileRequests.remove(requestId)?.complete(tile);
        case _TileErrorResponse(:final requestId, :final message):
          _pendingTileRequests
              .remove(requestId)
              ?.completeError(Exception(message));
        case _AddressResponse(:final requestId, :final address):
          _pendingAddressRequests.remove(requestId)?.complete(address);
        case _UpdateSuccessResponse(:final requestId):
          _pendingUpdateRequests.remove(requestId)?.complete();
        case _UpdateErrorResponse(:final requestId, :final message):
          _pendingUpdateRequests
              .remove(requestId)
              ?.completeError(MapUnavailableException(message));
      }
    }
  }

  void dispose() {
    _sendPort.send(const Request.dispose());
    _receivePort.close();
    _isolate.kill(priority: Isolate.immediate);
    for (final request in _pendingTileRequests.values) {
      request.completeError('Isolate disposed');
    }
    for (final request in _pendingAddressRequests.values) {
      request.completeError('Isolate disposed');
    }
    for (final request in _pendingUpdateRequests.values) {
      request.completeError('Isolate disposed');
    }
  }
}

// --- Isolate Code ---

void _startRemoteIsolate(_IsolateInit init) {
  BackgroundIsolateBinaryMessenger.ensureInitialized(init.token);
  final receivePort = ReceivePort();
  init.sendPort.send(receivePort.sendPort);
  final isolateHandler = _MapServiceIsolateHandler(init.sendPort);

  receivePort.listen((message) {
    isolateHandler.handle(message);
  });
}

class _MapServiceIsolateHandler {
  final SendPort _sendPort;
  MbTiles? _mbTiles;
  sqlite.Database? _db;

  _MapServiceIsolateHandler(this._sendPort);

  Future<String> _getMapFilename() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      return '${appDir.path}/maps/map.mbtiles';
    } catch (e) {
      throw Exception(
          "Could not determine application documents directory: $e");
    }
  }

  Future<MbTiles> _getMbTiles() async {
    final mapPath = await _getMapFilename();
    if (!File(mapPath).existsSync()) {
      throw MapUnavailableException('Map file not found at $mapPath');
    }
    return MbTiles(mbtilesPath: mapPath);
  }

  Future<void> handle(dynamic message) async {
    if (message is! Request) return;

    switch (message) {
      case _InitRequest():
        try {
          // Load tiles handle
          _mbTiles = await _getMbTiles();

          // Load address query handle
          final dbPath = await _getMapFilename();
          _db = sqlite.sqlite3.open(dbPath, mode: sqlite.OpenMode.readOnly);

          _sendPort.send(Response.init(_mbTiles!.getMetadata()));
        } catch (e) {
          _sendPort.send(Response.error(e.toString()));
        }

      case _GetTileRequest(:final requestId, :final tile):
        if (_mbTiles == null) {
          _sendPort
              .send(Response.tileError(requestId, 'MBTiles not initialized'));
          return;
        }
        // The TMS Y coordinate needs to be flipped for mbtiles
        final tmsY = ((1 << tile.z) - 1) - tile.y;
        final tileData = _mbTiles!.getTile(x: tile.x, y: tmsY, z: tile.z);
        if (tileData != null) {
          _sendPort.send(Response.tile(requestId, tileData));
        } else {
          _sendPort.send(Response.tileError(requestId, 'Tile not found'));
        }

      case _FindAddressRequest(:final id):
        if (_db == null) {
          _sendPort.send(Response.address(id, null));
          return;
        }
        try {
          final result = _db!.select(
              "SELECT lat, lng, id, x, y FROM addresses WHERE id = ?",
              [id]).firstOrNull;

          if (result == null) {
            _sendPort.send(Response.address(id, null));
          } else {
            final lat = result['lat'] as double;
            final lng = result['lng'] as double;
            final address = Address(
              id: result['id'] as String,
              coordinates: LatLng(lat, lng),
              x: (result['x'] as int).toDouble(),
              y: (result['y'] as int).toDouble(),
            );
            _sendPort.send(Response.address(id, address));
          }
        } catch (e) {
          // In case of SQL error, etc.
          _sendPort.send(Response.address(id, null));
        }

      case _ReloadMapRequest(:final requestId, :final newMapPath):
        try {
          print('Unloading current databases');
          // 1. Unload current databases
          _mbTiles?.dispose();
          _mbTiles = null;
          _db?.dispose();
          _db = null;

          // 2. Rename old file to backup
          final oldMapPath = await _getMapFilename();
          final oldMapFile = File(oldMapPath);
          final backupMapPath = '$oldMapPath.bak';
          if (await oldMapFile.exists()) {
            // This is a workaround for Windows, where it takes a moment for the process
            // to release the file lock after dispose() is called.
            for (var i = 0; i < 100; i++) {
              try {
                await oldMapFile.rename(backupMapPath);
                break; // Success
              } catch (e) {
                print('Error renaming old map file: $e');
                if (i == 99) rethrow; // Rethrow after final attempt

                print('Retrying in 500ms');
                await Future.delayed(const Duration(milliseconds: 500));
              }
            }
          }

          // 3. Rename new file to primary
          await File(newMapPath).rename(oldMapPath);

          // 4. Try to load new databases
          _mbTiles = await _getMbTiles();
          _db = sqlite.sqlite3.open(oldMapPath, mode: sqlite.OpenMode.readOnly);

          // 5. Success: delete backup & notify caller
          final backupFile = File(backupMapPath);
          if (await backupFile.exists()) {
            await backupFile.delete();
          }
          _sendPort.send(Response.updateSuccess(requestId));
        } catch (e) {
          // Failure: Rollback
          try {
            final oldMapPath = await _getMapFilename();
            final backupMapPath = '$oldMapPath.bak';
            if (await File(backupMapPath).exists()) {
              await File(backupMapPath).rename(oldMapPath);
            }
            // CRUCIAL: Always try to re-open the database handles after a rollback attempt.
            // This covers both cases: restoring a backup, or the original rename failing.
            _mbTiles = await _getMbTiles();
            _db =
                sqlite.sqlite3.open(oldMapPath, mode: sqlite.OpenMode.readOnly);
          } catch (rollbackError) {
            // If rollback fails, we are in a bad state. The service will be unusable.
            print("CRITICAL: Map rollback failed: $rollbackError");
          }
          _sendPort.send(Response.updateError(requestId, e.toString()));
        }

      case _DisposeRequest():
        _mbTiles?.dispose();
        _db?.dispose();
        Isolate.exit();
    }
  }
}

class _IsolateInit {
  final SendPort sendPort;
  final RootIsolateToken token;

  _IsolateInit({
    required this.sendPort,
    required this.token,
  });
}

@freezed
sealed class Request with _$Request {
  const factory Request.init() = _InitRequest;
  const factory Request.getTile(String requestId, TileIdentity tile) =
      _GetTileRequest;
  const factory Request.findAddress(String id) = _FindAddressRequest;
  const factory Request.reloadMap(String requestId, String newMapPath) =
      _ReloadMapRequest;
  const factory Request.dispose() = _DisposeRequest;
}

@freezed
sealed class Response with _$Response {
  const factory Response.init(MbTilesMetadata metadata) = _InitResponse;
  const factory Response.error(String message) = _ErrorResponse;
  const factory Response.tile(String requestId, Uint8List tile) = _TileResponse;
  const factory Response.tileError(String requestId, String message) =
      _TileErrorResponse;
  const factory Response.address(String requestId, Address? address) =
      _AddressResponse;
  const factory Response.updateSuccess(String requestId) =
      _UpdateSuccessResponse;
  const factory Response.updateError(String requestId, String message) =
      _UpdateErrorResponse;
}
