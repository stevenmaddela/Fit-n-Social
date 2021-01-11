import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fitnsocial/main.dart';
import 'package:flutter_app_fitnsocial/models/boxSelection_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name, email, yearInSchool, height, weight, gender, aboutMe,
      whatImLookingFor, college;
  bool lgbtq, idealMatchLgbtq;
  final rootRef = FirebaseDatabase.instance.reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var image = "https://firebasestorage.googleapis.com/v0/b/feedyyy-bfff8.appspot.com/o/Profile%20Images%2Fprofile_00000_00000.png?alt=media&token=aee78404-64a0-4bb6-a5f2-39b4f9da9d92";

  var image1;
  var image2;
  var image3;
  int donations = 0;
  bool tapped = false;
  final formKey = GlobalKey<FormState>();
  var focus = FocusNode();
  var con = TextEditingController();
  List<BoxSelection> academics = [];
  List<BoxSelection> goals = [];
  List<BoxSelection> activities = [];
  List<BoxSelection> badges = [];
  List<BoxSelection> genders = [];
  List<DropdownMenuItem> colleges = [];

  double slider1;
  double slider2;
  double slider3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                backgroundColor: Theme
                    .of(context)
                    .accentColor,
                appBar: AppBar(
                  title: Text(
                    "Profile",
                    style: GoogleFonts.alata(),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: (){
                              getImage1(context);
                            },
                            child:  Stack(
                              children: [
                                Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width/3.1,
                                  child: image1 != null ? Image(image: NetworkImage(image1), fit: BoxFit.contain,) : Image(image: NetworkImage(image), fit: BoxFit.contain,),
                                ),
                                Positioned(
                                  child: Icon(Icons.add_circle, color: Colors.pinkAccent,size: 25,),
                                  bottom: 15,
                                  right: 15,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              getImage2(context);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width/3.1,
                                  child: image2 != null ? Image(image: NetworkImage(image2), fit: BoxFit.contain,) : Image(image: NetworkImage(image), fit: BoxFit.contain,),
                                ),
                                Positioned(
                                  child: Icon(Icons.add_circle, color: Colors.pinkAccent,size: 25,),
                                  bottom: 15,
                                  right: 15,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              getImage3(context);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width/3.1,
                                  child: image3 != null ? Image(image: NetworkImage(image3), fit: BoxFit.contain,) : Image(image: NetworkImage(image), fit: BoxFit.contain,),
                                ),
                                Positioned(
                                    child: Icon(Icons.add_circle, color: Colors.pinkAccent,size: 25,),
                                  bottom: 15,
                                  right: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: college == null ? SearchableDropdown.single(
                                items: colleges,
                                hint: "Select College",
                                value: college,
                                searchHint: "Search College",
                                onChanged: (value) {
                                  setState(() {
                                    college = value;
                                  });
                                },
                                isExpanded: true,
                              ) : Text(
                                college,
                                style: GoogleFonts.montserrat(
                                    color: Colors.pink,
                                    fontWeight: FontWeight.w500,
                                    fontSize: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 30),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Name",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 30),
                                ),
                                SizedBox(width: 25,),
                                Text(name,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 25),
                                ),
                              ],
                            ),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Email",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 30),
                                ),
                                SizedBox(width: 15,),
                                Text(email,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 27.5),
                                ),
                              ],
                            ),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Year In School",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 30),
                                ),
                                SizedBox(width: 15,),
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2,
                                  child: TextFormField(
                                      onChanged: (textValue) {
                                        setState(() {
                                          yearInSchool = textValue.trim();
                                        });
                                      },
                                      initialValue: yearInSchool,
                                      decoration: new InputDecoration(
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                        ),
                                        //fillColor: Colors.green
                                      ),
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
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Academics",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 30),
                                ),
                                SizedBox(width: 15,),
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: ListView.builder(
                                        itemCount: academics.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                academics[index].isSelected
                                                    ? academics[index].isSelected = false
                                                    : academics[index].isSelected = true;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  color: academics[index].isSelected
                                                      ? Colors.pink
                                                      : Colors.pink[100],
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(academics[index].title,
                                                    style: GoogleFonts.montserrat(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width / 30),
                                                  ),
                                                ),
                                                SizedBox(width: 15,)
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 40, thickness: 1,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text("Height",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.pink,
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width / 30),
                                    ),
                                    SizedBox(height: 10,),
                                    SizedBox(
                                      width: 75,
                                      child: TextFormField(
                                          onChanged: (textValue) {
                                            setState(() {
                                              height = textValue.trim();
                                            });
                                          },
                                          initialValue: height,
                                          decoration: new InputDecoration(
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                            ),
                                            //fillColor: Colors.green
                                          ),
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
                                SizedBox(width: 15,),
                                Column(
                                  children: [
                                    Text("Weight",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.pink,
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width / 30),
                                    ),
                                    SizedBox(height: 10,),
                                    SizedBox(
                                      width: 75,
                                      child: TextFormField(
                                          onChanged: (textValue) {
                                            setState(() {
                                              weight = textValue.trim();
                                            });
                                          },
                                          initialValue: weight,
                                          decoration: new InputDecoration(
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                            ),
                                            //fillColor: Colors.green
                                          ),
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
                                SizedBox(width: 15,),
                                Column(
                                  children: [
                                    Text("Gender",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.pink,
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width / 30),
                                    ),
                                    SizedBox(height: 10,),
                                    SizedBox(
                                      width: 75,
                                      child: TextFormField(
                                          onChanged: (textValue) {
                                            setState(() {
                                              gender = textValue.trim();
                                            });
                                          },
                                          initialValue: gender,
                                          decoration: new InputDecoration(
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                            ),
                                            //fillColor: Colors.green
                                          ),
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
                                SizedBox(width: 15,),
                                Column(
                                  children: [
                                    Text("LGBTQ+",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.pink,
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width / 30),
                                    ),
                                    SizedBox(height: 10,),
                                    SizedBox(
                                      width: 75,
                                      child: Checkbox(
                                        activeColor: Colors.black54,
                                        value: lgbtq,
                                        onChanged: (bool value) {
                                          setState(() {
                                            lgbtq = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 15,),
                              ],
                            ),
                            Divider(height: 40, thickness: 1,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 15,),
                                Text("Goals",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width / 30),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                  itemCount: goals.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          goals[index].isSelected ?
                                          goals[index].isSelected = false : goals[index]
                                              .isSelected = true;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(width: 15,),
                                          Container(
                                            color: goals[index].isSelected
                                                ? Colors.pink
                                                : Colors.pink[100],
                                            padding: EdgeInsets.all(8),
                                            child: Text(goals[index].title,
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 30),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 15,),
                                Text("Activities",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width / 30),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                  itemCount: activities.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          activities[index].isSelected
                                              ? activities[index].isSelected = false
                                              : activities[index].isSelected = true;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(width: 15,),
                                          Container(
                                            color: activities[index].isSelected ? Colors
                                                .pink : Colors.pink[100],
                                            padding: EdgeInsets.all(8),
                                            child: Text(activities[index].title,
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 30),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(height: 25,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text("Workout",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black38,
                                        fontSize:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width / 25),
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * .75,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: Colors.red[700],
                                          inactiveTrackColor: Color(0x8AFFCDD2),
                                          trackShape: RectangularSliderTrackShape(),
                                          trackHeight: 10.0,
                                          thumbColor: Colors.redAccent,
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 10),
                                          overlayShape: RoundSliderOverlayShape(
                                              overlayRadius: 6.0),
                                        ),
                                        child: Slider(
                                          value: slider1,
                                          max: 100,
                                          min: 0,
                                          onChanged: (value) {
                                            setState(() {
                                              slider1 = value;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(" Experience",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black38,
                                            fontSize:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width / 30),
                                      ),
                                      SizedBox(height: 30,),

                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: Colors.red[700],
                                          inactiveTrackColor: Color(0x8AFFCDD2),
                                          trackShape: RectangularSliderTrackShape(),
                                          trackHeight: 10.0,
                                          thumbColor: Colors.redAccent,
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 10),
                                          overlayShape: RoundSliderOverlayShape(
                                              overlayRadius: 6.0),
                                        ),
                                        child: Slider(
                                          value: slider2,
                                          max: 100,
                                          min: 0,
                                          onChanged: (value) {
                                            setState(() {
                                              slider2 = value;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(" Intensity",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black38,
                                            fontSize:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width / 30),
                                      ),
                                      SizedBox(height: 30,),

                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: Colors.red[700],
                                          inactiveTrackColor: Color(0x8AFFCDD2),
                                          trackShape: RectangularSliderTrackShape(),
                                          trackHeight: 10.0,
                                          thumbColor: Colors.redAccent,
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 10),
                                          overlayShape: RoundSliderOverlayShape(
                                              overlayRadius: 6.0),
                                        ),
                                        child: Slider(
                                          value: slider3,
                                          max: 100,
                                          min: 0,
                                          onChanged: (value) {
                                            setState(() {
                                              slider3 = value;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(" Frequency",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black38,
                                            fontSize:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width / 30),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),
                      Divider(height: 1, thickness: 1,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("About Me",
                              style: GoogleFonts.montserrat(
                                  color: Colors.black38,
                                  fontSize:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width / 25),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                            onChanged: (textValue) {
                              setState(() {
                                aboutMe = textValue.trim();
                              });
                            },
                            initialValue: aboutMe,

                            maxLines: null,
                            decoration: new InputDecoration(
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                              ),
                              //fillColor: Colors.green
                            ),
                            validator: (val) {
                              if (val.length == 0) {
                                return "Email cannot be empty";
                              } else {
                                return null;
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Earned Badges (Display up to 5)",
                              style: GoogleFonts.montserrat(
                                  color: Colors.black38,
                                  fontSize:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width / 25),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: badges.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                badges[index].isSelected
                                                    ? badges[index].isSelected = false
                                                    : badges[index].isSelected = true;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Opacity(
                                                  opacity: badges[index].isSelected
                                                      ? 1
                                                      : .3,
                                                  child: CircleAvatar(radius: 20,
                                                      backgroundImage: NetworkImage(
                                                          badges[index].title)
                                                  ),
                                                ),
                                                SizedBox(width: 15,),
                                              ],
                                            ),
                                          );
                                        }
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 40, thickness: 1,),
                            Text("Ideal Match",
                              style: GoogleFonts.montserrat(
                                  color: Colors.black38,
                                  fontSize:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width / 25),
                            ),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Gender",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.pink,
                                      fontSize:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width / 25),
                                ),
                                Text("Consider LGBTQ+",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.pink,
                                      fontSize:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width / 25),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: ListView.builder(
                                        itemCount: genders.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                genders[index].isSelected
                                                    ? genders[index].isSelected = false
                                                    : genders[index].isSelected = true;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  color: genders[index].isSelected
                                                      ? Colors.pink
                                                      : Colors.pink[100],
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(genders[index].title,
                                                    style: GoogleFonts.montserrat(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width / 30),
                                                  ),
                                                ),
                                                SizedBox(width: 15,)
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                Checkbox(
                                  activeColor: Colors.black54,
                                  value: idealMatchLgbtq,
                                  onChanged: (bool value) {
                                    setState(() {
                                      idealMatchLgbtq = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Divider(height: 1, thickness: 1,),

                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("What I'm looking for",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black38,
                                        fontSize:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width / 25),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: TextFormField(
                                  onChanged: (textValue) {
                                    setState(() {
                                      whatImLookingFor = textValue.trim();
                                    });
                                  },
                                  initialValue: whatImLookingFor,

                                  maxLines: null,
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Email cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  }),
                            ),
                            Divider(height: 20, thickness: 1,),
                            Padding(
                              padding: EdgeInsets.only(top: 30, right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    child: Container(
                                      color: Colors.pink,
                                      padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                                      child: Text("Save",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width / 30),
                                      ),
                                    ),
                                    onTap: () {
                                      uploadData();
                                      Navigator.pushAndRemoveUntil(
                                          context, MaterialPageRoute(
                                          builder: (_) => LoggedInScreen()), (
                                          Route<dynamic> rr) => false);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }

  @override
  void initState() {
    // FirebaseDatabase.instance.reference().child('Users').child(
    //     FirebaseAuth.instance.currentUser.uid).child("Profile").once().then((DataSnapshot data) {
    //   if(data.value!=null){
    //     Navigator.pushAndRemoveUntil(
    //         context, MaterialPageRoute(builder: (_) => LoggedInScreen()), (
    //         Route<dynamic> rr) => false);
    //   }
    // });
    getData();
    super.initState();
  }

  Future<void> uploadData() async {
    String academicsS = "";
    for (int i = 0; i < academics.length; i++) {
      if (academics[i].isSelected) {
        academicsS += academics[i].title + ",";
      }
    }
    String goalsS = "";
    for (int i = 0; i < goals.length; i++) {
      if (goals[i].isSelected) {
        goalsS += goals[i].title + ",";
      }
    }
    String activitiesS = "";
    for (int i = 0; i < activities.length; i++) {
      if (activities[i].isSelected) {
        activitiesS += activities[i].title + ",";
      }
    }
    String gendersS = "";
    for (int i = 0; i < genders.length; i++) {
      if (genders[i].isSelected) {
        gendersS += genders[i].title + ",";
      }
    }
    String badgesS = "";
    for (int i = 0; i < badges.length; i++) {
      if (badges[i].isSelected) {
        badgesS += badges[i].title + ",";
      }
    }
    rootRef.child("Users").child(auth.currentUser.uid).child("Profile").set({
      'college': college,
      'yearInSchool': yearInSchool,
      'height': height,
      'weight': weight,
      'gender': gender,
      'aboutMe': aboutMe,
      'whatImLookingFor': whatImLookingFor,
      'slider1': slider1,
      'slider2': slider2,
      'slider3': slider3,
      'lgbtq': lgbtq,
      'idealMatchLgbtq': idealMatchLgbtq,
      'academics': academicsS,
      'goals': goalsS,
      'activities': activitiesS,
      'genders': gendersS,
      'badges': badgesS,
    });
    rootRef.child("Users").child(auth.currentUser.uid).child("image").set(image1);
    rootRef.child("Users").child(auth.currentUser.uid).child("image2").set(image2);
    rootRef.child("Users").child(auth.currentUser.uid).child("image3").set(image3);

    rootRef.child(college).child("Users").child(auth.currentUser.uid).set({
      'id':auth.currentUser.uid,
     'image':image,
      'image2':image2,
      'image3':image3,
      'name':name,
      'yearInSchool':yearInSchool,
     'height':height,
     'weight':weight,
     'experience':slider1,
     'intensity':slider2,
     'frequency':slider3,
     'academics':academicsS,
     'goals':goalsS,
    'activities':activitiesS,
    });
    rootRef.child(college).child("Users").once().then((value)  {
      var keys = value.value.keys;
      var data = value.value;
      for (var key in keys) {
        if (rootRef.child(college).child("Users").child(key).key!=auth.currentUser.uid) {
          rootRef.child(college).child("Users").child(auth.currentUser.uid)
              .child("Matches")
              .child(key)
              .set({
            'id': key,
            'image': data[key]['image'],
            'image2': data[key]['image2'],
            'image3': data[key]['image3'],
            'name': data[key]['name'],
            'yearInSchool': data[key]['yearInSchool'],
            'height': data[key]['height'],
            'weight': data[key]['weight'],
            'experience': data[key]['experience'],
            'intensity': data[key]['intensity'],
            'frequency': data[key]['frequency'],
            'academics': data[key]['academics'],
            'goals': data[key]['goals'],
            'activities': data[key]['activities'],
          });
        }
      }
    });
    rootRef.child(college).child("Users").once().then((value)  {
      var keys = value.value.keys;
      var data = value.value;
      bool yes = false;
      for (var key in keys) {
        if (rootRef
            .child(college)
            .child("Users")
            .child(key)
            .key != auth.currentUser.uid) {
          rootRef.child(college).child("Users").child(key).child("Interested")
              .child(auth.currentUser.uid).once()
              .then((value1) {
            if (value1.value != null) {
              rootRef.child(college).child("Users").child(key)
                  .child("Interested")
                  .child(auth.currentUser.uid)
                  .set({
                'id': auth.currentUser.uid,
                'image': image,
                'image2': image2,
                'image3': image3,
                'name': name,
                'yearInSchool': yearInSchool,
                'height': height,
                'weight': weight,
                'experience': slider1,
                'intensity': slider2,
                'frequency': slider3,
                'academics': academicsS,
                'goals': goalsS,
                'activities': activitiesS,
              });
              yes = true;
              setState(() {

              });
            }
          });
          rootRef.child(college).child("Users").child(key).child("Matched")
              .child(auth.currentUser.uid).once()
              .then((value1) {
            if (value1.value != null) {
              rootRef.child(college).child("Users").child(key)
                  .child("Matched")
                  .child(auth.currentUser.uid)
                  .set({
                'id': auth.currentUser.uid,
                'image': image,
                'image2': image2,
                'image3': image3,
                'name': name,
                'yearInSchool': yearInSchool,
                'height': height,
                'weight': weight,
                'experience': slider1,
                'intensity': slider2,
                'frequency': slider3,
                'academics': academicsS,
                'goals': goalsS,
                'activities': activitiesS,
              });
              yes = true;
              setState(() {

              });
            }
          });
          if(!yes){
            rootRef.child(college).child("Users").child(key)
                .child("Matches")
                .child(auth.currentUser.uid)
                .set({
              'id': auth.currentUser.uid,
              'image': image,
              'image2': image2,
              'image3': image3,
              'name': name,
              'yearInSchool': yearInSchool,
              'height': height,
              'weight': weight,
              'experience': slider1,
              'intensity': slider2,
              'frequency': slider3,
              'academics': academicsS,
              'goals': goalsS,
              'activities': activitiesS,
            });
          }
        }
      }
      setState(() {

      });
    });
    prefs();
  }

  Future<bool> rootFirebaseIsExists(DatabaseReference databaseReference) async{
    DataSnapshot snapshot = await databaseReference.once();

    return snapshot !=null;
  }

  hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
  }

  List<BoxSelection> getList(value, List<String> list, bool rest) {
    List<BoxSelection> l = [];
    String v = value.toString();
    int index = 0;
    for (int i = 0; i < v.length; i++) {
      if (v.substring(i, i + 1) == (",")) {
        l.add(
            new BoxSelection(title: v.substring(index, i), isSelected: true));
        index = i + 1;
      }
    }
    if(rest) {
      List<String> titles = [];
      for (int i = 0; i < l.length; i++) {
        titles.add(l[i].title);
      }
      for (int i = 0; i < list.length; i++) {
        if (!titles.contains(list[i])) {
          l.add(new BoxSelection(title: list[i], isSelected: false));
        }
      }
    }
    return l;
  }

  Future<void> prefs() async {
    String i = "#";
    await rootRef.child("Users").child(FirebaseAuth.instance.currentUser.uid).child("Profile").once().then((value) async {
      await rootRef.child("College Colors").child(value.value['college']).once().then((value1) {
        i+= value1.value;
      });
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('color', i);
    runApp(MyApp(i));

  }

  getData() async {
    name = "";
    email = "";
    lgbtq = false;
    idealMatchLgbtq = false;
    slider1 = 0;
    slider2 = 0;
    getTemplates();
    FirebaseDatabase.instance.reference().child('Users').child(
          FirebaseAuth.instance.currentUser.uid).once().then((DataSnapshot data) {
        setState(() {
          name = data.value['name'];
          image1 = data.value['image'];
          image2 = data.value['image2'];
          image3 = data.value['image3'];
          email = data.value['email'];
          yearInSchool = data.value['Profile']['yearInSchool'];
          height = data.value['Profile']['height'];
          weight = data.value['Profile']['weight'];
          gender = data.value['Profile']['gender'];
          aboutMe = data.value['Profile']['aboutMe'];
          whatImLookingFor = data.value['Profile']['whatImLookingFor'];
          slider1 = data.value['Profile']['slider1'].toDouble();
          slider2 = data.value['Profile']['slider2'].toDouble();
          slider3 = data.value['Profile']['slider3'].toDouble();
          lgbtq = data.value['Profile']['lgbtq'];
          idealMatchLgbtq = data.value['Profile']['idealMatchLgbtq'];
          academics =
              getList(data.value['Profile']['academics'], getStringList(academics), true);
          goals = getList(data.value['Profile']['goals'], getStringList(goals), true);
          activities =
              getList(data.value['Profile']['activities'], getStringList(activities), true);
          genders = getList(data.value['Profile']['genders'], getStringList(genders), true);
          badges = getList(data.value['Profile']['badges'], getStringList(badges), true);
          college = data.value['Profile']['college'];
        });
      });
      rootRef.child("College Colors").once().then((DataSnapshot value){
        Map <dynamic, dynamic> values = value.value;
        values.forEach((key, values){
          setState(() {
            colleges.add(new DropdownMenuItem(child: Text(key), value: key,));
          });
        });
      });

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
      String fileName = basename(imag.path);
      StorageReference ref = FirebaseStorage.instance.ref().child(
          "Profile Images").child(FirebaseAuth.instance.currentUser.uid).child("Image1").child(
          fileName);
      StorageUploadTask uploadTask = ref.putFile(imag);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      var downUrl = await taskSnapshot.ref.getDownloadURL();
      var url = downUrl.toString();
      DatabaseReference rootRef = FirebaseDatabase.instance.reference().child(
          "Users");
      rootRef.child(FirebaseAuth.instance.currentUser.uid).child("image").set(
          url);
      image1 = url;
      setState(() {

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
  Future<String> getImage2(context) async {
    var image1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image1== null){

    }
    else {
      ProgressDialog pr = ProgressDialog(
          context, type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false);
      await pr.show();
      await pr.show();
      String fileName = basename(image1.path);
      StorageReference ref = FirebaseStorage.instance.ref().child(
          "Profile Images").child(FirebaseAuth.instance.currentUser.uid).child("Image2").child(
          fileName);
      StorageUploadTask uploadTask = ref.putFile(image1);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      var downUrl = await taskSnapshot.ref.getDownloadURL();
      var url = downUrl.toString();
      DatabaseReference rootRef = FirebaseDatabase.instance.reference().child(
          "Users");
      rootRef.child(FirebaseAuth.instance.currentUser.uid).child("image2").set(
          url);
      image2 = url;
      setState(() {

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
  Future<String> getImage3(context) async {
    var image1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image1== null){

    }
    else {
      ProgressDialog pr = ProgressDialog(
          context, type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false);
      await pr.show();
      await pr.show();
      String fileName = basename(image1.path);
      StorageReference ref = FirebaseStorage.instance.ref().child(
          "Profile Images").child(FirebaseAuth.instance.currentUser.uid).child("Image3").child(
          fileName);
      StorageUploadTask uploadTask = ref.putFile(image1);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      var downUrl = await taskSnapshot.ref.getDownloadURL();
      var url = downUrl.toString();
      DatabaseReference rootRef = FirebaseDatabase.instance.reference().child(
          "Users");
      rootRef.child(FirebaseAuth.instance.currentUser.uid).child("image3").set(
          url);
      image3 = url;
      setState(() {

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

  void getTemplates() async{
    await rootRef.child("Templates").once().then((value) {
      var data = value.value;
      academics = getList(value.value['academics'], null, false);
      goals = getList(value.value['goals'], null, false);
      activities = getList(value.value['activities'], null, false);
      badges = getList(value.value['badges'], null, false);
      genders = getList(value.value['genders'], null, false);
    });
  }

  List<String> getStringList(List<BoxSelection> academicTypes) {
    List<String> l = [];
    for(int i = 0; i < academicTypes.length; i++){
      l.add(academicTypes[i].title);
    }
    return l;
  }

}

