import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fitnsocial/models/event_model.dart';
import 'package:google_fonts/google_fonts.dart';

class EventScreen extends StatefulWidget {
  final String college;
  final String hash;
  final String title;
  final String date;
  final String fromToTime;
  final String location;
  final String description;
  final String image;
  final List<EventAtendee> atendees;

  EventScreen( this.college, this.hash, this.title, this.date, this.fromToTime, this.location,
      this.description, this.image, this.atendees);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool going = false;
  DatabaseReference rootRef = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;
  String name, image;
  List<EventAtendee> atendees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme
        .of(context)
        .accentColor,
    appBar: AppBar(
    iconTheme: IconThemeData(
    color: Colors.black, //change your color here
    ),
    backgroundColor: Theme
        .of(context)
        .accentColor,),
      body: Padding(
        padding: const EdgeInsets.only(left:15.0, right: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(image: NetworkImage(widget.image), width: MediaQuery.of(context).size.width, fit: BoxFit.fill, height: MediaQuery.of(context).size.height / 3),

              SizedBox(
                height: 20,
              ),
              Text(
                widget.date + ", " + widget.fromToTime,
                style: GoogleFonts.montserrat(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width/30),
              ),
              Text(
                widget.location,
                style: GoogleFonts.montserrat(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width/30),
              ),
              SizedBox(height: 10,),
              Text(
                widget.title,
                style: GoogleFonts.montserrat(
                    color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2.5,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black54),color: Colors.white24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.share, color: Colors.black,),
                          onPressed: (){},
                        ),
                        Text(
                          "Share",
                          style: GoogleFonts.montserrat(
                              color: Colors.black54,
                              fontSize: MediaQuery.of(context).size.width / 25),
                        ),
                        SizedBox(width: 10,),

                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        going = !going;
                        rsvp();
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width/2.5,
                      color: going ? Colors.pink : Colors.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: going ? Icon(Icons.check_circle_outline, color: Colors.white,) : Icon(Icons.person_add, color: Colors.white,),
                            onPressed: (){
                              setState(() {
                                going = !going;
                                rsvp();
                              });
                            },
                          ),
                          Text(
                            going? "Going" : "RSVP",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width / 25),
                          ),
                          SizedBox(width: 10,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: atendees.length,
                    itemBuilder: (BuildContext context, int index2){
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(image:NetworkImage(
                                atendees[index2].image),
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill,
                            ),
                            Text(atendees[index2].name,
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
              ),
              Padding(padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(widget.description,
                  style: GoogleFonts.montserrat(
                      color: Colors.black38,
                      fontSize:
                      MediaQuery.of(context).size.width / 25),
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void rsvp() {
    if(going){
      rootRef.child(widget.college).child("Events").child(widget.hash).child("Atendees").child(auth.currentUser.uid).set({'name':name, 'image':image});
    }
    else
      rootRef.child(widget.college).child("Events").child(widget.hash).child("Atendees").child(auth.currentUser.uid).remove();
  }

  Future<void> getData() async {
    await rootRef.child("Users").child(auth.currentUser.uid).child("Profile").once().then((value)   {
          rootRef.child(value.value['college']).child("Events").child(widget.hash).child("Atendees").onValue.listen((value2)  {
            setState(() {
              atendees.clear();
            });
            var keys2 = value2.snapshot.value.keys;
            var data2 = value2.snapshot.value;
            for(var key1 in keys2){
                if(key1.toString()==auth.currentUser.uid) {
                  setState(() {
                    going = true;
                  });
                }
                setState(() {
                  atendees.add(new EventAtendee(data2[key1]['image'], data2[key1]['name'], key1));
                });
            }
          });
        });
    await rootRef.child("Users").child(auth.currentUser.uid).once().then((value) {
      setState(() {
        name = value.value['name'];
        image = value.value['image'];
      });
    });
  }
}
