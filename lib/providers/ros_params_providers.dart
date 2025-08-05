import 'package:flutter_riverpod/flutter_riverpod.dart';

final speedProvider = StateProvider<double>((ref)=> 0.0);
final pitchProvider = StateProvider<double>((ref) => 0.0);
final rollProvider = StateProvider<double>((ref) => 0.0);