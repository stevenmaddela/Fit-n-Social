import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as base;
import 'package:flutter/material.dart';
import 'package:flutter_app_fitnsocial/models/event_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_range/time_range.dart';
import 'package:intl/intl.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {

  base.DatabaseReference rootRef = base.FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;
  String title, timeFrom, timeTo, location, image, description;
  List<EventAtendee> atendees = [];
  String date = "--/--/----";

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
            .accentColor,
        titleSpacing: 0,
        title: Text("Create An Event",
          style: GoogleFonts.montserrat(
            color: Colors.black38,
            fontSize:
            MediaQuery.of(context).size.width / 25,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg", width: MediaQuery.of(context).size.width, fit: BoxFit.fill, height: MediaQuery.of(context).size.height/4,),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.fromLTRB(25,0,25,0),
              child: Row(
                children: [
                  Text("Event",
                    style: GoogleFonts.montserrat(
                        color: Colors.pink,
                        fontWeight: FontWeight.w500,
                        fontSize:
                        MediaQuery.of(context).size.width / 25),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: TextFormField(
                        maxLines: null,
                        decoration: new InputDecoration(
                          fillColor: Colors.white,
                          hintText: "Title:",
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          //fillColor: Colors.green
                        ),
                        onChanged:(textValue){
                          setState(() {
                            title = textValue;
                          });
                        },
                        validator: (val) {
                          if (val.length == 0) {
                            return "Email cannot be empty";
                          } else {
                            return null;
                          }
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25,0,25,0),
              child: Row(
                children: [
                  Text("Date(s)",
                    style: GoogleFonts.montserrat(
                        color: Colors.pink,
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
                        date = new DateFormat('E, MMM d').format(d);
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25,0,25,0),
              child: Text("Time",
                style: GoogleFonts.montserrat(
                    color: Colors.pink,
                    fontWeight: FontWeight.w500,
                    fontSize:
                    MediaQuery.of(context).size.width / 25),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,0,20,0),
              child: Row(
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
                        setState(() {
                          timeFrom = range.start.format(context);
                          timeTo = range.end.format(context);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Divider(height: 50,thickness: 1,),
            Padding(
              padding: const EdgeInsets.fromLTRB(25,0,25,0),
              child: Text("Event Location",
                style: GoogleFonts.montserrat(
                    color: Colors.pink,
                    fontWeight: FontWeight.w500,
                    fontSize:
                    MediaQuery.of(context).size.width / 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35,10,25,10),
              child: TextFormField(
                  maxLines: null,
                  decoration: new InputDecoration(
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    //fillColor: Colors.green
                  ),
                  onChanged:(textValue){
                    setState(() {
                      location = textValue;
                    });
                  },
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left:20.0,top: 15),
              child: Text("About",
                style: GoogleFonts.montserrat(
                    color: Colors.pink,
                    fontWeight: FontWeight.w500,
                    fontSize:
                    MediaQuery.of(context).size.width / 25),
              ),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.fromLTRB(35,10,30,0),
              child: TextFormField(
                  maxLines: null,
                  decoration: new InputDecoration(
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    //fillColor: Colors.green
                  ),
                  onChanged:(textValue){
                    setState(() {
                      description = textValue;
                    });
                  },
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,20,30,30),
              child: Row(
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
                      uploadData();

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void uploadData() {
    String push = "";
    rootRef.child("Users").child(auth.currentUser.uid).child("Profile").once().then((value)  {
      push =  rootRef.child(value.value['college']).child("Events").push().key;
      rootRef.child(value.value['college']).child("Events").child(push).set({
        'title':title,
        'date':date,
        'timeFrom':timeFrom,
        'timeTo':timeTo,
        'location':location,
        'image':'lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg',
        'description':description,
      });
      for(int i = 0; i < 5; i++){
        rootRef.child(value.value['college']).child("Events").child(push).child("Atendees").push().set({
        });
      }
    });
    Navigator.pop(context);
  }
}
