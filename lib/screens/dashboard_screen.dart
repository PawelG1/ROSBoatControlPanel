import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ros_visualizer/providers/controls_providers.dart';
import 'package:ros_visualizer/providers/ros_params_providers.dart';
import 'package:ros_visualizer/services/socketService.dart';
import 'package:ros_visualizer/widgets/battery_ind.dart';
import 'package:ros_visualizer/widgets/gauges/alititudeInd.dart';
import 'package:ros_visualizer/widgets/gauges/azimuthInd.dart';
import 'package:ros_visualizer/widgets/gauges/speedGauge.dart';
import 'package:ros_visualizer/widgets/menuSideBar.dart';
import 'package:ros_visualizer/widgets/dashboard_card.dart';

class Dashboard extends ConsumerWidget{
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Dynamiczne proporcje w zależności od szerokości ekranu
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

                Row(//gauges
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DashboardCard(
                      title: 'Attitude',
                      flex: altitudeFlex,
                      accentColor: Colors.cyan,
                      child: AltitudeInd(
                        pitchProvider: pitchProvider, 
                        rollProvider: rollProvider, 
                        radius: screenWidth * 0.12,
                      ),
                    ),

                    DashboardCard(
                      title: 'Speed',
                      flex: speedFlex,
                      accentColor: Colors.lightBlue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SpeedGauge(
                              speedProvider: speedProvider, 
                              maxSpeed: 120, 
                              radius: screenWidth * 0.12,
                            ),
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
                      accentColor: Colors.blueAccent,
                      child: Azimuthind(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    DashboardCard(title: "Battery", flex: 1, child: BatteryInd(batteryVoltageStateProvider: batteryVoltageProvider),),

                    // Connection status and control settings
                    DashboardCard(title: "", 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //upper row of params
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        
                            // Connection status
                            Column(
                              children: [
                                Text(
                                  'Connection Status: ',
                                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                                ),
                                Text(
                                  ref.watch(connectionStatusProvider),
                                  style: TextStyle(
                                    color: ref.watch(connectionStatusProvider) == "connected" ? Colors.green : Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                        
                            // Connection status
                            Column(
                              children: [
                                Text(
                                  'Mode: ',
                                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                                ),
                                Text(
                                  "manual steering",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                        
                            // External Joystick switch
                            Column(
                              children: [
                                Text(
                                  'External Joystick: ',
                                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                                ),
                                Switch(
                                  activeColor: Colors.lightBlue,
                                  value: ref.watch(joystickProvider),
                                  onChanged: (val) {
                                    ref.read(joystickProvider.notifier).state = val;
                                  },
                                )
                              ],
                            ),
                        
                          ],
                        ),
                        
                        //lower row of params
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Course Over Ground
                            Column(
                              children: [
                                Text(
                                  'COG: ',
                                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                                ),
                                Text(
                                  "0.00 deg"
                                )
                              ]
                            ),

                            //Position
                            Column(
                              children: [
                                Text(
                                  'Position: ',
                                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                                ),
                                Text(
                                  "N 0.00 E 0.00"
                                )
                              ]
                            ),

                            //depth
                            Column(
                              children: [
                                Text(
                                  'Depth: ',
                                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                                ),
                                Text(
                                  "0.00 m"
                                )
                              ]
                            ),


                        ]
                      )

                      ],
                    )),
                    
                  ],
                ),
  
                ],
              ),    
            ),
          
        ],
      ),
    );
  }
}
