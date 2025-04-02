import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';
import '../repositories/mdb_repository.dart';

abstract class SyncableCubit<T extends Syncable<T>> extends Cubit<T> {
  final MDBRepository redisRepository;

  bool _isClosing = false;
  final Map<String, Timer> _timers = {};
  final Map<String, SyncFieldSettings> _fields = {};

  void _doRefresh(String variable) {
    redisRepository.get(state.syncSettings.channel, variable).then((value) {
      if (value == null) return;
      emit(state.update(variable, value));
      _refresh(variable);
    });
  }

  void _refresh(String variable) {
    if (_isClosing) return;

    Timer getTimer() {
      final newInterval =
          _fields[variable]?.interval ?? state.syncSettings.interval;

      return Timer(newInterval, () => _doRefresh(variable));
    }

    _timers.update(variable, (activeTimer) {
      activeTimer.cancel();
      return getTimer();
    }, ifAbsent: getTimer);
  }

  void start() {
    final settings = state.syncSettings;

    redisRepository.getAll(settings.channel).then((values) {
      if (values.isEmpty) return;

      T newState = state;
      for (final (variable, value) in values) {
        newState = newState.update(variable, value);
      }

      emit(newState);
    });

    // set up all field timers
    for (final field in settings.fields) {
      _fields[field.variable] = field;
      _refresh(field.variable);
    }

    redisRepository.subscribe(settings.channel).forEach((rec) {
      final (channel, variable) = rec;

      if (channel == settings.channel) {
        _doRefresh(variable);
      }
    });
  }

  @override
  Future<void> close() {
    _isClosing = true;
    _timers.forEach((_, timer) => timer.cancel());

    return super.close();
  }

  SyncableCubit({
    required this.redisRepository,
    required T initialState,
  }) : super(initialState);
}
