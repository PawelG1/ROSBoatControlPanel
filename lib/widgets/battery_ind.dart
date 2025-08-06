import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BatteryInd extends ConsumerWidget{
  final StateProvider<double> batteryVoltageStateProvider;
  
  const BatteryInd({super.key, required this.batteryVoltageStateProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return CustomPaint(
      size: Size(200, 200), // You can adjust the size as needed
      painter: BatteryIndPainter(batteryMaxVoltage: 12.6, batteryMinVoltage: 10.5)
        ..batteryVoltage = ref.watch(batteryVoltageStateProvider)
    );

  }
  
}

class BatteryIndPainter extends CustomPainter {
  final double batteryMaxVoltage; //max voltage for a fully charged battery
  final double batteryMinVoltage; //min voltage for a fully discharged battery
  final int batteryLevels = 5; // Number of battery levels to display


  double _batteryVoltage = 0; // Example voltage, you can replace it with a dynamic value

  BatteryIndPainter({this.batteryMaxVoltage = 12.6, this.batteryMinVoltage = 10.5});

  set batteryVoltage(double voltage) {
    _batteryVoltage = voltage;
  }

  get batteryLevel {
    // Calculate the battery level bars based on the voltage
    if (_batteryVoltage >= batteryMaxVoltage) {
      return batteryLevels; // Fully charged
    } else if (_batteryVoltage <= batteryMinVoltage) {
      return 0; // Fully discharged
    } else {
      return ((_batteryVoltage - batteryMinVoltage) / (batteryMaxVoltage - batteryMinVoltage) * batteryLevels).round();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(center.dx, center.dy);

    final paint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.fill;

    // Draw the battery body
    canvas.drawRect(Rect.fromCenter(center: center, width: radius * 0.5, height: radius * 0.7), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center + Offset(0, -radius * 0.7 * 0.5), width: radius * 0.3, height: radius * 0.16), Radius.circular(radius * 0.03)), paint);

    // Draw the rectangles for the battery level
    paint
      ..color = Colors.blueAccent.shade400
      ..filterQuality = FilterQuality.high
      ..style = PaintingStyle.fill;

    double batteryHeight = radius * 0.7;
    double batteryBottom = center.dy + batteryHeight * 0.5;
    double levelHeight = (batteryHeight - 4) / batteryLevels; // Leave 4px padding
    double levelWidth = radius * 0.45;
    
    for(int i = 0; i < batteryLevel; i++){
      // Draw bars from bottom to top with proper padding
      double yOffset = batteryBottom - 2 - (i + 1) * levelHeight;
      canvas.drawRect(Rect.fromLTWH(center.dx - levelWidth / 2, yOffset, levelWidth, levelHeight - 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}