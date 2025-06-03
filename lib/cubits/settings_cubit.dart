import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scooter_cluster/repositories/mdb_repository.dart';
import 'package:scooter_cluster/state/settings.dart';

import 'syncable_cubit.dart';

class SettingsSyncCubit extends SyncableCubit<SettingsData> {
  static SettingsData watch(BuildContext context) => context.watch<SettingsSyncCubit>().state;

  static SettingsSyncCubit create(BuildContext context) =>
      SettingsSyncCubit(RepositoryProvider.of<MDBRepository>(context))..start();

  static T select<T>(BuildContext context, T Function(SettingsData) selector) =>
      selector(context.select((SettingsSyncCubit e) => e.state));

  SettingsSyncCubit(MDBRepository repo) : super(redisRepository: repo, initialState: SettingsData.initial());
}