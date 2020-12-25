import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fitnsocial/models/graph_model.dart';
import 'package:flutter_app_fitnsocial/models/radialProgress_model.dart';
import 'package:flutter_app_fitnsocial/utilities/graphData.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin<HomeScreen> {
  AnimationController _graphAnimationController;
  Map<String, double> dataMap = {
    "Cardio": 5,
    "Strength": 3,
    "Sports": 2,
    "Rec": 2,
  };
  List<Color> colorList = [
    Colors.red,
    Color(0xFF276FBF),
    Colors.blue,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    _graphAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _graphAnimationController.forward();

  }
  @override
  void dispose() {
    _graphAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white10,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  buildGridCard(
                    title: "Total Activity Time",
                    color: Color(0xffFF6968),
                    icon: 'icons/heart-rate.svg',
                    dis: '△20% vs\nprevious week',
                    lable1: '8 h ',
                    lable2: '42 m',
                  ),
                  buildCustomGridCard(
                    title: "Activity",
                    color: Color(0xff7A54FF),
                    icon: 'icons/sleep.svg',
                    dis: '80 - 20\nhealthy',
                    lable1: '8 h ',
                    lable2: '42 m',
                    custom: PieChart(
                      dataMap: dataMap,
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 15,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 10,
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: GoogleFonts.montserrat(
                            color: Colors.white54,
                            fontSize:
                            MediaQuery.of(context).size.width / 35),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: false,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(16),

    ),
                    padding: EdgeInsets.all(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily Activity",
                          style: GoogleFonts.montserrat(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize:16),
                        ),
                        SizedBox(height: 25),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: Graph(
                              animationController: _graphAnimationController,
                              values: weekData
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 35,),
            Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    buildCustomGridCard(
                      title: "Goal Days",
                      color: Color(0xff2AC3FF),
                      custom: CalendarTimeline(
                        initialDate: DateTime(2020, 2, 20),
                        firstDate: DateTime(2020, 2, 15),
                        lastDate: DateTime(2021, 11, 20),
                        onDateSelected: (date) => print(date),
                        leftMargin: 10,
                        monthColor: Colors.white70,
                        dayColor: Colors.black54,
                        dayNameColor: Color(0xFF333A47),
                        activeDayColor: Colors.white,
                        activeBackgroundDayColor: Colors.redAccent[100],
                        dotsColor: Color(0xFF333A47),
                        selectableDayPredicate: (date) => date.day != 23,
                      ),
                    ),
                    buildCustomGridCard(
                      title: "Badges",
                      color: Color(0xffFF8F61),
                      custom: Container(
                        padding: EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: RadialProgress(45, Image.asset("lib/images/thanksgiving_day_challenge_5k.png")),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 13),
                                    child: Text("45%",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black38,
                                          fontSize:
                                          MediaQuery.of(context).size.width / 17,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Text("Badge Name",
                                style: GoogleFonts.montserrat(
                                    color: Colors.black87,
                                    fontSize:
                                    MediaQuery.of(context).size.width / 30,
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      )
    );
  }

  Widget buildGridCard({
    String title,
    String icon,
    String lable1,
    String lable2,
    String dis,
    Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: GoogleFonts.montserrat(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize:16),
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Text(lable1,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize:35),
                    ),
                    Text(lable2,
                      style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize:25),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(dis,
                      style: GoogleFonts.montserrat(
                          color: Colors.black38,
                          fontSize:20),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomGridCard({
    String title,
    String icon,
    String lable1,
    String lable2,
    String dis,
    Color color,
    Widget custom,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Text(title,
                    style: GoogleFonts.montserrat(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize:16),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: custom,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
