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
import '../state/speed_limit.dart';
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

  ScooterState? _previousState;

  VehicleSync(MDBRepository repo) : super(redisRepository: repo, initialState: VehicleData()) {
    // Listen for state changes to handle dashboard ready state
    stream.listen((vehicleData) {
      // If state changed from updating to another state, set dashboard ready
      if (_previousState == ScooterState.updating && vehicleData.state != ScooterState.updating) {
        redisRepository.dashboardReady();
      }

      // Store current state for next comparison
      _previousState = vehicleData.state;
    });
  }

  void toggleHazardLights() {
    final command = state.blinkerState == BlinkerState.both ? BlinkerState.off : BlinkerState.both;

    super.redisRepository.push("scooter:blinker", command.name);
  }
}

class BatterySync extends SyncableCubit<BatteryData> {
  final String id;

  BatterySync(MDBRepository repo, this.id) : super(redisRepository: repo, initialState: BatteryData(id: id));
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

  Future<void> clearDestination() async {
    // Get the channel name from syncSettings (e.g., "navigation")
    final channel = state.syncSettings.channel;
    const field = "destination";

    // Delete the field from Redis
    await redisRepository.hdel(channel, field);

    // Update local state to reflect the change immediately
    // This assumes NavigationData().update("destination", "") correctly clears the field.
    // The PUBSUB mechanism in SyncableCubit might also pick this up if hdel in MDBRepository
    // correctly notifies subscribers about the change (e.g., by sending the field name).
    emit(state.update(field, ""));
    print("NavigationSync: Cleared destination via HDEL and updated local state.");
  }
}

class OtaSync extends SyncableCubit<OtaData> {
  static OtaData watch(BuildContext context) => context.watch<OtaSync>().state;

  static OtaSync create(BuildContext context) => OtaSync(RepositoryProvider.of<MDBRepository>(context))..start();

  OtaSync(MDBRepository repo) : super(redisRepository: repo, initialState: OtaData());
}

class SpeedLimitSync extends SyncableCubit<SpeedLimitData> {
  static SpeedLimitData watch(BuildContext context) => context.watch<SpeedLimitSync>().state;

  static SpeedLimitSync create(BuildContext context) =>
      SpeedLimitSync(RepositoryProvider.of<MDBRepository>(context))..start();

  static T select<T>(BuildContext context, T Function(SpeedLimitData) selector) =>
      selector(context.select((SpeedLimitSync e) => e.state));

  SpeedLimitSync(MDBRepository repo) : super(redisRepository: repo, initialState: SpeedLimitData());
}
