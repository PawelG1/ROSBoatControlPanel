import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ros_visualizer/providers/ros_params_providers.dart';
import 'package:ros_visualizer/services/socketService.dart';
import 'package:ros_visualizer/widgets/gauges/alititudeInd.dart';
import 'package:ros_visualizer/widgets/gauges/azimuthInd.dart';
import 'package:ros_visualizer/widgets/gauges/speedGauge.dart';
import 'package:ros_visualizer/widgets/menuSideBar.dart';

class Dashboard extends ConsumerWidget{
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    //final pitch = ref.watch(pitchProvider);
    // Remove this line that might cause issues
    // ref.watch(socketServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      backgroundColor: Colors.black,
      body: Row( //on the left side of a row should be menu bar
        children: [
          const Menusidebar(),
          //main dashboard content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Column(//column with altiudde
                      children: [
                        AltitudeInd(pitchProvider: pitchProvider, rollProvider: rollProvider, radius: screenWidth*0.2,),
                        // SizedBox(
                        //   width: screenWidth*0.25,
                        //   child: Slider(
                        //     value: ref.watch(pitchProvider),
                        //     min: -50,
                        //     max: 50,
                        //     onChanged: (val){ref.read(pitchProvider.notifier).state = val;}
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: screenWidth*0.2,
                        //   child: Slider(
                        //     value: ref.watch(rollProvider),
                        //     min: -50,
                        //     max: 50,
                        //     onChanged: (val){ref.read(rollProvider.notifier).state = val;}
                        //   ),
                        // )
                      ],
                    ),

                    Column( //speedometer
                      children: [
                        SpeedGauge(speedProvider: speedProvider, maxSpeed: 120, radius: screenWidth*0.2),
                        SizedBox(
                          width: 300,
                          child: Slider(
                            value: ref.watch(speedProvider),
                            min: 0,
                            max: 120,
                            onChanged: (val){ref.read(speedProvider.notifier).state = val;}
                          ),
                        ),
                      ],
                    ),

                    //azimuth gauge
                    Column(
                      children: [
                        Azimuthind()
                      ],
                    )

                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  

}
