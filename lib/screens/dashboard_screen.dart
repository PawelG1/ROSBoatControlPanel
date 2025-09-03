import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ros_visualizer/providers/controls_providers.dart';
import 'package:ros_visualizer/providers/ros_params_providers.dart';
import 'package:ros_visualizer/services/socketService.dart';
import 'package:ros_visualizer/widgets/battery_ind.dart';
import 'package:ros_visualizer/widgets/gauges/attitudeInd.dart';
import 'package:ros_visualizer/widgets/gauges/azimuthInd.dart';
import 'package:ros_visualizer/widgets/gauges/speedGauge.dart';
import 'package:ros_visualizer/widgets/menuSideBar.dart';
import 'package:ros_visualizer/widgets/dashboard_card.dart';
import 'package:ros_visualizer/widgets/rudderAngleIndicator.dart';

class Dashboard extends ConsumerWidget{
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    int altitudeFlex = screenWidth > 1200 ? 3 : 2;
    int speedFlex = 2;
    int azimuthFlex = screenWidth > 1200 ? 1 : 1;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      backgroundColor: Colors.black,
      body: Row(
        children: [

          const Menusidebar(),
          // Main content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(//gauges
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DashboardCard(
                        title: 'Attitude',
                        flex: altitudeFlex,
                        accentColor: Colors.blue[500],
                        child: AttitudeInd(
                          pitchProvider: pitchProvider,
                          rollProvider: rollProvider,
                          radius: screenWidth * 0.12,
                        ),
                      ),
                      DashboardCard(
                        title: 'Speed',
                        flex: speedFlex,
                        accentColor: Colors.blue[500],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpeedGauge(
                              speedProvider: speedProvider,
                              maxSpeed: 120,
                              radius: screenWidth * 0.12,
                            ),
                            SizedBox(height: 15),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.lightBlue,
                                inactiveTrackColor: Colors.grey[700],
                                thumbColor: Colors.lightBlue,
                                overlayColor: Colors.lightBlue.withOpacity(0.3),
                              ),
                              child: Slider(
                                value: ref.watch(speedProvider),
                                min: 0,
                                max: 120,
                                onChanged: (val) => ref.read(speedProvider.notifier).state = val,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DashboardCard(
                        title: 'Compass',
                        flex: azimuthFlex,
                        accentColor: Colors.blue[500],
                        child: Azimuthind(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      //Battery indicator
                      DashboardCard(title: "Battery", flex: 1, child: BatteryInd(batteryVoltageStateProvider: batteryVoltageProvider),),
                      //Rudder angle indicator
                      DashboardCard(title: "Rudder Angle", flex: 1, child: Rudderangleindicator(rudderAngleProvider: rudderAngleProvider),),
                      //Connection status and control settings
                      DashboardCard(title: "",
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //upper row of params
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Connection status
                                  DataDisplay(
                                    title: 'Connection Status',
                                    data: ref.watch(connectionStatusProvider),
                                    dataTextStyle: TextStyle(color: ref.watch(connectionStatusProvider) == "Connected" ? Colors.green : Colors.red,),
                                  ),
                                  // External Joystick switch
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'External Joystick: ',
                                          maxLines: 1,
                                          style: TextStyle(color: Colors.blueAccent, overflow: TextOverflow.ellipsis),
                                        ),
                                        Switch(
                                          activeThumbColor: Colors.lightBlue,
                                          value: ref.watch(joystickProvider),
                                          onChanged: (val) {
                                            ref.read(joystickProvider.notifier).state = val;
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //lower row of params
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Course Over Ground
                                    DataDisplay(title: 'COG', data: ref.watch(courseOverGroundProvider).toString()),
                                    //Position
                                    DataDisplay(title: 'Position', data: ref.watch(positionProvider)),
                                    //depth
                                    DataDisplay(title: 'Depth', data: ref.watch(depthProvider).toString()),
                                  ]
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),        ],
      ),
    );
  }
}

class DataDisplay extends ConsumerWidget{
  const DataDisplay({
    super.key,
    required this.title,
    required this.data,
    this.dataTextStyle = const TextStyle(color: Colors.white),
    });

  final String title;
  final String data;
  final TextStyle dataTextStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.blueAccent, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          data,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: dataTextStyle
        ),
      ],
    );
  }
}