import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardCard extends ConsumerWidget {
  final String title;
  final Widget child;
  final double? height;
  final Color? accentColor;
  final int? flex;

  const DashboardCard({
    super.key,
    required this.title,
    required this.child,
    this.height = 400,
    this.accentColor,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = accentColor ?? Colors.lightBlue;
    
    return Expanded(
      flex: flex!,
      child: Container(
        height: height,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withValues(alpha: 0.8),//withOpacity(0.8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow( //podswietlenie backgroundu
              color: color.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 3,
              offset: Offset(0, 8),
            ),
            BoxShadow(
              color: color.withValues(alpha: 0.2), //wewnętrzny cień
              blurRadius: 35,
              spreadRadius: -5,
              offset: Offset(0, 15),
            ),
            // Wewnętrzny blask
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 5,
              spreadRadius: -2,
              offset: Offset(0, -2),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[850]!.withValues(alpha: 0.9),
              Colors.grey[900]!.withValues(alpha: 0.8),
              Colors.black.withValues(alpha: 0.9),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
