import 'dart:convert';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:github/github.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scooter_cluster/services/task_service.dart';
import 'package:scooter_cluster/services/valhalla_service_controller.dart';
import 'package:scooter_cluster/utils/toast_utils.dart';

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
  Directory? _appDir;

  TilesUpdateRepository(this._taskService, this._valhallaServiceController)
      : _gitHub = GitHub();

  Future<Directory> getAppDir() async {
    _appDir ??= await getApplicationDocumentsDirectory();
    return _appDir!;
  }

  Future<String> get _valhallaPath async =>
      '${(await getAppDir()).path}/valhalla.tar';
  Future<String> get _osmPath async =>
      '${(await getAppDir()).path}/maps/map.mbtiles.tmp';

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

    final valhallaPath = await _valhallaPath;
    final osmPath = await _osmPath;

    if (remoteDates.valhallaDate.isAfter(
        _latestTilesVersions.releaseDates?.valhallaDate ??
            DateTime.fromMillisecondsSinceEpoch(0))) {
      final downloadTask = DownloadTask(
        url: region.valhallaUrl,
        destination: '$valhallaPath.tmp',
      );

      // Add the task and wait for completion
      _taskService.addTask(downloadTask);
      final status = await downloadTask.wait();

      switch (status) {
        case TaskCompleted():
          print(
              'downloaded valhalla tiles ${remoteDates.valhallaDate} to ${valhallaPath}.tmp');
        // await applyValhallaUpdate(
        //     '$valhallaPath.tmp', remoteDates.valhallaDate);
        case TaskError(:final message):
          throw Exception('Failed to download Valhalla tiles: $message');
        default:
        // Should not happen as wait() only returns terminal states
      }
    }

    if (remoteDates.osmDate.isAfter(
        _latestTilesVersions.releaseDates?.osmDate ??
            DateTime.fromMillisecondsSinceEpoch(0))) {
      final downloadTask = DownloadTask(
        url: region.osmTilesUrl,
        destination: '$osmPath.tmp',
      );

      // Add the task and wait for completion
      _taskService.addTask(downloadTask);
      final status = await downloadTask.wait();

      switch (status) {
        case TaskCompleted():
          print(
              'downloaded osm tiles ${remoteDates.osmDate} to ${osmPath}.tmp');
          await applyOsmUpdate('$osmPath.tmp', remoteDates.osmDate);
        case TaskError(:final message):
          throw Exception('Failed to download OSM tiles: $message');
        default:
        // Should not happen as wait() only returns terminal states
      }
    }
  }

  Future<void> applyValhallaUpdate(String tempPath, DateTime newVersion) async {
    await _valhallaServiceController.stop();

    final valhallaPath = await _valhallaPath;

    try {
      final valhallaFile = File(valhallaPath);
      if (await valhallaFile.exists()) {
        await valhallaFile.rename('$valhallaPath.bak');
      }
      await File(tempPath).rename(valhallaPath);

      await _valhallaServiceController.start();

      // if we successfully started, update version and delete backup
      await setValhallaDate(newVersion);
      final backupFile = File('$valhallaPath.bak');
      if (await backupFile.exists()) {
        await backupFile.delete();
      }
    } catch (e) {
      // rollback
      final backupFile = File('$valhallaPath.bak');
      if (await backupFile.exists()) {
        await backupFile.rename(valhallaPath);
      }
      await _valhallaServiceController.start();
      rethrow;
    }
  }

  Future<void> applyOsmUpdate(String tempPath, DateTime newVersion) async {
    final osmPath = await _osmPath;
    final osmFile = File('$osmPath.new');
    if (await osmFile.exists()) {
      await osmFile.delete();
    }
    await File(tempPath).rename('$osmPath.new');
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
