import 'dart:async';
//import 'dart:ffi' hide Size;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ros_visualizer/widgets/azimuthInd.dart';
import 'package:ros_visualizer/widgets/speedGauge.dart';
import 'package:ros_visualizer/widgets/alititudeInd.dart';
import 'package:ros_visualizer/widgets/customButton.dart';

final speedProvider = StateProvider<double>((ref)=> 0.0);
final pitchProvider = StateProvider<double>((ref) => 0.0);
final rollProvider = StateProvider<double>((ref) => 0.0);

void main() {
  runApp(ProviderScope(child: MaterialApp(home: Dashboard())));
}

class MainApp extends ConsumerStatefulWidget{
  const MainApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppState();
  
}

class Dashboard extends ConsumerWidget{
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row( //on the left side of a row should be menu bar
        children: [
          Container(
            width: screenWidth* 0.18,
            height: double.infinity,
            color: Colors.blueAccent,
            child: Column(
              children: [
                CustomButton(
                  text: "Dashboard",
                  onPressed: () {},
                ),
                
                CustomButton(
                  text: "Connection Settings",
                  onPressed: () {},
                ),

                CustomButton(
                  text: "Charts",
                  onPressed: () {},
                ),

                
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    //space between menu and the displayed dashboard
                    Spacer(),
                    Column(//column with altiudde
                      children: [
                        AltitudeInd(pitchProvider: pitchProvider, rollProvider: rollProvider, radius: screenWidth*0.2,),
                        SizedBox(
                          width: screenWidth*0.25,
                          child: Slider(
                            value: ref.watch(pitchProvider),
                            min: -50,
                            max: 50,
                            onChanged: (val){ref.read(pitchProvider.notifier).state = val;}
                          ),
                        ),
                        SizedBox(
                          width: screenWidth*0.2,
                          child: Slider(
                            value: ref.watch(rollProvider),
                            min: -50,
                            max: 50,
                            onChanged: (val){ref.read(rollProvider.notifier).state = val;}
                          ),
                        )
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


class _MainAppState extends ConsumerState<MainApp>{
  double prevSpeed = 0.0;
  double targetSpeed = 0.0;
  late Timer timer;

  @override
  void initState(){
    super.initState();
    //losowanie docelowej predkosci co 1.5s
    timer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      setState(() {
        prevSpeed = targetSpeed;
        targetSpeed = Random().nextDouble() * 160; //max speed 10
      });
    });
  }
  
  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: prevSpeed, end: targetSpeed),
        duration: const Duration(milliseconds: 1500),
        onEnd: () {
            // po animacji ustaw do providera finalną wartość (opcjonalnie)
            //ref.read(speedProvider.notifier).state = targetSpeed;
          },
        builder: (context, value, child){
          
          //ref.read(speedProvider.notifier).state = value;
          
          return CustomPaint(
            size: const Size(300, 300),
            painter: SpeedGaugePainter(
              speed: value,
              maxSpeed: 160, 
              tickCount: 11),
          );

          //return AltitudeInd(pitch: value);

        }
      ),
    );
  }
}