import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers for received ROS parameters
final speedProvider = StateProvider<double>((ref)=> 0.0);
final pitchProvider = StateProvider<double>((ref) => 0.0);
final rollProvider = StateProvider<double>((ref) => 0.0);
final batteryVoltageProvider = StateProvider<double>((ref) => 11.6); 
final rudderAngleProvider = StateProvider<double>((ref) => 0.0);