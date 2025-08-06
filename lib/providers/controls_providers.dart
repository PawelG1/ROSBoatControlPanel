import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers for control settings
final joystickProvider = StateProvider<bool>((ref) => false);
final autonomousModeProvider = StateProvider<bool>((ref) => false);
