
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ros_visualizer/routes.dart';
import 'package:ros_visualizer/screens/dashboard_screen.dart';

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      title: 'ROS Visualizer',
      theme: ThemeData.dark(),
    );
  }
  
}


