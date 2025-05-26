import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scooter_cluster/repositories/mdb_repository.dart';
import 'package:scooter_cluster/state/dashboard.dart';

import 'syncable_cubit.dart';

class DashboardSyncCubit extends SyncableCubit<DashboardData> {
  static DashboardData watch(BuildContext context) => context.watch<DashboardSyncCubit>().state;

  static DashboardSyncCubit create(BuildContext context) =>
      DashboardSyncCubit(RepositoryProvider.of<MDBRepository>(context))..start();

  static T select<T>(BuildContext context, T Function(DashboardData) selector) =>
      selector(context.select((DashboardSyncCubit e) => e.state));

  DashboardSyncCubit(MDBRepository repo) : super(redisRepository: repo, initialState: DashboardData.initial());
}
