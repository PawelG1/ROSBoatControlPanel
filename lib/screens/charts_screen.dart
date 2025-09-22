import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ros_visualizer/widgets/dashboard_card.dart';
import 'package:ros_visualizer/widgets/menuSideBar.dart';
import 'package:web/helpers.dart' hide Text;
import 'dart:math';


class ChartsScreen extends ConsumerWidget{
  const ChartsScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Material(
      color: Colors.black,
      child: Row(
        children: [
          Menusidebar(),
          DashboardCard(title: "", child: 
            Column(
              children: [

                ChartBar(title: "Battery Temp", minSafeValue: -1, maxSafeValue: 1,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 10, color: Colors.blueAccent, thickness: 1,),
                ),
                ChartBar(title: "Cpu Temp"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 10, color: Colors.blueAccent, thickness: 1,),
                ),
                ChartBar(title: "Depth"),



              ],
            )
          )
          
        ],
      ),
    );
  }
}

class ChartBar extends StatelessWidget{
  final String title;
  //final String xAxis;
  //final String yAxis;
  double minSafeValue;
  double maxSafeValue;

  ChartBar({super.key, required this.title, this.minSafeValue = -double.infinity, this.maxSafeValue = double.infinity});

  @override
  Widget build(BuildContext context) {

    List<FlSpot> pointsList = [];
    for(int i=0; i <= 360; i+=30){
      pointsList.add(FlSpot(i.toDouble(), sin(i*(pi/180))));
    }

    List<LineChartBarData> barDatas = [
      LineChartBarData(
        isCurved: true,
        barWidth: 2.0,
        dotData: FlDotData(
          show: true
        ),
        gradient: LinearGradient(colors: [Colors.red,Colors.yellow, Colors.green],stops: [0.0, 0.5, 1.0], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        gradientArea: LineChartGradientArea.rectAroundTheLine,
        //color: Colors.amber,
        spots: pointsList
      )
    ]; 

    return Flexible(
      flex: 1,
      child: LineChart(
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 1800),
        LineChartData(
          gridData: FlGridData(
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: 0.25,
          ),
          baselineY: 0.0,
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              axisNameWidget: Text(title),
              axisNameSize: 20.0,
              )
          ),
          backgroundColor: Colors.black12,

          lineBarsData: barDatas
        )
      ),
    );
  }
  
}