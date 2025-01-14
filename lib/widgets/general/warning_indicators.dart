import 'package:flutter/material.dart';
import '../../models/vehicle_state.dart';

class WarningIndicators extends StatelessWidget {
  final VehicleState state;

  const WarningIndicators({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left turn signal
          _IndicatorIcon(
            icon: Icons.turn_left,
            isActive: state.blinkerState == 'left' || state.blinkerState == 'both',
            activeColor: Colors.green,
            size: 48,
            isBlinking: state.blinkerState == 'left' || state.blinkerState == 'both',
          ),

          // Parking indicator
          _IndicatorIcon(
            icon: Icons.local_parking,
            isActive: state.isParked,
            activeColor: Colors.red,
            size: 36, // Smaller than blinkers
          ),

          // Right turn signal
          _IndicatorIcon(
            icon: Icons.turn_right,
            isActive: state.blinkerState == 'right' || state.blinkerState == 'both',
            activeColor: Colors.green,
            size: 48,
            isBlinking: state.blinkerState == 'right' || state.blinkerState == 'both',
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