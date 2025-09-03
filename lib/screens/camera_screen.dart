import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ros_visualizer/providers/ros_params_providers.dart';
//import 'package:mjpeg_stream/mjpeg_stream.dart';
import 'package:ros_visualizer/services/socketService.dart';
import 'package:ros_visualizer/widgets/battery_ind.dart';
import 'package:ros_visualizer/widgets/dashboard_card.dart';
import 'package:ros_visualizer/widgets/gauges/attitudeInd.dart';
import 'package:ros_visualizer/widgets/gauges/azimuthInd.dart';
import 'package:ros_visualizer/widgets/menuSideBar.dart';

class CameraScreen extends ConsumerWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const Menusidebar(),
        Expanded(
          child: Stack(
            //fit: StackFit.expand,
            children:[
            DashboardCard(
              height: double.infinity,
              title: "addr: ${ref.watch(ipProvider.notifier).state}",
              child: SizedBox(
                child: const VideoStreamWidget(),
              ),
            ),
            Positioned(
              top: 20, right: 20,
              child: 
              BatteryInd(batteryVoltageStateProvider: batteryVoltageProvider),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 320,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: AttitudeInd(
                        pitchProvider: pitchProvider, 
                        rollProvider: rollProvider,
                        radius: 200,
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Azimuthind(radius: 200),
                    ),
                  ],
                ),
              )
            )
          
            ]
          ),
        ),
        
      ],
    );
  }
}

class VideoStreamWidget extends ConsumerStatefulWidget{
  const VideoStreamWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return VideoStreamWidgetState();
  }
}

class VideoStreamWidgetState extends ConsumerState<VideoStreamWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String videoSourceAddr = ref.watch(ipProvider.notifier).state;
    final String streamUrl = 'http://${videoSourceAddr}:8080/stream?topic=/image_raw&type=mjpeg&quality=30&width=1280&height=720';
    
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Mjpeg(
          stream: streamUrl,
          isLive: true,
          error: (contet, error, stack) {
            debugPrint("stack: $stack\n error: $error\nstack:$stack");
            return Center(child: Text("stack: $stack\n error: $error\nstack:$stack", softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 8),));
          },
          fit: BoxFit.cover,
        ),
      ),
    );
    
  }
}

