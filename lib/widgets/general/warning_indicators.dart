import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../cubits/mdb_cubits.dart';
import '../../state/vehicle.dart';

class WarningIndicators extends StatelessWidget {
  const WarningIndicators({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = VehicleSync.watch(context);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left turn signal
          _IndicatorSvgIcon(
            iconPath: 'librescoot-turn-left.svg',
            isActive: state.blinkerState == BlinkerState.left || state.blinkerState == BlinkerState.both,
            activeColor: Colors.green,
            size: 48,
            isBlinking: state.blinkerState == BlinkerState.left || state.blinkerState == BlinkerState.both,
          ),

          // Parking indicator
          _IndicatorSvgIcon(
            iconPath: 'librescoot-parking-brake.svg',
            isActive: state.state == ScooterState.parked,
            activeColor: Colors.red,
            size: 36, // Smaller than blinkers
          ),

          // Right turn signal
          _IndicatorSvgIcon(
            iconPath: 'librescoot-turn-right.svg',
            isActive: state.blinkerState == BlinkerState.right || state.blinkerState == BlinkerState.both,
            activeColor: Colors.green,
            size: 48,
            isBlinking: state.blinkerState == BlinkerState.right || state.blinkerState == BlinkerState.both,
          ),
        ],
      ),
    );
  }
}

class _IndicatorIcon extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final double size;
  final bool isBlinking;

  const _IndicatorIcon({
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.size,
    this.isBlinking = false,
  });

  @override
  State<_IndicatorIcon> createState() => _IndicatorIconState();
}

class _IndicatorIconState extends State<_IndicatorIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(  
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, 
      ),
    );

    if (widget.isBlinking && widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_IndicatorIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isBlinking && widget.isActive) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final inactiveColor = isDark ? Colors.white24 : Colors.black26;

    if (!widget.isActive) {
      return Icon(
        widget.icon,
        color: inactiveColor,
        size: widget.size,
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Icon(
          widget.icon,
          color: widget.activeColor.withOpacity(_animation.value),
          size: widget.size,
        );
      },
    );
  }
}

class _IndicatorSvgIcon extends StatefulWidget {
  final String iconPath;
  final bool isActive;
  final Color activeColor;
  final double size;
  final bool isBlinking;

  const _IndicatorSvgIcon({
    required this.iconPath,
    required this.isActive,
    required this.activeColor,
    required this.size,
    this.isBlinking = false,
  });

  @override
  State<_IndicatorSvgIcon> createState() => _IndicatorSvgIconState();
}

class _IndicatorSvgIconState extends State<_IndicatorSvgIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.isBlinking && widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_IndicatorSvgIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isBlinking && widget.isActive) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final inactiveColor = isDark ? Colors.white24 : Colors.black26;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SvgPicture.asset(
          'assets/icons/${widget.iconPath}',
          colorFilter: ColorFilter.mode(
            widget.isActive 
              ? widget.activeColor.withOpacity(_animation.value)
              : inactiveColor,
            BlendMode.srcIn,
          ),
          width: widget.size,
          height: widget.size,
        );
      },
    );
  }
}