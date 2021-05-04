import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flip_panel/flip_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

import 'chat_screen.dart';
import 'models/boxSelection_model.dart';
import 'models/member_model.dart';

class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  List<Member> users;
  Member me;
  StreamController<List<Member>> _streamController;
  int index, startingLength, swipeCt = 0;
  ScrollController _controller = ScrollController();
  final int _numPages = 3;
  int _currentPage = 0;
  DatabaseReference rootRef = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<Member>>();
    index = 0;
    users = [];
    startingLength = users.length;
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    print(users.length);
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return loading
        ? Container(
            child: Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ))
        : users.length >= 20
            ? Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      StreamBuilder<List<Member>>(
                        stream: _streamController.stream,
                        initialData: users,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Member>> snapshot) {
                          print(
                              'snapshot.data.length: ${snapshot.data.length}');
                          print("index " + index.toString());
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
                    backdropEnabled: true,
                    panelSnapping: true,
                    defaultPanelState: PanelState.CLOSED,
                    panelBuilder: (s) => ListView.separated(
                      controller: _controller = s,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return _panel(_controller);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ),
                  ),
                ],
              )
            : swipeCt >= 10
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.25,
                        child: Text(
                          "You've reached your swipe limit",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: Colors.pink,
                              fontSize: MediaQuery.of(context).size.width / 10),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Come back for more in",
                        style: GoogleFonts.montserrat(
                            color: Colors.black38,
                            fontSize: MediaQuery.of(context).size.width / 30),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          height: 64.0,
                          child: FlipClock.countdown(
                            duration: Duration(minutes: 1440),
                            digitColor: Colors.white,
                            backgroundColor: Colors.black,
                            digitSize: 48.0,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3.0)),
                            onDone: () => print('ih'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: Divider(
                            thickness: 1,
                          )),
                          SizedBox(
                            width: 15,
                          ),
                          Text("or"),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 1,
                          )),
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.25,
                        child: Text(
                          "Watch a video \nfor more swipes",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: Colors.pink,
                              fontSize: MediaQuery.of(context).size.width / 15),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.pink,
                          child: Text(
                            "Watch Video",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 25),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Text(
                          "You can also purchase a 2-day \nunlimited swipe pass for just \$4.99",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: Colors.black38,
                              fontSize: MediaQuery.of(context).size.width / 35),
                        ),
                      ),
                      Text(
                        "Learn More",
                        style: GoogleFonts.montserrat(
                            color: Colors.blue[800],
                            decoration: TextDecoration.underline,
                            fontSize: MediaQuery.of(context).size.width / 35),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : users.length > 0 && users.length < 20
                    ? Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.25,
                          child: Text(
                            "Not enough users check back soon",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                color: Colors.pink,
                                fontSize:
                                    MediaQuery.of(context).size.width / 10),
                          ),
                        ),
                      )
                    : Container();
  }

  Widget _AsyncDataExample(BuildContext context, List<Member> imageList) {
    CardController controller; //Use this to trigger swap.
    return Container(
      height: MediaQuery.of(context).size.height * .75,
      child: GestureDetector(
        onTap: () {},
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity < 0) {
            if (_currentPage != 2) {
              setState(() {
                _currentPage++;
              });
            }
          } else if (details.primaryVelocity > 0) {
            if (_currentPage != 0) {
              setState(() {
                _currentPage--;
              });
            }
          }
        },
        child: TinderSwapCard(
          totalNum: imageList.length,
          stackNum: 3,
          swipeEdge: .1,
          swipeDown: false,
          swipeUp: false,
          maxWidth: MediaQuery.of(context).size.width * .98,
          maxHeight: MediaQuery.of(context).size.height,
          minWidth: MediaQuery.of(context).size.width * 0.97,
          minHeight: MediaQuery.of(context).size.height * 0.99,
          cardBuilder: (context, index) {
            return Card(
              color: Colors.grey[100],
              child: Stack(
                children: [
                  Center(
                    child: Image.network(
                      imageList[index].imageMain[_currentPage],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                ],
              ),
            );
          },
          cardController: controller = CardController(),
          swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
            /// Get swiping card's alignment
            if (align.x < 0) {
              ///NO MATCH
              //Card is LEFT swiping
            } else if (align.x > 0) {
              ///MATCH
              //Card is RIGHT swiping
            }
          },
          swipeCompleteCallback:
              (CardSwipeOrientation orientation, int index1) async {
            await handleSwipeCompleted(orientation, index1, imageList);
          },
        ),
      ),
    );
  }

  handleSwipeCompleted(CardSwipeOrientation orientation, int index,
      List<Member> imageList) async {
    switch (orientation) {
      case CardSwipeOrientation.LEFT:
        await left(imageList);
        _addToStream();
        swipeCt++;
        break;
      case CardSwipeOrientation.RIGHT:
        await right(imageList);
        _addToStream();
        swipeCt++;
        break;
      case CardSwipeOrientation.RECOVER:
        break;
      default:
        break;
    }
  }

  void _addToStream() {
    _currentPage = 0;
    setState(() {});
    _streamController.add(users);
  }

  SliderTheme _getSlider(
      double min, double max, double val, Color active, Color inActive) {
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
        onChanged: (value) {},
      ),
    );
  }

  Widget _panel(ScrollController controller) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
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
                      fontSize: MediaQuery.of(context).size.width / 20),
                ),
                Stack(
                  children: [
                    RatingBarIndicator(
                      rating: getComparisonRating(users[0]),
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 25.0,
                      unratedColor: Colors.black54,
                      direction: Axis.horizontal,
                    ),
                  ],
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
                      users[0].weight +
                      " lbs",
                  style: GoogleFonts.montserrat(
                      color: Colors.black38,
                      fontSize: MediaQuery.of(context).size.width / 25),
                ),
              ],
            ),
            Divider(
              height: 30,
              thickness: 1,
            ),
            Text(
              users[0].getMajors(),
              style: GoogleFonts.montserrat(
                  color: Colors.black38,
                  fontSize: MediaQuery.of(context).size.width / 25),
            ),
            Divider(
              height: 30,
              thickness: 1,
            ),
            Text(
              "Workout",
              style: GoogleFonts.montserrat(
                  color: Colors.black38,
                  fontSize: MediaQuery.of(context).size.width / 25),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                    width: MediaQuery.of(context).size.width * .75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getSlider(0, 100, users[0].experience,
                            Colors.orangeAccent[400], Color(0x8AFFD180)),
                        _getSlider(0, 100, users[0].experience, Colors.red[700],
                            Color(0x8AFFCDD2)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          " Experience",
                          style: GoogleFonts.montserrat(
                              color: Colors.black38,
                              fontSize: MediaQuery.of(context).size.width / 30),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _getSlider(0, 100, users[0].intensity,
                            Colors.orangeAccent[400], Color(0x8AFFD180)),
                        _getSlider(0, 100, users[0].intensity, Colors.red[700],
                            Color(0x8AFFCDD2)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          " Intensity",
                          style: GoogleFonts.montserrat(
                              color: Colors.black38,
                              fontSize: MediaQuery.of(context).size.width / 30),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _getSlider(0, 100, users[0].frequency,
                            Colors.orangeAccent[400], Color(0x8AFFD180)),
                        _getSlider(0, 100, users[0].frequency, Colors.red[700],
                            Color(0x8AFFCDD2)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          " Frequency",
                          style: GoogleFonts.montserrat(
                              color: Colors.black38,
                              fontSize: MediaQuery.of(context).size.width / 30),
                        ),
                      ],
                    )),
              ),
            ),
            Divider(
              height: 40,
              thickness: 1,
            ),
            Text(
              "Goals",
              style: GoogleFonts.montserrat(
                  color: Colors.black38,
                  fontSize: MediaQuery.of(context).size.width / 25),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 30,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users[0].goals.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 3, 10, 5),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          users[0].goals[index],
                          style: GoogleFonts.montserrat(
                              color: Colors.red[700],
                              fontWeight: FontWeight.w500,
                              fontSize: MediaQuery.of(context).size.width / 25),
                        ),
                      ),
                    );
                  }),
            ),
            Divider(
              height: 40,
              thickness: 1,
            ),
            Text(
              "Activities",
              style: GoogleFonts.montserrat(
                  color: Colors.black38,
                  fontSize: MediaQuery.of(context).size.width / 25),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 30,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users[0].activities.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 3, 10, 5),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          users[0].activities[index],
                          style: GoogleFonts.montserrat(
                              color: Colors.red[700],
                              fontWeight: FontWeight.w500,
                              fontSize: MediaQuery.of(context).size.width / 25),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      height: isActive ? 35 : 24.0,
      width: 15,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        color: isActive ? Colors.pink : Colors.white70,
      ),
    );
  }

  void getUsers() {
    rootRef
        .child("Users")
        .child(auth.currentUser.uid)
        .child("Profile")
        .once()
        .then((value) {
      var data = value.value;
      me = new Member.stats(
          getList(data['genders']),
          data['gender'],
          data['yearInSchool'],
          data['height'],
          data['weight'],
          data['slider1'],
          data['slider2'],
          data['slider3'],
          getList(data['academics']),
          getList(data['goals']),
          getList(data['activities']));
      rootRef
          .child(value.value['college'])
          .child("Users")
          .child(auth.currentUser.uid)
          .child("Matches")
          .once()
          .then((value1) async {
        if (value1.value != null) {
          var keys = value1.value.keys;
          var data = value1.value;
          for (var key in keys) {
            if (key != auth.currentUser.uid) {
              await rootRef
                  .child("Users")
                  .child(key)
                  .child("Profile")
                  .once()
                  .then((value2) async {
                var data1 = await value2.value;
                print(data1['gender'] +
                    " " +
                    getList(data1['genders']).toString());
                users.add(new Member.additional(
                  [
                    data[key]['image'],
                    data[key]['image2'],
                    data[key]['image3']
                  ],
                  data[key]['uid'],
                  data[key]['name'],
                  data[key]['yearInSchool'],
                  data[key]['height'],
                  data[key]['weight'],
                  data[key]['experience'],
                  data[key]['intensity'],
                  data[key]['frequency'],
                  getList(data[key]['academics']),
                  getList(data[key]['goals']),
                  getList(data[key]['activities']),
                  data1['gender'],
                  getList(data1['genders']),
                ));
              });
            }
          }
          setState(() {
            startingLength = users.length;
            loading = false;
          });
        } else {
          setState(() {
            startingLength = users.length;

            loading = false;
          });
        }
      });
    });
  }

  List<String> getList(value) {
    List<String> l = [];
    String v = value.toString();
    int index = 0;
    for (int i = 0; i < v.length; i++) {
      if (v.substring(i, i + 1) == (",")) {
        l.add(v.substring(index, i));
        index = i + 1;
      }
    }
    return l;
  }

  right(List<Member> imageList) async {
    await rootRef
        .child("Users")
        .child(auth.currentUser.uid)
        .child("Profile")
        .once()
        .then((value) async {
      await rootRef
          .child(value.value['college'])
          .child("Users")
          .child(auth.currentUser.uid)
          .child("Matches")
          .once()
          .then((value1) async {
        await rootRef
            .child(value.value['college'])
            .child("Users")
            .child(imageList[index].id)
            .child("Interested")
            .child(auth.currentUser.uid)
            .once()
            .then((value2) async {
          if (value2.value != null) {
            await rootRef.child("Users").once().then((value3) async {
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(auth.currentUser.uid)
                  .child("Matched")
                  .child(imageList[index].id)
                  .set(value3.value[imageList[index].id]);
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(auth.currentUser.uid)
                  .child("Matched")
                  .child(imageList[index].id)
                  .child("Diary")
                  .set(null);
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(auth.currentUser.uid)
                  .child("Matched")
                  .child(imageList[index].id)
                  .child("Messages")
                  .set(null);
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(auth.currentUser.uid)
                  .child("Friends")
                  .child(imageList[index].id)
                  .set(value3.value[imageList[index].id]);
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(auth.currentUser.uid)
                  .child("Friends")
                  .child(imageList[index].id)
                  .child("Diary")
                  .set(null);
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(auth.currentUser.uid)
                  .child("Friends")
                  .child(imageList[index].id)
                  .child("Messages")
                  .set(null);
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(imageList[index].id)
                  .child("Interested")
                  .child(auth.currentUser.uid)
                  .set(null);
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(imageList[index].id)
                  .child("Matched")
                  .child(auth.currentUser.uid)
                  .set(value3.value[auth.currentUser.uid]);
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(imageList[index].id)
                  .child("Matched")
                  .child(auth.currentUser.uid)
                  .child("Diary")
                  .set(null);
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(imageList[index].id)
                  .child("Matched")
                  .child(auth.currentUser.uid)
                  .child("Messages")
                  .set(null);
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(imageList[index].id)
                  .child("Friends")
                  .child(auth.currentUser.uid)
                  .set(value3.value[auth.currentUser.uid]);
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(imageList[index].id)
                  .child("Friends")
                  .child(auth.currentUser.uid)
                  .child("Diary")
                  .set(null);
              await rootRef
                  .child(value.value['college'])
                  .child("Users")
                  .child(imageList[index].id)
                  .child("Friends")
                  .child(auth.currentUser.uid)
                  .child("Messages")
                  .set(null);
              var now = new DateTime.now();
              var formatter = new DateFormat('MM/dd/yyyy');
              String month = formatter.format(now);
              await rootRef
                  .child("Users")
                  .child(auth.currentUser.uid)
                  .child("Messages")
                  .child(imageList[index].id)
                  .push()
                  .set({
                'sender': 'ADMIN',
                'time': DateFormat.jms().format(DateTime.now()),
                'date': month,
                'unread': true,
                'text': "It's a Match",
              });
              await rootRef
                  .child("Users")
                  .child(imageList[index].id)
                  .child("Messages")
                  .child(auth.currentUser.uid)
                  .push()
                  .set({
                'sender': 'ADMIN',
                'time': DateFormat.jms().format(DateTime.now()),
                'date': month,
                'unread': true,
                'text': "It's a Match",
              });
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                String name = imageList[index].name;
                String image = imageList[index].imageMain[0];
                String id = imageList[index].id;
                return AlertDialog(
                  title: Text("Matched!"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name + " also swiped right on your profile!",
                      ),
                      Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.message_outlined),
                            iconSize: 30,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    userId: id,
                                    name: name,
                                    lastHash: null,
                                  ),
                                ),
                              );
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    userId: id,
                                    name: name,
                                    lastHash: null,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Send a message",
                              style: GoogleFonts.montserrat(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
          } else {
            await rootRef
                .child(value.value['college'])
                .child("Users")
                .child(auth.currentUser.uid)
                .child("Interested")
                .child(imageList[index].id)
                .set(value1.value[imageList[index].id]);

            await rootRef
                .child(value.value['college'])
                .child("Users")
                .child(auth.currentUser.uid)
                .child("Interested")
                .child(imageList[index].id)
                .child("Matched")
                .set(false);
          }
        });
        await rootRef
            .child(value.value['college'])
            .child("Users")
            .child(auth.currentUser.uid)
            .child("Matches")
            .child(imageList[index].id)
            .set(null);
      });
    });
    imageList.removeAt(0);
    index++;
  }

  left(List<Member> imageList) {
    imageList.removeAt(0);
    index++;
  }

  double getComparisonRating(Member member) {
    double sum = 0;
    if (member.majors[0] == me.majors[0]) sum += 4;
    if (member.year == me.yearInSchool) sum += 4;
    if ((((getInchesHeight(member.height) - getInchesHeight(me.height)).abs()) /
            getInchesHeight(member.height)) <=
        .05)
      sum += 4;
    else if ((((getInchesHeight(member.height) - getInchesHeight(me.height))
                .abs()) /
            getInchesHeight(member.height)) <=
        .1)
      sum += 3;
    else if ((((getInchesHeight(member.height) - getInchesHeight(me.height))
                .abs()) /
            getInchesHeight(member.height)) <=
        .15) sum += 2;
    if ((((double.parse(member.weight) - double.parse(me.weight)).abs()) /
            double.parse(member.weight)) <=
        .05)
      sum += 4;
    else if ((((double.parse(member.weight) - double.parse(me.weight)).abs()) /
            double.parse(member.weight)) <=
        .12)
      sum += 3;
    else if ((((double.parse(member.weight) - double.parse(me.weight)).abs()) /
            double.parse(member.weight)) <=
        .2) sum += 2;
    if (((member.experience / 33.33335 + 1).toInt()) ==
        ((me.experience / 33.33335 + 1).toInt()))
      sum += 9;
    else if ((((member.experience / 33.33335 + 1).toInt()) -
                ((me.experience / 33.33335 + 1).toInt()))
            .abs() ==
        1) sum += 4.5;
    if (((member.intensity / 33.33335 + 1).toInt()) ==
        ((me.intensity / 33.33335 + 1).toInt()))
      sum += 13;
    else if ((((member.intensity / 33.33335 + 1).toInt()) -
                ((me.intensity / 33.33335 + 1).toInt()))
            .abs() ==
        1) sum += 6.5;
    if (((member.frequency / 33.33335 + 1).toInt()) ==
        ((me.frequency / 33.33335 + 1).toInt()))
      sum += 9;
    else if ((((member.frequency / 33.33335 + 1).toInt()) -
                ((me.frequency / 33.33335 + 1).toInt()))
            .abs() ==
        1) sum += 4.5;
    if (me.idealGenders.contains(member.gender)) sum += 13;
    List<String> membersGoals = member.goals;
    List<String> myGoals = me.goals;
    int ct = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (membersGoals[i] == myGoals[j]) ct++;
      }
    }
    if (ct == 3)
      sum += 13;
    else if (ct == 2)
      sum += 10.4;
    else if (ct == 1) sum += 6.5;
    List<String> membersActivities = member.activities;
    List<String> myActivities = me.activities;
    int ct1 = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (membersActivities[i] == myActivities[j]) ct1++;
      }
    }
    if (ct1 == 3)
      sum += 13;
    else if (ct1 == 2)
      sum += 10.4;
    else if (ct1 == 1) sum += 6.5;

    ///BODY TYPE?,
    double rating = ((sum / 86) * 100) / 20;
    print(rating);
    return (rating);
  }

  double getInchesHeight(String height) {
    if (height.indexOf("\'") == -1)
      return double.parse(height) * 12;
    else {
      double ft = double.parse(height.substring(0, height.indexOf('\''))) * 12;
      double inc =
          ft + double.parse(height.substring(height.indexOf('\'') + 1));
      return inc;
    }
  }
}
