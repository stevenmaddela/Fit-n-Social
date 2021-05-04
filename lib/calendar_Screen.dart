import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as base;
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fitnsocial/createEvent_screen.dart';
import 'package:flutter_app_fitnsocial/event_screen.dart';
import 'package:flutter_app_fitnsocial/models/event_model.dart';
import 'package:google_fonts/google_fonts.dart';
class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  base.DatabaseReference rootRef = base.FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool done = false;
  bool reverse = false;
List<Event> events = [
  ];


@override
  void initState() {
  super.initState();
  getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingSearchBar.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventScreen(events[index].college, events[index].hash, events[index].title, events[index].date, events[index].timeFrom+" - "+events[index].timeTo, events[index].location, events[index].description, events[index].image, events[index].atendees))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20,10,20,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.75,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1,),
                              Text(events[index].title,
                                style: GoogleFonts.montserrat(
                                  color: Colors.black54,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 22.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(events[index].date + ", " + events[index].timeFrom+"-"+events[index].timeTo,
                                style: GoogleFonts.montserrat(
                                  color: Colors.black38,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 25,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(events[index].location,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black38,
                                    fontSize:
                                    MediaQuery.of(context).size.width / 25),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 1,),
                            ],
                          ),
                        ),
                        Image.network(
                          events[index].image,
                            width:125,
                            fit: BoxFit.fill,
                            height:100,
                          loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }else {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text(events[index].description,
                    style: GoogleFonts.montserrat(
                        color: Colors.black38,
                        fontSize:
                        MediaQuery.of(context).size.width / 27.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10,),
              (done && events[index].atendees.length>0) ?

                  Container(
                    height: 80,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events[index].atendees.length,
                        itemBuilder: (BuildContext context, int index2){
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(image:NetworkImage(events[index].atendees[index2].image), height: 50, width: 50,),
                                Text(events[index].atendees[index2].name,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black38,
                                      fontSize:
                                      MediaQuery.of(context).size.width / 25),
                                ),
                              ],
                            ),
                          );
                        }
                    ),
                  )
                      : Text("No atendees yet! Be the first",
                    style: GoogleFonts.montserrat(
                        color: Colors.pinkAccent,
                        fontSize:
                        MediaQuery.of(context).size.width / 22.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Divider(thickness: 1,),
                ],
              ),
            ),
          );
        },
        trailing: IconButton(
          icon: Icon(Icons.sort),
          color: Colors.black,
          onPressed: (){
            setState(() {
              reverse = !reverse;
            });
            if(reverse){
              events.sort((a, b) {
                return a.compareTo(b);
              });
            }
            else {
                events.sort((b, a) {
                  return a.compareTo(b);
                });
              }
            setState(() {

            });
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.post_add_rounded),
          color: Colors.black,
          onPressed: (){
            Navigator.push(context, new MaterialPageRoute(builder: (context) => CreateEvent()));
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        onChanged: (String value) {
          filterEvents(value);
        },
        onTap: () {},
        decoration: InputDecoration.collapsed(
          hintText: "🔎 Search...",
        ),
      ),
    );
  }

  void filterEvents(String value) {
    var temp = events.where((contact) {
      return contact.title.startsWith(value);
    }).toList();
    var temp1 = events.where((contact) {
      return !contact.title.startsWith(value);
    }).toList();
    setState(() {
      events = temp + temp1;
    });
  }

  void getData() async{
    rootRef.child("Users").child(auth.currentUser.uid).child("Profile").once().then((value)  {
      rootRef.child(value.value['college']).child("Events").onValue.listen((value1) {
        events.clear();
        var keys = value1.snapshot.value.keys;
        var data = value1.snapshot.value;
        for(var key in keys){
          List<EventAtendee> l = [];
          rootRef.child(value.value['college']).child("Events").child(key.toString()).child("Atendees").onValue.listen((value2)  {
            l.clear();
            var keys2 = value2.snapshot.value.keys;
            var data2 = value2.snapshot.value;
            for(var key1 in keys2){
              l.add(new EventAtendee(data2[key1]['image'], data2[key1]['name'], key1));
              setState(() {

              });
            }
          });
          if(data[key]['approved']!=false)
            events.add(new Event(data[key]['college'], data[key]['hash'], data[key]['title'], data[key]['date'], data[key]['timeFrom'], data[key]['timeTo'], data[key]['location'], data[key]['image'], data[key]['description'], l));
        }
        setState(() {
          done = true;
        });
      });
    });
  }
}
