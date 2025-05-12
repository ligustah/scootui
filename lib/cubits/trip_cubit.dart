import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/engine.dart';
import 'mdb_cubits.dart';

@immutable
class TripState {
  final double distanceTravelled;
  final DateTime startTime;

  const TripState(this.distanceTravelled, this.startTime);
}

class TripCubit extends Cubit<TripState> {
  late final StreamSubscription<EngineData> _sub;

  EngineData? _tripStart;
  DateTime? _tripStartTime;

  EngineData? _latest;

  TripCubit(Stream<EngineData> stream) : super(TripState(0, DateTime.now())) {
    _sub = stream.listen(_onData);
  }

  void _onData(EngineData data) {
    if (_tripStart != null) {
      if (data.odometer < _tripStart!.odometer) {
        // Odometer reset detected, reset trip start
        _tripStart = data;
        _tripStartTime = DateTime.now();
      }
    }

    // ignore data if the odometer is not set
    if (data.odometer > 0) {
      _tripStart ??= data;
      _tripStartTime ??= DateTime.now();
      _latest = data;

      final distance = data.odometer - _tripStart!.odometer;

      emit(TripState(distance, _tripStartTime!));
    }
  }

  void reset() {
    _tripStart = _latest;
    _tripStartTime = DateTime.now();
    emit(TripState(0, _tripStartTime!));
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }

  static TripState watch(BuildContext context) => context.watch<TripCubit>().state;

  static TripCubit create(BuildContext context) => TripCubit(context.read<EngineSync>().stream);
}
