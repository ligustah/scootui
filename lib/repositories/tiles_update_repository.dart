import 'dart:convert';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:github/github.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scooter_cluster/services/task_service.dart';
import 'package:scooter_cluster/services/valhalla_service_controller.dart';

import '../map/download/download_task.dart';

part 'tiles_update_repository.freezed.dart';
part 'tiles_update_repository.g.dart';

class Region {
  final String name;
  final String identifier;

  const Region(this.name, this.identifier);

  String get valhallaUrl =>
      'https://github.com/librescoot/valhalla-tiles/releases/download/latest/valhalla_tiles_$identifier.tar';

  String get osmTilesUrl =>
      'https://github.com/librescoot/osm-tiles/releases/download/latest/tiles_$identifier.mbtiles';
}

const regions = [
  Region('Baden-Württemberg', 'baden-wuerttemberg'),
  Region('Bayern', 'bayern'),
  Region('Berlin', 'berlin'),
  Region('Brandenburg', 'brandenburg'),
  Region('Bremen', 'bremen'),
  Region('Hamburg', 'hamburg'),
  Region('Hessen', 'hessen'),
  Region('Mecklenburg-Vorpommern', 'mecklenburg-vorpommern'),
  Region('Niedersachsen', 'niedersachsen'),
  Region('Nordrhein-Westfalen', 'nordrhein-westfalen'),
  Region('Rheinland-Pfalz', 'rheinland-pfalz'),
  Region('Saarland', 'saarland'),
  Region('Sachsen', 'sachsen'),
  Region('Sachsen-Anhalt', 'sachsen-anhalt'),
  Region('Schleswig-Holstein', 'schleswig-holstein'),
  Region('Thüringen', 'thueringen'),
];

Region regionByName(String name) =>
    regions.firstWhere((region) => region.name == name);

final valhallaSlug = RepositorySlug("librescoot", "valhalla-tiles");
final osmSlug = RepositorySlug("librescoot", "osm-tiles");

@freezed
abstract class TilesVersions with _$TilesVersions {
  const TilesVersions._();

  const factory TilesVersions({
    String? region,
    TilesReleaseDates? releaseDates,
  }) = _TilesVersions;

  factory TilesVersions.fromJson(Map<String, dynamic> json) =>
      _$TilesVersionsFromJson(json);
}

@freezed
abstract class TilesReleaseDates with _$TilesReleaseDates {
  const TilesReleaseDates._();

  const factory TilesReleaseDates({
    required DateTime valhallaDate,
    required DateTime osmDate,
  }) = _TilesReleaseDates;

  factory TilesReleaseDates.empty() => TilesReleaseDates(
      valhallaDate: DateTime(1970, 1, 1), osmDate: DateTime(1970, 1, 1));

  factory TilesReleaseDates.fromJson(Map<String, dynamic> json) =>
      _$TilesReleaseDatesFromJson(json);
}

class TilesUpdateRepository {
  final GitHub _gitHub;
  final TaskService _taskService;
  final ValhallaServiceController _valhallaServiceController;

  TilesVersions _latestTilesVersions = TilesVersions();

  TilesUpdateRepository(this._taskService, this._valhallaServiceController)
      : _gitHub = GitHub();

  Future<Directory> getAppDir() async =>
      await getApplicationDocumentsDirectory();

  String get _valhallaPath => '${(getAppDir() as Directory).path}/valhalla.tar';
  String get _osmPath => '${(getAppDir() as Directory).path}/map.mbtiles';

  Future<void> loadLatestTilesVersions() async {
    final appDir = await getAppDir();

    final tilesVersionsFile = File('${appDir.path}/tiles_versions.json');

    if (await tilesVersionsFile.exists()) {
      _latestTilesVersions = TilesVersions.fromJson(
          json.decode(await tilesVersionsFile.readAsString()));
    }
  }

  Future<void> saveLatestTilesVersions() async {
    final appDir = await getAppDir();
    final tilesVersionsFile = File('${appDir.path}/tiles_versions.json');
    await tilesVersionsFile.writeAsString(json.encode(_latestTilesVersions));
  }

