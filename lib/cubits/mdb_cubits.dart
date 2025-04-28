import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/mdb_repository.dart';
import '../state/battery.dart';
import '../state/bluetooth.dart';
import '../state/engine.dart';
import '../state/gps.dart';
import '../state/internet.dart';
import '../state/navigation.dart';
import '../state/ota.dart';
import '../state/vehicle.dart';
import 'syncable_cubit.dart';

class EngineSync extends SyncableCubit<EngineData> {
  static EngineData watch(BuildContext context) => context.watch<EngineSync>().state;

  static EngineSync create(BuildContext context) => EngineSync(RepositoryProvider.of<MDBRepository>(context))..start();

  static T select<T>(BuildContext context, T Function(EngineData) selector) =>
      selector(context.select((EngineSync e) => e.state));

  EngineSync(MDBRepository repo) : super(redisRepository: repo, initialState: EngineData());
}

class VehicleSync extends SyncableCubit<VehicleData> {
  static VehicleData watch(BuildContext context) => context.watch<VehicleSync>().state;

  static VehicleSync create(BuildContext context) =>
      VehicleSync(RepositoryProvider.of<MDBRepository>(context))..start();

  VehicleSync(MDBRepository repo) : super(redisRepository: repo, initialState: VehicleData());

  void toggleHazardLights() {
    final command = state.blinkerState == BlinkerState.both ? BlinkerState.off : BlinkerState.both;

    super.redisRepository.push("scooter:blinker", command.name);
  }
}

class BatterySync extends SyncableCubit<BatteryData> {
  BatterySync(MDBRepository repo, String id) : super(redisRepository: repo, initialState: BatteryData(id: id));
}

class Battery1Sync extends BatterySync {
  static BatteryData watch(BuildContext context) => context.watch<Battery1Sync>().state;

  static Battery1Sync create(BuildContext context) =>
      Battery1Sync(RepositoryProvider.of<MDBRepository>(context))..start();

  Battery1Sync(MDBRepository repo) : super(repo, "0");
}

class Battery2Sync extends BatterySync {
  static BatteryData watch(BuildContext context) => context.watch<Battery2Sync>().state;

  static Battery2Sync create(BuildContext context) =>
      Battery2Sync(RepositoryProvider.of<MDBRepository>(context))..start();

  Battery2Sync(MDBRepository repo) : super(repo, "1");
}

class BluetoothSync extends SyncableCubit<BluetoothData> {
  static BluetoothData watch(BuildContext context) => context.watch<BluetoothSync>().state;

  static BluetoothSync create(BuildContext context) =>
      BluetoothSync(RepositoryProvider.of<MDBRepository>(context))..start();

  BluetoothSync(MDBRepository repo) : super(redisRepository: repo, initialState: BluetoothData());
}

class GpsSync extends SyncableCubit<GpsData> {
  static GpsData watch(BuildContext context) => context.watch<GpsSync>().state;

  static GpsSync create(BuildContext context) => GpsSync(RepositoryProvider.of<MDBRepository>(context))..start();

  GpsSync(MDBRepository repo) : super(redisRepository: repo, initialState: GpsData());
}

class InternetSync extends SyncableCubit<InternetData> {
  static InternetData watch(BuildContext context) => context.watch<InternetSync>().state;

  static InternetSync create(BuildContext context) =>
      InternetSync(RepositoryProvider.of<MDBRepository>(context))..start();

  InternetSync(MDBRepository repo) : super(redisRepository: repo, initialState: InternetData());
}

class NavigationSync extends SyncableCubit<NavigationData> {
  static NavigationData watch(BuildContext context) => context.watch<NavigationSync>().state;

  static NavigationSync create(BuildContext context) =>
      NavigationSync(RepositoryProvider.of<MDBRepository>(context))..start();

  NavigationSync(MDBRepository repo) : super(redisRepository: repo, initialState: NavigationData());
}

class OtaSync extends SyncableCubit<OtaData> {
  static OtaData watch(BuildContext context) => context.watch<OtaSync>().state;

  static OtaSync create(BuildContext context) => OtaSync(RepositoryProvider.of<MDBRepository>(context))..start();

  OtaSync(MDBRepository repo) : super(redisRepository: repo, initialState: OtaData());
}
