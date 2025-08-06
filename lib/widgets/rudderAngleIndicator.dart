import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Rudderangleindicator extends ConsumerWidget {
  final StateProvider<double> rudderAngleProvider;

  const Rudderangleindicator({super.key, required this.rudderAngleProvider});

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomPaint(
      size: Size(200, 200),
      painter: RudderAnglePainter(rudderAngle: ref.watch(rudderAngleProvider)),
    );
  }

}

class RudderAnglePainter extends CustomPainter {
  double rudderAngle; // Angle in degrees (-45 to +45)

  RudderAnglePainter({this.rudderAngle = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;

    var paint = Paint();

    // Outer black circle
    paint
      ..color = Colors.black87
      ..strokeWidth = radius * 0.04 //scalable stroke width
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    canvas.drawCircle(center, radius, paint);


    // Inner gray background
    paint
      ..color = Colors.grey.shade900
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);

    // Draw tick marks
    paint
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = -45; i <= 45; i += 15) {
      final angle = (i * pi) / 180;
      final isMainTick = i % 30 == 0;
      final tickLength = isMainTick ? 15.0 : 8.0;
      final strokeWidth = isMainTick ? 3.0 : 2.0;
      
      paint.strokeWidth = strokeWidth;
      
      final startRadius = radius;
      final endRadius = startRadius - tickLength;
      
      final startX = center.dx + cos(angle - pi/2) * startRadius;
      final startY = center.dy + sin(angle - pi/2) * startRadius;
      final endX = center.dx + cos(angle - pi/2) * endRadius;
      final endY = center.dy + sin(angle - pi/2) * endRadius;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }

    // Center black dot
    paint
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, paint);

    // Title text
    TextSpan textSpan = TextSpan(
      text: 'RUDDER ANGLE',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.7),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy + radius * 0.2));

    // Red indicator needle
    final needleAngle = (rudderAngle * pi) / 180;
    paint
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    
    final needleLength = radius - 25;
    final needleEndX = center.dx + cos(needleAngle - pi/2) * needleLength;
    final needleEndY = center.dy + sin(needleAngle - pi/2) * needleLength;
    
    canvas.drawLine(center, Offset(needleEndX, needleEndY), paint);

    // Angle value text
    TextSpan valueSpan = TextSpan(
      text: '${rudderAngle.toStringAsFixed(1)}°',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.7),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );

    TextPainter valuePainter = TextPainter(
      text: valueSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    valuePainter.layout();
    valuePainter.paint(canvas, Offset(center.dx - valuePainter.width / 2, center.dy + radius * 0.45));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! RudderAnglePainter || oldDelegate.rudderAngle != rudderAngle;
  }
}