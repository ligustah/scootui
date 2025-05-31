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
    // print("SyncableCubit (${state.syncSettings.channel}): _doRefresh called for variable: $variable");
    redisRepository.get(state.syncSettings.channel, variable).then((value) {
      // print("SyncableCubit (${state.syncSettings.channel}): Got value for $variable: $value");
      if (value == null && variable != "destination") {
        // Allow 'destination' to be cleared (become null effectively)
        // print("SyncableCubit (${state.syncSettings.channel}): Value is null for $variable and it's not 'destination', returning.");
        return;
      }
      // If variable is 'destination' and value is null, it means it was cleared.
      // We should emit an update with an empty string or handle as cleared.
      // The `update` method in `NavigationData` should handle `null` appropriately for `destination`.
      emit(state.update(variable, value ?? "")); // Pass empty string if null, or let `update` handle null
      _refresh(variable);
    }).catchError((e) {
      print("SyncableCubit (${state.syncSettings.channel}): Error in _doRefresh for $variable: $e");
    });
  }

  void _refresh(String variable) {
    // print("SyncableCubit (${state.syncSettings.channel}): _refresh called for variable: $variable");
    if (_isClosing) return;

    Timer getTimer() {
      final newInterval = _fields[variable]?.interval ?? state.syncSettings.interval;

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
      final (channel, pubSubVar) = rec; // Renamed to avoid confusion with loop variable
      // print("SyncableCubit (${state.syncSettings.channel}): Received PUBSUB message on channel '$channel': $pubSubVar");

      if (channel == settings.channel) {
        _doRefresh(pubSubVar); // Use the variable from PUBSUB message
      }
    }).catchError((e) {
      print("SyncableCubit (${state.syncSettings.channel}): Error in PUBSUB subscription: $e");
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
