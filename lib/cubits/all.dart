import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import 'address_cubit.dart';
import 'map_cubit.dart';
import 'mdb_cubits.dart';
import 'menu_cubit.dart';
import 'ota_cubit.dart';
import 'screen_cubit.dart';
import 'shutdown_cubit.dart';
import 'system_cubit.dart';
import 'theme_cubit.dart';
import 'trip_cubit.dart';

final List<SingleChildWidget> allCubits = [
  BlocProvider(create: ThemeCubit.create),
  BlocProvider(create: EngineSync.create),
  BlocProvider(create: VehicleSync.create),
  BlocProvider(create: Battery1Sync.create),
  BlocProvider(create: Battery2Sync.create),
  BlocProvider(create: BluetoothSync.create),
  BlocProvider(create: GpsSync.create),
  BlocProvider(create: InternetSync.create),
  BlocProvider(create: NavigationSync.create),
  BlocProvider(create: SystemCubit.create),
  BlocProvider(create: TripCubit.create),
  BlocProvider(create: MapCubit.create),
  BlocProvider(create: ScreenCubit.create),
  BlocProvider(create: MenuCubit.create),
  BlocProvider(create: AddressCubit.create),
  BlocProvider(create: ShutdownCubit.create),
  BlocProvider(create: OtaSync.create),
  BlocProvider(create: OtaCubit.create),
];
