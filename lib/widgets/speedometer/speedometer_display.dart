import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../cubits/mdb_cubits.dart';

class SpeedometerDisplay extends StatefulWidget {
  final double maxSpeed;

  const SpeedometerDisplay({
    super.key,
    this.maxSpeed = 70.0,
  });

  @override
  State<SpeedometerDisplay> createState() => _SpeedometerDisplayState();
}

class _SpeedometerDisplayState extends State<SpeedometerDisplay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _lastSpeed = 0.0;
  bool _isRegenerating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final speed = EngineSync.select(context, (data) => data.speed);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),

          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return TweenAnimationBuilder<Color?>(
                duration: const Duration(milliseconds: 50),
                tween: ColorTween(
                  begin: _isRegenerating 
                      ? Colors.red.withOpacity(0.3)
                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                  end: _isRegenerating 
                      ? Colors.red.withOpacity(0.3)
                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                ),
                builder: (context, color, child) {
                  return CustomPaint(
                    size: const Size.fromRadius(150),
                    painter: _SpeedometerPainter(
                      progress: speed / widget.maxSpeed,
                      isDark: isDark,
                      isRegenerating: _isRegenerating,
                      backgroundColor: color ?? Colors.grey,
                      maxSpeed: widget.maxSpeed,
                    ),
                  );
                },
              );
            },
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                speed.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                'km/h',
                style: TextStyle(
                  fontSize: 24,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
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
