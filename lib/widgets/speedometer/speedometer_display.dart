import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../cubits/mdb_cubits.dart';
import '../../cubits/theme_cubit.dart';
import '../indicators/speed_limit_indicator.dart';

class SpeedometerDisplay extends StatefulWidget {
  final double maxSpeed;

  const SpeedometerDisplay({
    super.key,
    this.maxSpeed = 60.0,
  });

  @override
  State<SpeedometerDisplay> createState() => _SpeedometerDisplayState();
}

class _SpeedometerDisplayState extends State<SpeedometerDisplay> with TickerProviderStateMixin {
  late AnimationController _speedController;
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  double _lastSpeed = 0.0;
  double _animationStartSpeed = 0.0;
  double _targetSpeed = 0.0;
  bool _isRegenerating = false;

  @override
  void initState() {
    super.initState();

    // Speed animation controller
    _speedController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )
      ..addListener(() {
        // Force rebuild on animation updates
        if (mounted) setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Only update _lastSpeed when animation completes
          if (mounted) {
            setState(() {
              _lastSpeed = _targetSpeed;
            });
          }
        }
      });

    // Color animation controller
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..addListener(() {
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _speedController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final engineData = EngineSync.watch(context);
    final speed = engineData.speed.toDouble();
    final theme = ThemeCubit.watch(context);

    // Check if we're regenerating by monitoring the motor current
    // Negative current indicates regenerative braking
    final bool regenerating = engineData.motorCurrent < 0;

    if (_isRegenerating != regenerating) {
      setState(() {
        _isRegenerating = regenerating;
      });

      // Set up color animation based on new state
      final Color fromColor =
          _isRegenerating ? (theme.isDark ? Colors.grey.shade800 : Colors.grey.shade200) : Colors.red.withOpacity(0.3);

      final Color toColor =
          _isRegenerating ? Colors.red.withOpacity(0.3) : (theme.isDark ? Colors.grey.shade800 : Colors.grey.shade200);

      _colorAnimation = ColorTween(
        begin: fromColor,
        end: toColor,
      ).animate(CurvedAnimation(
        parent: _colorController,
        curve: Curves.easeInOut,
      ));

      // Start color animation
      _colorController.reset();
      _colorController.forward();
    }

    // If the speed has changed and we're not currently animating
    if (speed != _targetSpeed && !_speedController.isAnimating) {
      // Store the starting point (current displayed value) and target
      _animationStartSpeed = _lastSpeed;
      _targetSpeed = speed;

      // Start a new animation
      _speedController.reset();
      _speedController.forward();
    }

    // Calculate the animated speed value
    double animatedSpeed;

    if (_speedController.isAnimating) {
      // Apply easing curve for smooth motion
      final curvedValue = Curves.easeOutCubic.transform(_speedController.value);
      animatedSpeed = _animationStartSpeed + (curvedValue * (_targetSpeed - _animationStartSpeed));
    } else {
      // Not animating, use the last stable value
      animatedSpeed = _lastSpeed;
    }

    // Get the current animated background color
    Color backgroundColor;
    if (_colorController.isAnimating && _colorAnimation.value != null) {
      backgroundColor = _colorAnimation.value!;
    } else {
      backgroundColor =
          _isRegenerating ? Colors.red.withOpacity(0.3) : (theme.isDark ? Colors.grey.shade800 : Colors.grey.shade200);
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
        ),
        // Main speedometer gauge
        CustomPaint(
          size: const Size.fromRadius(150),
          painter: _SpeedometerPainter(
            progress: animatedSpeed / widget.maxSpeed,
            isDark: theme.isDark,
            isRegenerating: _isRegenerating,
            backgroundColor: backgroundColor,
            maxSpeed: widget.maxSpeed,
          ),
        ),
        // Speed display and indicators
        Transform.translate(
          offset: const Offset(0, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated speed text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: animatedSpeed.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 96,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    color: theme.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'km/h',
                  style: TextStyle(
                    fontSize: 24,
                    height: 0.95,
                    color: theme.isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),

              // Speed limit indicator
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SpeedLimitIndicator(iconSize: 24),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 140,
                    child: RoadNameDisplay(
                      textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpeedometerPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  final bool isRegenerating;
  final Color backgroundColor;
  final double maxSpeed;
  static const double _startAngle = 150 * math.pi / 180;
  static const double _sweepAngle = 240 * math.pi / 180;

  _SpeedometerPainter({
    required this.progress,
    required this.isDark,
    required this.isRegenerating,
    required this.backgroundColor,
    required this.maxSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 20.0;

    // Background arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
      _startAngle,
      _sweepAngle,
      false,
      bgPaint,
    );

    // Speed arc
    if (progress > 0) {
      final speedPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
        _startAngle,
        progress * _sweepAngle,
        false,
        speedPaint,
      );
    }

    // Draw tick marks
    _drawTicks(canvas, center, radius, isDark);
  }

  void _drawTicks(Canvas canvas, Offset center, double radius, bool isDark) {
    final tickPaint = Paint()
      ..color = isDark ? Colors.white30 : Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final speedStep = 10.0; // 10 km/h per major tick
    final totalMajorTicks = (maxSpeed / speedStep).ceil() + 1;
    final minorTicksPerMajor = 1; // Number of minor ticks between major ticks

    for (int i = 0; i <= totalMajorTicks * minorTicksPerMajor; i++) {
      final isMajorTick = i % minorTicksPerMajor == 0;
      final speedValue = (i / minorTicksPerMajor * speedStep).toInt();

      // Skip if speed value would exceed maxSpeed
      if (speedValue > maxSpeed) continue;

      final angle = _startAngle + (speedValue / maxSpeed) * _sweepAngle;
      final tickLength = isMajorTick ? 15.0 : 7.0;
      final tickWidth = isMajorTick ? 2.0 : 1.0;

      // Draw tick
      tickPaint.strokeWidth = tickWidth;
      final start = Offset(
        center.dx + (radius - 30) * math.cos(angle),
        center.dy + (radius - 30) * math.sin(angle),
      );
      final end = Offset(
        center.dx + (radius - 30 - tickLength) * math.cos(angle),
        center.dy + (radius - 30 - tickLength) * math.sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }
  }

  @override
  bool shouldRepaint(_SpeedometerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isDark != isDark ||
        oldDelegate.isRegenerating != isRegenerating ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
