import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'models/member_model.dart';
class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  List<Member> users;
  StreamController<List<Member>> _streamController;

  @override
  void initState() {
    _streamController = StreamController<List<Member>>();
    ///INSTANTIATE USERS LIST FROM DATABASE
    users = [
      new Member(
          "https://picsum.photos/250?image=9",
          "Raj P.",
          "Junior",
          "5'11",
          140,
          ["Comp Sci", "Business"],
          ["goal1", "goal2", "goal1", "goal2", "goal1", "goal2"],
          ["Activity1", "Activity2"]),
      new Member(
          "https://picsum.photos/250?image=10",
          "Tej P.",
          "Junior",
          "5'11",
          140,
          ["Comp Sci", "Business"],
          ["goal1", "goal2", "goal1", "goal2", "goal1", "goal2"],
          ["Activity1", "Activity2"]),
      new Member(
          "https://picsum.photos/250?image=11",
          "Ram P.",
          "Junior",
          "5'11",
          140,
          ["Comp Sci", "Business"],
          ["goal1", "goal2", "goal1", "goal2", "goal1", "goal2"],
          ["Activity1", "Activity2"]),
      new Member(
          "https://picsum.photos/250?image=12",
          "Sai P.",
          "Junior",
          "5'11",
          140,
          ["Comp Sci", "Business"],
          ["goal1", "goal2", "goal1", "goal2", "goal1", "goal2"],
          ["Activity1", "Activity2"]),
      new Member(
          "https://picsum.photos/250?image=13",
          "Jai P.",
          "Junior",
          "5'11",
          140,
          ["Comp Sci", "Business"],
          ["goal1", "goal2", "goal1", "goal2", "goal1", "goal2"],
          ["Activity1", "Activity2"]),
      new Member(
          "https://picsum.photos/250?image=14",
          "Rai P.",
          "Junior",
          "5'11",
          140,
          ["Comp Sci", "Business"],
          ["goal1", "goal2", "goal1", "goal2", "goal1", "goal2"],
          ["Activity1", "Activity2"]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<List<Member>>(
              stream: _streamController.stream,
              initialData: users,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Member>> snapshot) {
                print('snapshot.data.length: ${snapshot.data.length}');
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Add image');
                  case ConnectionState.waiting:
                  //return Text('Awaiting images...');
                  case ConnectionState.active:
                    print("build active");
                    return _AsyncDataExample(context, snapshot.data);
                  case ConnectionState.done:
                    return Text('\$${snapshot.data} (closed)');
                }
                return null; // unreachable
              },
            ),
          ],
        ),
        SlidingUpPanel(
          minHeight: MediaQuery.of(context).size.height * 1 / 10,
          maxHeight: MediaQuery.of(context).size.height * 3 / 4,
          color: Colors.grey[100],
          panel: Center(
          ),
          header: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.grey[100], borderRadius: radius),
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Container(
                        height: 3,
                        width: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        users[0].name,
                        style: GoogleFonts.montserrat(
                            color: Colors.black54,
                            fontSize:
                            MediaQuery.of(context).size.width / 20),
                      ),
                      RatingBarIndicator(
                        rating: 2.75,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 25.0,
                        unratedColor: Colors.black12,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        users[0].year +
                            ", " +
                            users[0].height +
                            ", " +
                            users[0].weight.toString() +
                            " lbs",
                        style: GoogleFonts.montserrat(
                            color: Colors.black38,
                            fontSize:
                            MediaQuery.of(context).size.width / 25),
                      ),
                    ],
                  ),
                  Divider(height: 30, thickness: 1,),
                  Text(
                    users[0].getMajors(),
                    style: GoogleFonts.montserrat(
                        color: Colors.black38,
                        fontSize:
                        MediaQuery.of(context).size.width / 25),
                  ),
                  Divider(height: 30, thickness: 1,),
                  Text("Workout",
                    style: GoogleFonts.montserrat(
                        color: Colors.black38,
                        fontSize:
                        MediaQuery.of(context).size.width / 25),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                          width: MediaQuery.of(context).size.width*.75,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _getSlider(0, 100, 70, Colors.orangeAccent[400], Color(0x8AFFD180)),
                              _getSlider(0, 100, 20, Colors.red[700], Color(0x8AFFCDD2)),
                              SizedBox(height: 5,),
                              Text(" Experience",
                                style: GoogleFonts.montserrat(
                                    color: Colors.black38,
                                    fontSize:
                                    MediaQuery.of(context).size.width / 30),
                              ),
                              SizedBox(height: 30,),
                              _getSlider(0, 100, 50, Colors.orangeAccent[400], Color(0x8AFFD180)),
                              _getSlider(0, 100, 10, Colors.red[700], Color(0x8AFFCDD2)),
                              SizedBox(height: 5,),
                              Text(" Intensity",
                                style: GoogleFonts.montserrat(
                                    color: Colors.black38,
                                    fontSize:
                                    MediaQuery.of(context).size.width / 30),
                              ),
                              SizedBox(height: 30,),
                              _getSlider(0, 100, 80, Colors.orangeAccent[400], Color(0x8AFFD180)),
                              _getSlider(0, 100, 50, Colors.red[700], Color(0x8AFFCDD2)),
                              SizedBox(height: 5,),
                              Text(" Frequency",
                                style: GoogleFonts.montserrat(
                                    color: Colors.black38,
                                    fontSize:
                                    MediaQuery.of(context).size.width / 30),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                  Divider(height: 40, thickness: 1,),
                  Text("Goals",
                    style: GoogleFonts.montserrat(
                        color: Colors.black38,
                        fontSize:
                        MediaQuery.of(context).size.width / 25),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: MediaQuery.of(context).size.height/30,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: users[0].goals.length,
                        itemBuilder: (BuildContext context, int index){
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 3, 10, 5),
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text(users[0].goals[index],
                                style: GoogleFonts.montserrat(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                    MediaQuery.of(context).size.width / 25),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                  Divider(height: 40, thickness: 1,),
                  Text("Activities",
                    style: GoogleFonts.montserrat(
                        color: Colors.black38,
                        fontSize:
                        MediaQuery.of(context).size.width / 25),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: MediaQuery.of(context).size.height/30,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: users[0].activities.length,
                        itemBuilder: (BuildContext context, int index){
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 3, 10, 5),
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text(users[0].activities[index],
                                style: GoogleFonts.montserrat(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                    MediaQuery.of(context).size.width / 25),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ],
              ),
            ),
          ),
          borderRadius: radius,
        ),
      ],
    );
  }

  Widget _AsyncDataExample(BuildContext context, List<Member> imageList) {
    CardController controller; //Use this to trigger swap.
    return Container(
      height: MediaQuery.of(context).size.height*.75,
      child: GestureDetector(
        onTap: (){},
        onVerticalDragEnd: (details){
          if (details.primaryVelocity < 0) {
            print("up");
          } else if(details.primaryVelocity > 0){
            print("down");
          }
        },
        child: TinderSwapCard(
          totalNum: imageList.length,
          stackNum: 3,
          swipeEdge: .1,
          swipeDown: false,
          swipeUp: false,
          maxWidth: MediaQuery.of(context).size.width*.98,
          maxHeight: MediaQuery.of(context).size.height,
          minWidth: MediaQuery.of(context).size.width * 0.97,
          minHeight: MediaQuery.of(context).size.height * 0.99,
          cardBuilder: (context, index) {
            return Card(
              color: Colors.grey[100],
              child: Image.network('${imageList[index].imageMain}',
              fit: BoxFit.contain,
              ),
            );
          },
          cardController: controller = CardController(),
          swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
            /// Get swiping card's alignment
            if (align.x < 0) {
              //Card is LEFT swiping
            } else if (align.x > 0) {
              //Card is RIGHT swiping
            }
          },
          swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
            _addToStream();
            /// Get orientation & index of swiped card!
          },
        ),
      ),
    );
  }

  void _addToStream() {
    Random random = new Random();
    int index = random.nextInt(3);
    print("index $index");
    //users.add(new Member.other('https://picsum.photos/250?image=$index',"hk","hj","jk",6));
    users.removeAt(0);
    setState(() {});
    _streamController.add(users);
  }

  SliderTheme _getSlider(double min, double max, double val, Color active, Color inActive){
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: active,
        inactiveTrackColor: inActive,
        trackShape: RectangularSliderTrackShape(),
        trackHeight: 10.0,
        thumbColor: Colors.redAccent,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 6.0),
      ),
      child: Slider(
        value: val,
        max: max,
        min: min,
        onChanged: (value) {
        },
      ),
    );
  }
}
