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
        Stack(
          children:[
          DashboardCard(
            height: double.infinity,
            title: "",
            child: SizedBox(
              child: Expanded(
                child: const VideoStreamWidget(),
              ),
            ),
          ),
          Positioned(
            top: 20, right: 20,
            child: 
            BatteryInd(batteryVoltageStateProvider: batteryVoltageProvider),
          ),
          Positioned(
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              AttitudeInd(pitchProvider: pitchProvider, rollProvider: rollProvider),
              Azimuthind(),
              ]
            )
          )

          ]
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
    final String streamUrl = 'http://${videoSourceAddr}:8080/stream?topic=/image_raw&type=mjpeg&quality=30&width=640&height=480';
    return Column(
      children: [
        Text("addr: $videoSourceAddr"),
        Mjpeg(
          width: 1024,
          height: 720,
          stream: streamUrl,
          isLive: true,
          error: (contet, error, stack) {
            debugPrint("stack: $stack\n error: $error\nstack:$stack");
            return Center(child: Text("stack: $stack\n error: $error\nstack:$stack", softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 8),));
          },
          fit: BoxFit.scaleDown,
        ),
      ],
    );
    
  }
}

