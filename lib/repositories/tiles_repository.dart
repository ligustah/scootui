import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:path_provider/path_provider.dart';

part 'tiles_repository.freezed.dart';

@freezed
sealed class Tiles with _$Tiles {
  const factory Tiles.success(MbTiles mbTiles) = Success;
  const factory Tiles.notFound() = NotFound;
  const factory Tiles.error(String message) = Error;
}

class TilesRepository {
  static TilesRepository create(BuildContext context) => TilesRepository();

  Future<String?> getMapHash() async {
    final mapPath = await getMapFilename();
    if (mapPath == null) {
      return null;
    }

    final file = File(mapPath);
    return await file
        .openRead()
        .transform(sha256)
        .map((digest) => digest.toString())
        .first;
  }

  Future<String?> getMapFilename() async {
    late final Directory appDir;

    try {
      appDir = await getApplicationDocumentsDirectory();
    } catch (e) {
      return null;
    }

    return '${appDir.path}/maps/map.mbtiles';
  }

  Future<Tiles> getMbTiles() async {
    final mapPath = await getMapFilename();
    if (mapPath == null) {
      return const Tiles.error(
          "Could not determine application documents directory");
    }

    if (!File(mapPath).existsSync()) {
      return const Tiles.notFound();
    }

    final mbTiles = MbTiles(mbtilesPath: mapPath);
    return Tiles.success(mbTiles);
  }
}
