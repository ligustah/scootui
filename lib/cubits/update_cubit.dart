import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scooter_cluster/repositories/tiles_update_repository.dart';

import 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  final TilesUpdateRepository _tilesUpdateRepository;

  UpdateCubit(this._tilesUpdateRepository) : super(const UpdateState.idle());

  static UpdateCubit create(BuildContext context) => UpdateCubit(
        context.read<TilesUpdateRepository>(),
      );

  Future<void> checkForUpdates() async {
    emit(const UpdateState.checking());
    try {
      await _tilesUpdateRepository.checkForUpdates();

      // How do we get from here to a more descriptive state?
      // The repository doesn't return the status of what it did.
      // For now, we assume if it doesn't throw, it's pending restart or idle.
      // This is a point for future improvement.
      emit(const UpdateState.updatePendingRestart());
    } catch (e) {
      emit(UpdateState.error(e.toString()));
    }
  }
}
