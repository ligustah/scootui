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
  late Animation<Color?> _colorAnimation; // Keep this for the color tween

  double _lastSpeed = 0.0;
  double _animationStartSpeed = 0.0;
  double _targetSpeed = 0.0;
  bool _isRegenerating = false; // Still useful for logic and initial color state

  @override
  void initState() {
    super.initState();

    _speedController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (mounted) {
            // Update _lastSpeed when animation completes.
            // No setState needed here as AnimatedBuilder will handle UI updates.
            _lastSpeed = _targetSpeed;
          }
        }
      });

    _colorController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Initialize _colorAnimation with a default. It will be updated.
    // Using a transparent color initially, will be set properly before first use.
    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.transparent,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _speedController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final engineData = EngineSync.select(context, (data) => (data.speed, data.motorCurrent));
    final double currentSpeed = engineData.$1.toDouble();
    final double motorCurrent = engineData.$2;
    final theme = ThemeCubit.watch(context);

    final bool regenerating = motorCurrent < 0;

    if (_isRegenerating != regenerating) {
      _isRegenerating = regenerating; // Update state directly

      final Color fromColor = _isRegenerating
          ? (theme.isDark ? Colors.grey.shade800 : Colors.grey.shade200)
          : Colors.red.withOpacity(0.3);
      final Color toColor = _isRegenerating
          ? Colors.red.withOpacity(0.3)
          : (theme.isDark ? Colors.grey.shade800 : Colors.grey.shade200);

      // Update _colorAnimation before starting the animation
      _colorAnimation = ColorTween(
        begin: fromColor, // Could also be _colorAnimation.value if we want smoother transitions from ongoing animation
        end: toColor,
      ).animate(CurvedAnimation(
        parent: _colorController,
        curve: Curves.easeInOut,
      ));

      _colorController.reset();
      _colorController.forward();
    }

    if (currentSpeed != _targetSpeed && !_speedController.isAnimating) {
      _animationStartSpeed = _lastSpeed;
      _targetSpeed = currentSpeed;
      _speedController.reset();
      _speedController.forward();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_speedController, _colorController]),
      builder: (context, child) {
        double animatedSpeed;
        if (_speedController.isAnimating) {
          final curvedValue = Curves.easeOutCubic.transform(_speedController.value);
          animatedSpeed = _animationStartSpeed + (curvedValue * (_targetSpeed - _animationStartSpeed));
        } else {
          animatedSpeed = _lastSpeed;
        }

        Color backgroundColor;
        // Use _colorAnimation.value directly. If controller is not animating, it holds the end color.
        // Check if _colorAnimation has been initialized properly, especially on first build.
        if (_colorAnimation.value != null) {
            backgroundColor = _colorAnimation.value!;
        } else {
            // Fallback or initial color before first animation
            backgroundColor = _isRegenerating
                ? Colors.red.withOpacity(0.3)
                : (theme.isDark ? Colors.grey.shade800 : Colors.grey.shade200);
        }
        
        // Ensure theme is accessible for initial backgroundColor if needed before _colorAnimation is set
        // This might require theme to be available here or passed if not directly accessible.

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            CustomPaint(
              size: const Size.fromRadius(150),
              painter: _SpeedometerPainter(
                progress: animatedSpeed / widget.maxSpeed,
                isDark: theme.isDark, // theme might need to be passed or accessed if not in scope
                isRegenerating: _isRegenerating, // Use the state variable
                backgroundColor: backgroundColor,
                maxSpeed: widget.maxSpeed,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
      },
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
