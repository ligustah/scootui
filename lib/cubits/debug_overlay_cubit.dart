import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/mdb_repository.dart';

enum DebugMode { off, overlay, full }

extension DebugModeString on String {
  DebugMode toDebugMode() {
    switch (toLowerCase()) {
      case 'overlay':
        return DebugMode.overlay;
      case 'full':
        return DebugMode.full;
      case 'off':
      default:
        return DebugMode.off;
    }
  }
}

class DebugOverlayCubit extends Cubit<DebugMode> {
  final MDBRepository? _mdbRepository;
  Timer? _refreshTimer;

  static const _redisKey = 'dashboard';
  static const _redisField = 'debug';

  DebugOverlayCubit({MDBRepository? mdbRepository})
      : _mdbRepository = mdbRepository,
        super(DebugMode.off) {
    _initRedisListener();
  }

  static DebugOverlayCubit create(BuildContext context) {
    return DebugOverlayCubit(
      mdbRepository: context.read<MDBRepository>(),
    );
  }

  void _initRedisListener() {
    _checkRedisValue();

    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) => _checkRedisValue());
  }

  Future<void> _checkRedisValue() async {
    if (_mdbRepository == null) return;

    try {
      final value = await _mdbRepository!.get(_redisKey, _redisField);

      final debugMode = (value == null || value.isEmpty) ? DebugMode.off : value.toDebugMode();

      if (debugMode != state) {
        emit(debugMode);
      }
    } catch (e) {
      print('Error checking debug mode state: $e');
    }
  }

  void toggleMode() async {
    final DebugMode newMode = switch (state) {
      DebugMode.off => DebugMode.overlay,
      DebugMode.overlay => DebugMode.full,
      DebugMode.full => DebugMode.off,
    };

    emit(newMode);
    await _updateRedisValue(newMode);
  }

  void setMode(DebugMode mode) async {
    emit(mode);
    await _updateRedisValue(mode);
  }

  void showOverlay() async {
    emit(DebugMode.overlay);
    await _updateRedisValue(DebugMode.overlay);
  }

  void showFullDebug() async {
    emit(DebugMode.full);
    await _updateRedisValue(DebugMode.full);
  }

  void hideDebug() async {
    emit(DebugMode.off);
    await _updateRedisValue(DebugMode.off);
  }

  Future<void> _updateRedisValue(DebugMode mode) async {
    if (_mdbRepository == null) return;

    final String value = switch (mode) {
      DebugMode.off => 'off',
      DebugMode.overlay => 'overlay',
      DebugMode.full => 'full',
    };

    try {
      await _mdbRepository!.set(_redisKey, _redisField, value);
    } catch (e) {
      print('Error updating debug mode in Redis: $e');
    }
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
