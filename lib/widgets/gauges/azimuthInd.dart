import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
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

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}