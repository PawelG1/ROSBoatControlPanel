import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ros_visualizer/screens/connection_screen.dart';
import 'package:ros_visualizer/screens/dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return router;
});

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Dashboard(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const Dashboard(),
    ),
    GoRoute(
      path: '/connection-settings',
      builder: (context, state) => const ConnectionScreen(),
    ),
    
  ],
);
