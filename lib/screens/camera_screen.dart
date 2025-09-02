import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:mjpeg_stream/mjpeg_stream.dart';
import 'package:ros_visualizer/services/socketService.dart';
import 'package:ros_visualizer/widgets/dashboard_card.dart';
import 'package:ros_visualizer/widgets/menuSideBar.dart';

class CameraScreen extends ConsumerWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const Menusidebar(),
        DashboardCard(
          height: double.infinity,
          title: "",
          child: const Expanded(
            child: VideoStreamWidget(),
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
    final String streamUrl = 'http://${videoSourceAddr}:8080/stream?topic=/image_raw&type=mjpeg&quality=30&width=640&height=480';
    return Column(
      children: [
        Text("addr: $videoSourceAddr"),
        Mjpeg(
          stream: streamUrl,
          isLive: true,
          error: (contet, error, stack) {
            debugPrint("stack: $stack\n error: $error\nstack:$stack");
            return Center(child: Text("stack: $stack\n error: $error\nstack:$stack", softWrap: true,));
          },
          fit: BoxFit.scaleDown,
        ),
      ],
    );
    
  }
}