  Future<void> setRegion(Region region) async {
    if (_latestTilesVersions.region == region.name) {
      return;
    }

    // changing the region will reset the release dates
    _latestTilesVersions = TilesVersions(region: region.name);
    await saveLatestTilesVersions();
  }

  Future<void> setOsmDate(DateTime date) async {
    _latestTilesVersions = _latestTilesVersions.copyWith(
        releaseDates:
            _latestTilesVersions.releaseDates?.copyWith(osmDate: date) ??
                TilesReleaseDates(
                    valhallaDate: DateTime.fromMillisecondsSinceEpoch(0),
                    osmDate: date));
    await saveLatestTilesVersions();
  }

  Future<void> setValhallaDate(DateTime date) async {
    _latestTilesVersions = _latestTilesVersions.copyWith(
        releaseDates:
            _latestTilesVersions.releaseDates?.copyWith(valhallaDate: date) ??
                TilesReleaseDates(
                    valhallaDate: date,
                    osmDate: DateTime.fromMillisecondsSinceEpoch(0)));
    await saveLatestTilesVersions();
  }

  Future<void> checkForUpdates() async {
    if (_latestTilesVersions.region == null) {
      return;
    }

    final region = regionByName(_latestTilesVersions.region!);
    final remoteDates = await getReleaseDates();

    if (remoteDates.valhallaDate.isAfter(
        _latestTilesVersions.releaseDates?.valhallaDate ??
            DateTime.fromMillisecondsSinceEpoch(0))) {
      final downloadTask = DownloadTask(
        url: region.valhallaUrl,
        destination: '$_valhallaPath.tmp',
      );
      // This is now a blocking operation, which is not ideal.
      // We may want to revisit this to make it fully background.
      await _taskService.addTask(downloadTask);
      await applyValhallaUpdate('$_valhallaPath.tmp', remoteDates.valhallaDate);
    }

    if (remoteDates.osmDate.isAfter(
        _latestTilesVersions.releaseDates?.osmDate ??
            DateTime.fromMillisecondsSinceEpoch(0))) {
      final downloadTask = DownloadTask(
        url: region.osmTilesUrl,
        destination: '$_osmPath.tmp',
      );
      // This is now a blocking operation.
      await _taskService.addTask(downloadTask);
      await applyOsmUpdate('$_osmPath.tmp', remoteDates.osmDate);
    }
  }

  Future<void> applyValhallaUpdate(String tempPath, DateTime newVersion) async {
    await _valhallaServiceController.stop();

    try {
      final valhallaFile = File(_valhallaPath);
      if (await valhallaFile.exists()) {
        await valhallaFile.rename('$_valhallaPath.bak');
      }
      await File(tempPath).rename(_valhallaPath);

      await _valhallaServiceController.start();

      // if we successfully started, update version and delete backup
      await setValhallaDate(newVersion);
      final backupFile = File('$_valhallaPath.bak');
      if (await backupFile.exists()) {
        await backupFile.delete();
      }
    } catch (e) {
      // rollback
      final backupFile = File('$_valhallaPath.bak');
      if (await backupFile.exists()) {
        await backupFile.rename(_valhallaPath);
      }
      await _valhallaServiceController.start();
      rethrow;
    }
  }

  Future<void> applyOsmUpdate(String tempPath, DateTime newVersion) async {
    final osmFile = File('$_osmPath.new');
    if (await osmFile.exists()) {
      await osmFile.delete();
    }
    await File(tempPath).rename('$_osmPath.new');
    // The MapCubit will handle the rest on next startup.
    // It will also be responsible for calling setOsmDate.
  }

  Future<TilesReleaseDates> getReleaseDates() async {
    final valhallaRelease =
        await _gitHub.repositories.getLatestRelease(valhallaSlug);
    final osmRelease = await _gitHub.repositories.getLatestRelease(osmSlug);

    final valhallaDate = valhallaRelease.publishedAt;
    final osmDate = osmRelease.publishedAt;

    if (valhallaDate == null || osmDate == null) {
      throw Exception('Failed to get release dates');
    }

    return TilesReleaseDates(
      valhallaDate: valhallaDate,
      osmDate: osmDate,
    );
  }
}
