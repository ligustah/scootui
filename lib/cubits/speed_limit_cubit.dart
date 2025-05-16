import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/mdb_repository.dart';
import '../state/speed_limit.dart';
import 'syncable_cubit.dart';

class SpeedLimitSync extends SyncableCubit<SpeedLimitData> {
  static SpeedLimitData watch(BuildContext context) => context.watch<SpeedLimitSync>().state;

  static SpeedLimitSync create(BuildContext context) =>
      SpeedLimitSync(RepositoryProvider.of<MDBRepository>(context))..start();

  static T select<T>(BuildContext context, T Function(SpeedLimitData) selector) =>
      selector(context.select((SpeedLimitSync e) => e.state));

  SpeedLimitSync(MDBRepository repo) : super(redisRepository: repo, initialState: SpeedLimitData());
}
