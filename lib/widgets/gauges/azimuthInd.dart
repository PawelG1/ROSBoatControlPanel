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
    final shipIconSize = radius*0.4;

    final paint = Paint()
      ..strokeWidth = 2
      ..color = Colors.grey.shade900
      ..style = PaintingStyle.fill;

    //zew. kolo
    canvas.drawCircle(center, radius, paint); //filling of the gauge bg

    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius*0.04;


    final shipPath = Path();

    shipPath.moveTo(center.dx, center.dy - shipIconSize*1.1); 
    shipPath.quadraticBezierTo(
        center.dx + shipIconSize*0.375, 
        center.dy - shipIconSize*0.85,  
        center.dx + shipIconSize*0.45, 
        center.dy - shipIconSize*0.25
    );
    shipPath.lineTo(center.dx + shipIconSize*0.45, center.dy + shipIconSize*1);

    shipPath.lineTo(center.dx-shipIconSize*0.45, center.dy + shipIconSize*1);
    shipPath.lineTo(center.dx - shipIconSize*0.45, center.dy -shipIconSize*0.25);
    shipPath.quadraticBezierTo(
        center.dx - shipIconSize*0.375, 
        center.dy - shipIconSize*0.85, 
        center.dx, 
        center.dy - shipIconSize*1.1    
    );
    
    canvas.drawPath(shipPath, paint);



    //draw the azimuth angles marks
    paint
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth =  radius*0.08
      ..style = PaintingStyle.stroke; 
    for (int i = 0; i < 360; i += 15) {
      final angle = (i * pi) / 180;
      final isMainTick = i % 90 == 0;
      final tickLength = isMainTick ? (radius*0.2) : (radius*0.12);
      final strokeWidth = isMainTick ? (radius*0.03) : (radius*0.02);
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
      ..strokeWidth =  radius*0.04
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

    //outer perimeter
    paint
      ..color = Colors.black
      ..strokeWidth = radius * 0.03
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paint); //perimeter of an indicator    
    

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}