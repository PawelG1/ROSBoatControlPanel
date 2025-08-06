import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeedGauge extends ConsumerWidget{
 
  final double maxSpeed;
  final int tickCount;
  final StateProvider<double> speedProvider;
  final double radius;

  const SpeedGauge({super.key,required this.speedProvider, required this.maxSpeed, this.tickCount=11,  this.radius = 200});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = ref.watch(speedProvider);
    return CustomPaint(
          size: Size(radius, radius),
          painter: SpeedGaugePainter(
            speed: speed,
             maxSpeed: maxSpeed,
              tickCount: tickCount),
        );
    
  }
}

class SpeedGaugePainter extends CustomPainter {
  final double speed;
  final double maxSpeed;
  final int tickCount;
  
  SpeedGaugePainter({required this.speed, required this.maxSpeed, required this.tickCount});

  @override
  void paint(Canvas canvas, Size size){
    final center = Offset(size.width/2, size.height/2);
    final radius = min(size.width, size.height) / 2 ;
    final angleStart = pi; //wskazowka lezy na lewo = pi
    final angleEnd = 2*pi; //wskazowka lezy prawo

    var paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..filterQuality = FilterQuality.high;
    canvas.drawCircle(center, radius, paint);

    paint
      ..color = Colors.grey.shade900
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    //zew. kolo
    canvas.drawCircle(center, radius, paint);

    //rysowanie tickow
    for(int i = 0; i < tickCount; i++){
      double angle = angleStart + (angleEnd - angleStart) * (i / (tickCount - 1));
      final tickStart = Offset(
        center.dx + (radius) * cos(angle),
        center.dy + (radius) * sin(angle)
      );
      final tickEnd = Offset(
        center.dx + (radius - 20) * cos(angle),
        center.dy + (radius - 20) * sin(angle)
      );
      final tickPaint = Paint()
        ..color = Colors.blueGrey.shade100
        ..strokeWidth = 2
        ..isAntiAlias = true
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(tickStart, tickEnd, tickPaint);
    
      //rysowanie liczb
      final textPainter = TextPainter(
        text: TextSpan(
          text: (maxSpeed * i / (tickCount - 1) ).toStringAsFixed(0),
          style: const TextStyle(
            fontSize: 12, 
            color: Colors.blueGrey,
            fontFeatures: [FontFeature.tabularFigures()]
          )
        ),  
        textDirection: TextDirection.ltr,
      )..layout();

      final offset = Offset(
        center.dx + (radius - 35) * cos(angle) - textPainter.width / 2,
        center.dy + (radius - 35) * sin(angle) - textPainter.height / 2
      );
      textPainter.paint(canvas, offset);
    }

    //wskazowka
    double needleAngle = angleStart +
      (angleEnd - angleStart) * (speed.clamp(0, maxSpeed) / maxSpeed);
    final needlePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;
    final needleEnd = Offset(
      center.dx + (radius - 30) * cos(needleAngle),
      center.dy + (radius - 30) * sin(needleAngle),
    );
    canvas.drawLine(center, needleEnd, needlePaint);

    //kolko na srodku
    final centerPaint = Paint()
      ..color = Colors.black
      ..isAntiAlias = true;
    canvas.drawCircle(center, 6, centerPaint);

    //aktualna prędkość
    final speedText = TextPainter(
      text: TextSpan(
        text: "${speed.toStringAsFixed(2)} kts",
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w200, 
          color: Colors.white.withValues(alpha: 0.8), 
          letterSpacing: 1.8,
          fontFeatures: [FontFeature.tabularFigures()]
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    speedText.paint(
        canvas, Offset(center.dx - speedText.width / 2, center.dy + radius / 2));
  
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}