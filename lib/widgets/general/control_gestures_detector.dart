import 'dart:async';
import 'package:flutter/widgets.dart';

import '../../state/enums.dart';
import '../../state/vehicle.dart';

enum ControlKey { left, right }

class ControlGestureDetector extends StatefulWidget {
  final Widget child;
  final Stream<VehicleData> stream;

  final VoidCallback? onLeftPress;
  final VoidCallback? onLeftRelease;
  final VoidCallback? onLeftTap;
  final VoidCallback? onLeftDoubleTap;
  final VoidCallback? onLeftHold;

  final VoidCallback? onRightPress;
  final VoidCallback? onRightRelease;
  final VoidCallback? onRightTap;
  final VoidCallback? onRightDoubleTap;
  final VoidCallback? onRightHold;

  final Duration doubleTapDelay;
  final Duration holdDelay;

  const ControlGestureDetector({
    super.key,
    required this.stream,
    required this.child,
    this.onLeftPress,
    this.onLeftRelease,
    this.onLeftTap,
    this.onLeftDoubleTap,
    this.onLeftHold,
    this.onRightPress,
    this.onRightRelease,
    this.onRightTap,
    this.onRightDoubleTap,
    this.onRightHold,
    this.doubleTapDelay = const Duration(milliseconds: 300),
    this.holdDelay = const Duration(milliseconds: 500),
  });

  @override
  State<ControlGestureDetector> createState() => _ControlGestureDetectorState();
}

class _ControlGestureDetectorState extends State<ControlGestureDetector> {
  late final StreamSubscription<VehicleData> _sub;

  final Map<ControlKey, Toggle> _prev = {
    ControlKey.left: Toggle.off,
    ControlKey.right: Toggle.off,
  };

  final Map<ControlKey, DateTime?> _pressStart = {
    ControlKey.left: null,
    ControlKey.right: null,
  };

  final Map<ControlKey, Timer?> _holdTimers = {};
  final Map<ControlKey, Timer?> _doubleTapTimers = {};
  final Map<ControlKey, bool> _waitingSecondTap = {
    ControlKey.left: false,
    ControlKey.right: false,
  };

  @override
  void initState() {
    super.initState();
    _sub = widget.stream.listen(_handleUpdate);
  }

  void _handleUpdate(VehicleData data) {
    _handleKey(
      key: ControlKey.left,
      prev: _prev[ControlKey.left]!,
      curr: data.brakeLeft,
      onPress: widget.onLeftPress,
      onRelease: widget.onLeftRelease,
      onTap: widget.onLeftTap,
      onDoubleTap: widget.onLeftDoubleTap,
      onHold: widget.onLeftHold,
    );

    _handleKey(
      key: ControlKey.right,
      prev: _prev[ControlKey.right]!,
      curr: data.brakeRight,
      onPress: widget.onRightPress,
      onRelease: widget.onRightRelease,
      onTap: widget.onRightTap,
      onDoubleTap: widget.onRightDoubleTap,
      onHold: widget.onRightHold,
    );

    _prev[ControlKey.left] = data.brakeLeft;
    _prev[ControlKey.right] = data.brakeRight;
  }

  void _handleKey({
    required ControlKey key,
    required Toggle prev,
    required Toggle curr,
    VoidCallback? onPress,
    VoidCallback? onRelease,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onHold,
  }) {
    final isPress = prev == Toggle.off && curr == Toggle.on;
    final isRelease = prev == Toggle.on && curr == Toggle.off;

    if (isPress) {
      _pressStart[key] = DateTime.now();
      onPress?.call();

      _holdTimers[key]?.cancel();
      _holdTimers[key] = Timer(widget.holdDelay, () {
        _waitingSecondTap[key] = false;
        onHold?.call();
      });
    }

    if (isRelease) {
      _holdTimers[key]?.cancel();
      onRelease?.call();

      final duration =
      DateTime.now().difference(_pressStart[key] ?? DateTime.now());

      if (duration < widget.holdDelay) {
        if (_waitingSecondTap[key] == true) {
          _doubleTapTimers[key]?.cancel();
          _waitingSecondTap[key] = false;
          onDoubleTap?.call();
        } else {
          _waitingSecondTap[key] = true;
          _doubleTapTimers[key] = Timer(widget.doubleTapDelay, () {
            _waitingSecondTap[key] = false;
            onTap?.call();
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    for (var t in _holdTimers.values) {
      t?.cancel();
    }
    for (var t in _doubleTapTimers.values) {
      t?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
