import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redis/redis.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';
import '../repositories/redis_repository.dart';

abstract class SyncableCubit<T extends Syncable<T>> extends Cubit<T> {
  final RedisRepository redisRepository;

  bool _isClosing = false;
  Command? _command;
  PubSub? _pubSub;
  final Map<String, Timer> _timers = {};
  final Map<String, SyncFieldSettings> _fields = {};

  void _doRefresh(String variable) {
    _command?.send_object(["HGET", state.syncSettings.channel, variable]).then(
        (response) {
      if (response is String) {
        emit(state.update(variable, response));
      }

      // prepare for next cycle
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

    // connect to redis
    redisRepository.connect().then((cmd) {
      _command = cmd;
    });

    // set up all field timers
    for (final field in settings.fields) {
      _fields[field.variable] = field;
      _refresh(field.variable);
    }

    redisRepository.subscribe(settings.channel).forEach((rec) {
      final (channel, variable) = rec;

      if(channel == settings.channel) {
        _doRefresh(variable);
      }
    });
  }

  @override
  Future<void> close() {
    _isClosing = true;
    _command?.get_connection().close();
    _command = null;

    _timers.forEach((_, timer) => timer.cancel());

    return super.close();
  }

  SyncableCubit({
    required this.redisRepository,
    required T initialState,
  }) : super(initialState);
}
