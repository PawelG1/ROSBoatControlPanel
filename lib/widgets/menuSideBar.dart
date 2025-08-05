import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ros_visualizer/widgets/customButton.dart';

class Menusidebar extends ConsumerWidget {
  const Menusidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
            width: MediaQuery.of(context).size.width * 0.18,
            height: double.infinity,
            color: Colors.blueAccent,
            child: Column(
              children: [
                CustomButton(
                  text: "Dashboard",
                  onPressed: () {
                    context.go('/');
                  },
                ),
                
                CustomButton(
                  text: "Connection Settings",
                  onPressed: () {
                    context.go('/connection-settings');
                  },
                ),

                CustomButton(
                  text: "Charts",
                  onPressed: () {},
                ),

                
              ],
            ),
          );
  }
}