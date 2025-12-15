import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fittrack/features/report/widgets/three_segment_circular_painter.dart';

class ThreeSegmentCircularProgress extends StatelessWidget {
  final int cardio;
  final int flexibility;
  final int strength;
  final int target;
  final double strokeWidth;

  const ThreeSegmentCircularProgress({
    super.key,
    required this.cardio,
    required this.flexibility,
    required this.strength,
    required this.target,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final total = cardio + flexibility + strength;

    final seg1 = cardio / total;
    final seg2 = flexibility / total;
    final seg3 = strength / total;

    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.3,
      child: CustomPaint(
        painter: ThreeSegmentCircularPainter(
          segments: [seg1, seg2, seg3],
          colors: const [
            Color(0xFF0034C3),
            Color(0xFF09D933),
            Color(0xFFFD1818),
          ],
          radius: screenWidth * 0.4 / 2 - strokeWidth / 2,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$total Min',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Text(
                '${min((total / target * 100).round(), 100)}% Completed',
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: screenWidth * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
