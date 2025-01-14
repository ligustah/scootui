import 'package:flutter/material.dart';
import 'dart:math';

class SpeedometerPainter extends CustomPainter {
  final double speed;
  final double maxSpeed;
  final bool isActive;
  final Color regenColor;
  final Color activeColor;
  final Color inactiveColor;
  final double strokeWidth;

  SpeedometerPainter({
    required this.speed,
    required this.maxSpeed,
    required this.isActive,
    required this.regenColor,
    required this.activeColor,
    required this.inactiveColor,
    this.strokeWidth = 20,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const startAngle = 150 * pi / 180;
    const sweepAngle = 240 * pi / 180;

    // background arc
    final bgPaint = Paint()
      ..color = regenColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // speed arc
    if (speed > 0) {
      final speedPaint = Paint()
        ..color = isActive ? activeColor : inactiveColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final speedAngle = (speed / maxSpeed).clamp(0.0, 1.0) * sweepAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
        startAngle,
        speedAngle,
        false,
        speedPaint,
      );
    }
  }

  @override
  bool shouldRepaint(SpeedometerPainter oldDelegate) {
    return oldDelegate.speed != speed || 
           oldDelegate.isActive != isActive ||
           oldDelegate.activeColor != activeColor ||
           oldDelegate.inactiveColor != inactiveColor ||
           oldDelegate.regenColor != regenColor ||
           oldDelegate.strokeWidth != strokeWidth;
  }
}