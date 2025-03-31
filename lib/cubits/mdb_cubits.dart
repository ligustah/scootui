import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/redis_repository.dart';
import '../state/battery.dart';
import '../state/bluetooth.dart';
import '../state/engine.dart';
import '../state/gps.dart';
import '../state/vehicle.dart';
import 'syncable_cubit.dart';

class EngineSync extends SyncableCubit<EngineData> {
  static EngineData watch(BuildContext context) =>
      context.watch<EngineSync>().state;

  static EngineSync create(BuildContext context) =>
      EngineSync(RepositoryProvider.of<RedisRepository>(context))..start();

  EngineSync(RedisRepository repo)
      : super(redisRepository: repo, initialState: EngineData());
}

class VehicleSync extends SyncableCubit<VehicleData> {
  static VehicleData watch(BuildContext context) =>
      context.watch<VehicleSync>().state;

  static VehicleSync create(BuildContext context) =>
      VehicleSync(RepositoryProvider.of<RedisRepository>(context))..start();

  VehicleSync(RedisRepository repo)
      : super(redisRepository: repo, initialState: VehicleData());
}

class BatterySync extends SyncableCubit<BatteryData> {
  BatterySync(RedisRepository repo, String id)
      : super(redisRepository: repo, initialState: BatteryData(id: id));
}

class Battery1Sync extends BatterySync {
  static BatteryData watch(BuildContext context) =>
      context.watch<Battery1Sync>().state;

  static Battery1Sync create(BuildContext context) =>
      Battery1Sync(RepositoryProvider.of<RedisRepository>(context))..start();

  Battery1Sync(RedisRepository repo) : super(repo, "0");
}

class Battery2Sync extends BatterySync {
  static BatteryData watch(BuildContext context) =>
      context.watch<Battery2Sync>().state;

  static Battery2Sync create(BuildContext context) =>
      Battery2Sync(RepositoryProvider.of<RedisRepository>(context))..start();

  Battery2Sync(RedisRepository repo) : super(repo, "1");
}

class BluetoothSync extends SyncableCubit<BluetoothData> {
  static BluetoothData watch(BuildContext context) =>
      context.watch<BluetoothSync>().state;

  static BluetoothSync create(BuildContext context) =>
      BluetoothSync(RepositoryProvider.of<RedisRepository>(context))..start();

  BluetoothSync(RedisRepository repo)
      : super(redisRepository: repo, initialState: BluetoothData());
}

class GpsSync extends SyncableCubit<GpsData> {
  static GpsData watch(BuildContext context) =>
      context.watch<GpsSync>().state;

  static GpsSync create(BuildContext context) =>
      GpsSync(RepositoryProvider.of<RedisRepository>(context))..start();

  GpsSync(RedisRepository repo)
      : super(redisRepository: repo, initialState: GpsData());
}
