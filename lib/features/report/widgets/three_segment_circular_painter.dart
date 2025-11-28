import 'dart:math';
import 'package:flutter/material.dart';

class ThreeSegmentCircularPainter extends CustomPainter {
  final List<double> segments;
  final List<Color> colors;
  final double radius;
  final double strokeWidth;

  ThreeSegmentCircularPainter({
    required this.segments,
    required this.colors,
    required this.radius,
    required this.strokeWidth,
  }) : assert(segments.length == 3),
       assert(colors.length == 3);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi,
      false,
      basePaint,
    );

    double startAngle = -pi / 2;
    for (int i = 0; i < segments.length; i++) {
      final sweepAngle = 2 * pi * segments[i];

      basePaint.color = colors[i];

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        basePaint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant ThreeSegmentCircularPainter oldDelegate) {
    return oldDelegate.segments != segments ||
        oldDelegate.colors != colors ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
