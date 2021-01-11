import 'dart:async';
import 'dart:collection';

import 'package:async/async.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fitnsocial/models/graph_model.dart';
import 'package:flutter_app_fitnsocial/models/radialProgress_model.dart';
import 'package:flutter_app_fitnsocial/models/tableEntry_model.dart';
import 'package:flutter_app_fitnsocial/utilities/graphData.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:time_range/time_range.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin<HomeScreen> {
  bool _progressController = true;
  AnimationController _graphAnimationController;
  Map<String, double> dataMap = {};
  List<Color> colorList = [
    Colors.red,
    Color(0xFF276FBF),
    Colors.blue,
    Colors.yellow,
  ];
  List<GraphData> weekData = [
  ];
  List<String> weekDays = ["MON", "TUE","WED","THU","FRI","SAT","SUN"];
  List<TableEntry> tableEntries = [];
  String date = "--/--/----";
  String category, notes, time;
  String day;
  ScrollController _controller = ScrollController();
  TextEditingController con1 = TextEditingController();
  TextEditingController con2 = TextEditingController();
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  final rootRef = FirebaseDatabase.instance.reference();
  final FirebaseAuth auth = FirebaseAuth.instance;



  @override
  void initState() {
    super.initState();
    _graphAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _graphAnimationController.forward();
    getData();
    run();

  }

  @override
  void dispose() {
    _graphAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Stack(
        children: [
      Container(
        height: MediaQuery.of(context).size.height*.8,
      padding: const EdgeInsets.fromLTRB(20.0,20,20,30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                buildCustomGridCard(
                  title: "Total Activity Time",
                  color: Color(0xffFF6968),
                  custom: _progressController
                      ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),)
                      :Container(
                    decoration: BoxDecoration(
                      color: Color(0xffFF6968),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10,0,10,0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(getTotalActivityTime().substring(0,getTotalActivityTime().indexOf("h")+1),
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize:MediaQuery.of(context).size.width/12.5),
                                  ),
                                  Text(getTotalActivityTime().substring(getTotalActivityTime().indexOf("h")+1),
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white70,
                                        fontSize:MediaQuery.of(context).size.width/20),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text('△20% vs\nprevious week',
                                style: GoogleFonts.montserrat(
                                    color: Colors.black38,
                                    fontSize:MediaQuery.of(context).size.width/22.5),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                 buildCustomGridCard(
                  title: "Activity",
                  color: Color(0xff7A54FF),
                  icon: 'icons/sleep.svg',
                  dis: '80 - 20\nhealthy',
                  lable1: '8 h ',
                  lable2: '42 m',
                  custom:  _progressController
                      ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),)
                      :SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                        child: PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 15,
                    colorList: colorList,
                    chartRadius: 60,
                    initialAngleInDegree: 30,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 7.5,
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
                        showChartValueBackground: false,
                        showChartValues: false,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                    ),
                  ),
                      ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
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
                        SizedBox(height: 15),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: _progressController
                              ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),)
                              : Graph(
                              animationController: _graphAnimationController,
                              values: weekData,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                buildCustomGridCard(
                  title: "Goal Days",
                  color: Color(0xff2AC3FF),
                  custom:  _progressController
                      ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),)
                      :CalendarTimeline(
                    initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
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
                  ),
                ),
                buildCustomGridCard(
                  title: "Badges",
                  color: Color(0xffFF8F61),
                  custom:  _progressController
                      ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),)
                      :Container(
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
          ],
        ),
      ),
      ),
          SlidingUpPanel(
            minHeight: MediaQuery.of(context).size.height * 1 / 15,
            maxHeight: MediaQuery.of(context).size.height * 3 / 4,
            backdropEnabled: true,
            panelSnapping: true,
            defaultPanelState: PanelState.CLOSED,
            panelBuilder:(s) => ListView.separated(
              controller: _controller = s,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index){
                return _panel(_controller);
              },
              separatorBuilder: (BuildContext context, int index){
                return Divider();
              },
            ),
          ),
    ],
      )
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
      padding: EdgeInsets.only(top: 13, left: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: GoogleFonts.montserrat(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize:16),
          ),
          SizedBox(height: 5),
          Expanded(
            child: SingleChildScrollView(child: custom),
          ),
        ],
      ),
    );
  }

  _panel(ScrollController sc) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25,5,10,0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Center(
              child: Container(
                height: 3,
                width: 40,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5,),
            Text("Activity Tracker",
              style: GoogleFonts.montserrat(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize:
                  MediaQuery.of(context).size.width / 20),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Text("Date",
                  style: GoogleFonts.montserrat(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize:
                      MediaQuery.of(context).size.width / 25),
                ),
                SizedBox(width: 20,),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  iconSize: 25,
                  onPressed: () async {
                    DateTime d = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101),
                    );
                    setState(() {
                      date = new DateFormat.yMMMMd("en_US").format(d);
                      day = new DateFormat('E, MMM d').format(d);
                    });
                  },
                ),
                Text(date,
                  style: GoogleFonts.montserrat(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize:
                      MediaQuery.of(context).size.width / 25),
                ),
              ],
            ),
            Text("Time",
              style: GoogleFonts.montserrat(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize:
                  MediaQuery.of(context).size.width / 25),
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                Expanded(
                  child: TimeRange(
                    fromTitle: Text('From', style: GoogleFonts.montserrat(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize:
                        MediaQuery.of(context).size.width / 32.5),),
                    toTitle: Text('To', style: GoogleFonts.montserrat(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize:
                        MediaQuery.of(context).size.width / 32.5),),
                    textStyle: GoogleFonts.montserrat(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize:
                        MediaQuery.of(context).size.width / 32.5),
                    activeTextStyle: GoogleFonts.montserrat(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize:
                        MediaQuery.of(context).size.width / 32.5),
                    borderColor: Colors.black54,
                    backgroundColor: Colors.transparent,
                    activeBackgroundColor: Colors.pink[400],
                    activeBorderColor: Colors.black,
                    firstTime: TimeOfDay(hour: 0, minute: 00),
                    lastTime: TimeOfDay(hour: 24, minute: 00),
                    timeStep: 10,
                    timeBlock: 30,
                    titlePadding: 20,
                    onRangeCompleted: (range) {
                      time = (range.end.compare(range.start).toString());
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 15,),
            Text("Activity",
              style: GoogleFonts.montserrat(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize:
                  MediaQuery.of(context).size.width / 25),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left:20, right: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: con1,
                      maxLines: null,
                      decoration: new InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Category:",
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        //fillColor: Colors.green
                      ),
                      onChanged:(textValue){
                        setState(() {
                          category = textValue.trim();
                        });
                      },
                      validator: (val) {
                        if (val.length == 0) {
                          return "Email cannot be empty";
                        } else {
                          return null;
                        }
                      }),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: con2,
                      maxLines: null,
                      decoration: new InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Notes:",
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        //fillColor: Colors.green
                      ),
                      onChanged:(textValue){
                        setState(() {
                          notes = textValue.trim();
                        });
                      },
                      validator: (val) {
                        if (val.length == 0) {
                          return "Email cannot be empty";
                        } else {
                          return null;
                        }
                      }),
                ],
              ),
            ),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey,
                    child:  Text("Clear",
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize:
                          MediaQuery.of(context).size.width / 25),
                    ),
                  ),
                  onTap: (){
                    con1.clear();
                    con2.clear();
                    time = "";
                    notes = "";
                    category = "";
                  },
                ),
                SizedBox(width: 25,),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.pink,
                    child:  Text("Submit",
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize:
                          MediaQuery.of(context).size.width / 25),
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      addEntry(category, notes, time, day);
                      Timer(Duration(milliseconds: 100), () {
                        _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 750),
                        );
                      });
                    });

                  },
                ),
              ],
            ),
            Divider(
              height: 40,
              thickness: 1,
            ),
            Text("Activity Diary",
              style: GoogleFonts.montserrat(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize:
                  MediaQuery.of(context).size.width / 25),
            ),
            SizedBox(height: 5,),
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: tableEntries.length,
              itemBuilder: (BuildContext context, int index){
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/4,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                          ),
                          child: Text(tableEntries[index].category,
                            style: GoogleFonts.montserrat(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize:
                                MediaQuery.of(context).size.width / 35),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                          ),
                          child: Text(tableEntries[index].notes,
                            style: GoogleFonts.montserrat(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize:
                                MediaQuery.of(context).size.width / 35),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Container(
                          width: MediaQuery.of(context).size.width/6,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                          ),
                          child: Text(tableEntries[index].time,
                            style: GoogleFonts.montserrat(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize:
                                MediaQuery.of(context).size.width / 35),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit_outlined),
                          constraints: BoxConstraints(),
                          iconSize: 25,
                          onPressed: () {
                          },
                        ),
                      ],
                    ),
                    Divider(height: 10,thickness: 1,),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }


  void addEntry(String category, String notes, String time, day) {
    rootRef.child("Users").child(auth.currentUser.uid).child("Diary").push().set({
      'category':category,
      'notes':notes,
      'time':time,
      'date': day,

    });
    setState(() {
      tableEntries.add(new TableEntry(category, notes, time, day));
    });
  }

  String getTotalActivityTime() {
    int totalTime = 0;
    for(TableEntry i in tableEntries){
      totalTime+=int.parse(i.time);
    }
    int hours = totalTime ~/ 60;
    int minutes = totalTime % 60;
    return hours.toString() + " h " + minutes.toString() + " m";

  }

  addData(data, day, time) {
    dataMap.putIfAbsent(data, ()=> 2.0);
    if(contains(day,weekData)){
      for(int i = 0; i < weekData.length;i++){
        if(weekData[i].label==day)
          weekData[i].value=weekData[i].value+int.parse(time);
        i = weekData.length-1;
      }
    }
    else
      weekData.add(new GraphData(day, int.parse(time)));
  }

  bool contains(String element, List<GraphData> weekData) {
    for (GraphData e in weekData) {
      if (e.label == element) {
        return true;
      }
    }
    return false;
  }

  void getData() {
    rootRef.child("Users").child(auth.currentUser.uid).child("Diary").once().then((value)  {
      if(value!=null) {
        var keys = value.value.keys;
        var data = value.value;
        for (var key in keys) {
          tableEntries.add(new TableEntry(
              data[key]['category'], data[key]['notes'], data[key]['time'],
              data[key]['day'].toString().substring(0,3).toUpperCase()));
          addData(data[key]['category'], data[key]['date'].toString().substring(0,3).toUpperCase(), data[key]['time']);
        }
        fillData();
        setState(() {

        });
      }
    });
    setState(() {

    });
  }

  run() {
    return this._memoizer.runOnce(() async {
      await Future.delayed(Duration(milliseconds: 500));
        _progressController = false;
        setState(() {

        });
      });
  }

  void fillData() {
    List<String> s = [];
    for(int j = 0; j < weekData.length; j++){
      if(!s.contains(weekData[j].label.substring(0,3).toUpperCase())){
        s.add(weekData[j].label);
      }
    }
    for(int i = 0; i < weekDays.length; i++){
      if(!s.contains(weekDays[i])){
        weekData.add(new GraphData(weekDays[i].substring(0,3).toUpperCase(), 0));
      }
    }
    weekData.sort((a, b) => weekDays.indexOf(a.label).compareTo(weekDays.indexOf(b.label)));

  }


}

