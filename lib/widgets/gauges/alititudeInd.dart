import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";


class AltitudeInd extends ConsumerWidget{
  final StateProvider<double> pitchProvider;
  final StateProvider<double> rollProvider;
  final double radius;

  const AltitudeInd({super.key, required this.pitchProvider, required this.rollProvider, this.radius = 200});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitch = ref.watch(pitchProvider);
    final roll = ref.watch(rollProvider);

    return CustomPaint(
      size: Size(radius, radius),
      painter: AlititudeIndPainter()
      ..pitch = pitch
      ..roll = roll
    );
  }
}

class AlititudeIndPainter extends CustomPainter {

  double _roll = 0;
  double _pitch = 0;

  set roll(val) {_roll = val;}
  set pitch(val) {_pitch = val;}

  @override
  void paint(Canvas canvas, Size size) {
    final centerOffset = Offset(size.width/2, size.height/2); 
    final radius = min(size.width, size.height) / 2;


    drawBg(canvas, size, centerOffset, radius, _roll, _pitch);
    drawAngleInd(canvas, size, centerOffset, radius, _roll, _pitch);
    drawPlaneInd(canvas, radius, centerOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
  
void drawBg(Canvas canvas,Size size, Offset center, radius,double roll, double pitch){

    var paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = radius * 0.04 //scalable stroke width
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..filterQuality = FilterQuality.high;
    canvas.drawCircle(center, radius, paint);

    //angles to radians
    roll = roll * pi/180;

    paint
      ..color = Colors.lightBlue
      ..strokeWidth = radius * 0.027 //scalable stroke width
      ..style = PaintingStyle.fill;

  //draw blue circle for sky representation 
    canvas.drawCircle(center, radius, paint);

  //ground level drawing
    paint.color = Colors.brown;
    
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(roll);
    
    //clipping path for ground - scale pitch relative to radius
    final clipPath = Path();
    double scaledPitch = pitch * (radius / 150.0); //normalize pitch to 150px base radius
    clipPath.addRect(Rect.fromLTWH(-radius, scaledPitch, radius * 2, radius * 2));
    canvas.clipPath(clipPath);
    
    //full circle, but only ground portion will be visible due to clipping
    canvas.drawCircle(Offset(0, 0), radius, paint);

    canvas.restore();

}

void drawAngleInd(Canvas canvas,Size size, Offset center,double radius,double roll, double pitch){
  roll = roll * pi/180.0;
  canvas.save();
  canvas.translate(center.dx, center.dy);
  canvas.rotate(roll);

  var paint = Paint()
    ..color = Colors.white
    ..strokeWidth = radius * 0.012 //scalable stroke width
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..filterQuality = FilterQuality.high;

  //roll marks - scalable
  final startAngle = 270.0;
  double lineLength = radius * 0.12; //scalable line length
  for(int i=0; i<=6; i++){
    roll = degToRad(startAngle + i * 15);
    canvas.drawLine(
      Offset(radius * cos(roll), radius * sin(roll)),
      Offset((radius - lineLength) * cos(roll), (radius - lineLength) * sin(roll)),
      paint
    );
    roll = degToRad(startAngle - i * 15);
    canvas.drawLine(
      Offset(radius * cos(roll), radius * sin(roll)),
      Offset((radius - lineLength) * cos(roll), (radius - lineLength) * sin(roll)),
      paint
    );
  }

  //pitch marks - scalable
  double scaledPitch = pitch * (radius / 150.0); //scale pitch relative to widget size
  canvas.translate(0, scaledPitch);
  //horizon line with circle bounds checking
  if (scaledPitch.abs() < radius) {
    double maxHorizonWidth = sqrt(radius * radius - scaledPitch * scaledPitch);
    canvas.drawLine(Offset(-maxHorizonWidth, 0), Offset(maxHorizonWidth, 0), paint);
  }
  
  double pitchLineLength = radius * 0.09; //scalable pitch line length
  double pitchSpacing = radius * 0.2; //scalable pitch spacing
  for(int i=1; i<=3; i++){ 
    canvas.drawLine(Offset(-pitchLineLength, -(pitchSpacing*i)), Offset(pitchLineLength, -(pitchSpacing*i)), paint);
    canvas.drawLine(Offset(-pitchLineLength, (pitchSpacing*i)), Offset(pitchLineLength, (pitchSpacing*i)), paint);
  }

  canvas.restore();
}

double degToRad(double angle){
  return angle * pi / 180;
}

void drawPlaneInd(Canvas canvas,double radius, Offset center){
    var paint = Paint()
    ..isAntiAlias = true
    ..color = Colors.amberAccent.shade200
    ..strokeWidth = radius * 0.04 //scalable stroke width
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..filterQuality = FilterQuality.high;

    //left wing - scalable
    final leftPath = Path();
    leftPath.moveTo(center.dx - (radius * 0.20), center.dy + (radius * 0.16));
    leftPath.lineTo(center.dx - (radius * 0.20), center.dy);
    leftPath.lineTo(center.dx - (radius * 0.82), center.dy);
    canvas.drawPath(leftPath, paint);

    //right wing - scalable
    final rightPath = Path();
    rightPath.moveTo(center.dx + (radius * 0.20), center.dy + (radius * 0.16));
    rightPath.lineTo(center.dx + (radius * 0.20), center.dy);
    rightPath.lineTo(center.dx + (radius * 0.82), center.dy);
    canvas.drawPath(rightPath, paint);

    //center dot - scalable
    paint.style = PaintingStyle.fill;
    double centerDotSize = radius * 0.06;
    canvas.drawRect(Rect.fromCenter(center: center, width: centerDotSize, height: centerDotSize), paint);

}