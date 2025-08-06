import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Azimuthind extends ConsumerWidget{
  final double radius;

  const Azimuthind({super.key, this.radius = 200});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
      return CustomPaint(
        size: Size(radius, radius),
        painter: AzimuthPainter(),
      );
    }

}

class AzimuthPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(center.dx, center.dy);

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paint); //perimeter of an indicator

    paint
      ..color = Colors.grey.shade900
      ..style = PaintingStyle.fill;

    //zew. kolo
    canvas.drawCircle(center, radius, paint); //filling of the gauge bg

    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;


    final shipPath = Path();
    //start from sharp bow (front)
    shipPath.moveTo(center.dx, center.dy - 40);
    shipPath.quadraticBezierTo(center.dx + 15, center.dy - 30, center.dx + 18, center.dy - 10);
    shipPath.lineTo(center.dx + 18, center.dy + 40);

    shipPath.lineTo(center.dx-18, center.dy + 40);
    shipPath.lineTo(center.dx - 18, center.dy -10);
    shipPath.quadraticBezierTo(center.dx - 15, center.dy - 30, center.dx, center.dy - 41);

    
    canvas.drawPath(shipPath, paint);

    //draw the azimuth angles marks
    paint
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke; 
    for (int i = 0; i < 360; i += 15) {
      final angle = (i * pi) / 180;
      final isMainTick = i % 90 == 0;
      final tickLength = isMainTick ? 15.0 : 8.0;
      final strokeWidth = isMainTick ? 3.0 : 2.0;
      paint.strokeWidth = strokeWidth;
      final startRadius = radius;
      final endRadius = startRadius - tickLength;
      final startX = center.dx + cos(angle - pi/2) * startRadius;
      final startY = center.dy + sin(angle - pi/2) * startRadius;
      final endX = center.dx + cos(angle - pi/2) * endRadius;
      final endY = center.dy + sin(angle - pi/2) * endRadius;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY),
        paint
      );
    }

    //draw the north arrow line
    paint
      ..color = Colors.redAccent.shade200.withValues(alpha: 0.6)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke; 
    final northAngle = (0 * pi) / 180; // North is at 0 degrees
    final northStartX = center.dx + cos(northAngle - pi/2) * radius * 0.5;
    final northStartY = center.dy + sin(northAngle - pi/2) * radius * 0.5;
    final northEndX = center.dx + cos(northAngle - pi/2) * radius;
    final northEndY = center.dy + sin(northAngle - pi/2) * radius;
    canvas.drawLine(
      Offset(northStartX, northStartY),
      Offset(northEndX, northEndY),
      paint
    );
    
    

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}