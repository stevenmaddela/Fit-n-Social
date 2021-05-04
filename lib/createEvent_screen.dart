import 'dart:io';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as base;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fitnsocial/models/event_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:time_range/time_range.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;


class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {

  base.DatabaseReference rootRef = base.FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;
  String title, timeFrom, timeTo, location, description;
  List<EventAtendee> atendees = [];
  String date = "--/--/----";
  var headerImage;

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
            Stack(
              children: [
                headerImage==null? InkWell(onTap: (){getImage1(context);},child: Container(child:  Center(child: Text("Add Image",style: GoogleFonts.montserrat(color: Colors.pink,fontWeight: FontWeight.w500,fontSize:MediaQuery.of(context).size.width / 10),)),color: Colors.black54,width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height/4,)) : Image(image: NetworkImage(headerImage), width: MediaQuery.of(context).size.width, fit: BoxFit.fill, height: MediaQuery.of(context).size.height/4,),
                InkWell(
                  onTap: (){getImage1(context);},
                  child: Positioned(
                    child: Icon(Icons.add_circle, color: Colors.pinkAccent,size: 60,),
                    bottom: 7,
                    right: 7,
                  ),
                ),
              ],
            ),
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
                      String check = checkEmptyFields();
                      if(check == "Full") {
                        uploadData();
                      }
                      else{
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text(
                                    check),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            });
                      }
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
  Future<String> getImage1(context) async {
    var imag = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(imag== null){

    }
    else {
      ProgressDialog pr = ProgressDialog(
          context, type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false);
      await pr.show();
      await pr.show();
      String fileName = path.basename(imag.path);
      StorageReference ref = FirebaseStorage.instance.ref().child(
          "Event Images").child(FirebaseAuth.instance.currentUser.uid).child("headerImage").child(
          fileName);
      StorageUploadTask uploadTask = ref.putFile(imag);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      var downUrl = await taskSnapshot.ref.getDownloadURL();
      var url = downUrl.toString();
      setState(() {
        headerImage = url;
      });
      await pr.hide();

      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(
                  'Image Uploaded'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      setState(() {

      });
    }
  }
  Future<void> uploadData() async {
    String push = "";
    String name = "";
    String image = "";
    await rootRef.child("Users").child(auth.currentUser.uid).once().then((value1){
      name = value1.value['name'];
      image = value1.value['image'];
    });
    await rootRef.child("Users").child(auth.currentUser.uid).child("Profile").once().then((value)  async {
      push =  rootRef.child(value.value['college']).child("Events").push().key;
      rootRef.child(value.value['college']).child("Events").child(push).set({
        'college': value.value['college'],
        'hash': push,
        'title':title,
        'date':date,
        'timeFrom':timeFrom,
        'timeTo':timeTo,
        'location':location,
        'image':headerImage,
        'description':description,
      });
        await rootRef.child(value.value['college']).child("Events").child(push).child("Atendees").child(auth.currentUser.uid).set({
          'name': name,
          'image': image,
        });
    });
    Navigator.pop(context);
  }

  String checkEmptyFields() {
    // if title, timeFrom, timeTo, location, image, description;
    // var headerImage;
    if (title == null)
      return "Title is Empty";
    else if (timeFrom == null)
      return "Select Starting Time";
    else if (timeTo == null)
      return "Select Ending Time";
    else if (location == null)
      return "Location is Empty";
    else if (description == null)
      return "Description is Empty";
    else if (headerImage == null)
      return "Header Image is Empty";
    else return "Full";
  }
}
