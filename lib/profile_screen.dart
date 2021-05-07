import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_fitnsocial/main.dart';
import 'package:flutter_app_fitnsocial/models/boxSelection_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';



class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name, email, yearInSchool, height, weight, gender, aboutMe,
      whatImLookingFor, college;
  int academicsCt = 1, goalsCt = 3, activitiesCt = 3;
  bool lgbtq, idealMatchLgbtq;
  final rootRef = FirebaseDatabase.instance.reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var image = "https://firebasestorage.googleapis.com/v0/b/feedyyy-bfff8.appspot.com/o/Profile%20Images%2Fprofile_00000_00000.png?alt=media&token=aee78404-64a0-4bb6-a5f2-39b4f9da9d92";

  var image1;
  var image2;
  var image3;
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
    print('aboutMe: $aboutMe');
    print('whatIm: $whatImLookingFor');
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
                        child: DropdownButton<String>(
                          value: yearInSchool,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.deepPurple
                          ),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              yearInSchool = newValue;
                            });
                          },
                          items: <String>['Freshman', 'Sophomore', 'Junior', 'Senior']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Major",
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
                                      if(academics[index].isSelected) {
                                        academics[index].isSelected = false;
                                        academicsCt++;
                                      }
                                      else if(academicsCt!=0){
                                        academics[index]
                                            .isSelected = true;
                                        academicsCt--;
                                      }
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
                      SizedBox(width: 5,),
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
                            child: DropdownButton<String>(
                              value: height,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.deepPurple
                              ),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  height = newValue;
                                });
                              },
                              items: <String>['3\'11', '4', '4\'1', '4\'2','4\'3','4\'4','4\'5','4\'6','4\'7','4\'8','4\'9','4\'10','4\'11','5','5\'1','5\'2','5\'3','5\'4','5\'5','5\'6','5\'7','5\'8','5\'9','5\'10','5\'11','5\'12','6\'1','6\'2','6\'3','6\'4','6\'5','6\'6','6\'7','6\'8','6\'9','6\'10','6\'11','7','7\'1','7\'2','7\'3','7\'4','7\'5','7\'6','7\'7','7\'8','7\'9','7\'10','7\'11']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                                  .toList(),
                            ),
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
                            child: DropdownButton<String>(
                              value: weight,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.deepPurple
                              ),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  weight = newValue;
                                });
                              },
                              items: <String>["70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159","160","161","162","163","164","165","166","167","168","169","170","171","172","173","174","175","176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191","192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207","208","209","210","211","212","213","214","215","216","217","218","219","220","221","222","223","224","225","226","227","228","229","230","231","232","233","234","235","236","237","238","239","240","241","242","243","244","245","246","247","248","249","250","251","252","253","254","255","256","257","258","259","260","261","262","263","264","265","266","267","268","269","270","271","272","273","274","275","276","277","278","279","280","281","282","283","284","285","286","287","288","289","290","291","292","293","294","295","296","297","298","299","300"]

                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                                  .toList(),
                            ),
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
                            width: 95,
                            child: DropdownButton<String>(
                              value: gender,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.deepPurple
                              ),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  gender = newValue;
                                });
                              },
                              items: <String>['Male', 'Female', 'Non-Binary']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
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
                                if(goals[index].isSelected) {
                                  goals[index].isSelected = false;
                                  goalsCt++;
                                }
                                else if(goalsCt!=0){
                                  goals[index]
                                      .isSelected = true;
                                  goalsCt--;
                                }
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
                                if(activities[index].isSelected) {
                                  activities[index].isSelected = false;
                                  activitiesCt++;
                                }
                                else if(activitiesCt!=0){
                                  activities[index]
                                      .isSelected = true;
                                  activitiesCt--;
                                }
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
                                value: slider3==null?0:slider3,
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
                            String empty = fieldsNotEmpty();
                            if(empty=="Full") {
                              uploadData();
                              Navigator.pushAndRemoveUntil(
                                  context, MaterialPageRoute(
                                  builder: (_) => LoggedInScreen()), (
                                  Route<dynamic> rr) => false);
                            }
                            else
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                          empty),
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

    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("uid").set(auth.currentUser.uid);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("image").set(image1);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("image2").set(image2);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("image3").set(image3);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("name").set(name);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("yearInSchool").set(yearInSchool);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("height").set(height);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("weight").set(weight);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("experience").set(slider1);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("intensity").set(slider2);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("frequency").set(slider3);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("academics").set(academicsS);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("goals").set(goalsS);
    rootRef.child(college).child("Users").child(auth.currentUser.uid).child("activities").set(activitiesS);
    var now = new DateTime.now();
    var formatter = new DateFormat('MM/dd/yyyy');
    String month = formatter.format(now);
    rootRef.child("Users").child(auth.currentUser.uid).child("Messages").child("pM3IbZAts1UL430tIgyKcAMMyFB2").push().set({
      'date': month,
      'sender': "ADMIN",
      'text':"Welcome to Fit'nSocial!",
      'time':DateFormat.jms().format(DateTime.now()),
      'unread':false,
    });
    await rootRef.child(college).child("Users").once().then((value)  async {
      var keys = value.value.keys;
      var data = value.value;
      bool yes = false;
      for (var key in keys) {
        if (rootRef.child(college).child("Users").child(key).key!=auth.currentUser.uid) {
          await rootRef.child(college).child("Users").child(key).child("Interested").child(auth.currentUser.uid).once().then((value1) {
            if(value1.value!=null){
              rootRef.child(college).child("Users").child(key)
                  .child("Interested")
                  .child(auth.currentUser.uid)
                  .set({
                'uid': auth.currentUser.uid,
                'image': image1,
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
            }
          });
          await rootRef.child(college).child("Users").child(key).child("Matched")
              .child(auth.currentUser.uid).once()
              .then((value2) {
            if (value2.value != null) {
              rootRef.child(college).child("Users").child(key)
                  .child("Matched")
                  .child(auth.currentUser.uid)
                  .set({
                'uid': auth.currentUser.uid,
                'image': image1,
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
            }
          });
          if(!yes) {
            rootRef.child(college).child("Users").child(key)
                .child("Matches")
                .child(auth.currentUser.uid)
                .set({
              'uid': auth.currentUser.uid,
              'image': image1,
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
    });
    await rootRef.child(college).child("Users").once().then((value) async {
      var data = value.value;
      var keys = value.value.keys;
      bool yes = false;
      for (var key in keys) {
        if (rootRef.child(college).child("Users").child(key).key!=auth.currentUser.uid) {
          await rootRef.child(college).child("Users").child(auth.currentUser.uid).child("Interested").child(key).once().then((value1) {
            if(value1.value!=null){
              rootRef.child(college).child("Users").child(auth.currentUser.uid)
                  .child("Interested")
                  .child(key)
                  .set({
                'uid': key,
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
              yes = true;
            }
          });
          await rootRef.child(college).child("Users").child(auth.currentUser.uid).child("Matched")
              .child(key).once()
              .then((value2) {
            if (value2.value != null) {
              rootRef.child(college).child("Users").child(auth.currentUser.uid)
                  .child("Matched")
                  .child(key)
                  .set({
                'uid': key,
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
              yes = true;
            }
          });
          if(!yes) {
            rootRef.child(college).child("Users").child(auth.currentUser.uid)
                .child("Matches")
                .child(key)
                .set({
              'uid': key,
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
      }
    });
    setState(() {

    });
    prefs();
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
        i+= value1.value.toString();
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
    await getTemplates();
    await FirebaseDatabase.instance.reference().child('Users').child(FirebaseAuth.instance.currentUser.uid).once().then((DataSnapshot data){
      name = data.value['name'];
      email = data.value['email'];
      if(data.value['Profile']!=null){
        setState(() {
          image1 = data.value['image'];
          image2 = data.value['image2'];
          image3 = data.value['image3'];
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
      }
    });
    setState(() {

    });
    rootRef.child("College Colors").once().then((DataSnapshot value){
      Map <dynamic, dynamic> values = value.value;
      values.forEach((key, values){
        setState(() {
          colleges.add(new DropdownMenuItem(child: Text(key), value: key,));
        });
      });
    });

    print(academicsCt);
    for(int i = 0; i < academics.length; i++){
      if(academics[i].isSelected){
        academicsCt--;
      }
    }
    print(academicsCt);
    for(int i = 0; i < activities.length; i++){
      if(activities[i].isSelected){
        activitiesCt--;
      }
    }
    for(int i = 0; i < goals.length; i++){
      if(goals[i].isSelected){
        goalsCt--;
      }
    }
    setState(() {

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
      academics = getList(value.value['academics'], null, false);
      goals = getList(value.value['goals'], null, false);
      activities = getList(value.value['activities'], null, false);
      badges = getList(value.value['badges'], null, false);
      genders = getList(value.value['genders'], null, false);
    });
    await rootRef.child("Users").child(FirebaseAuth.instance.currentUser.uid).once().then((DataSnapshot data){
      setState(() {
        if(data.value['Profile']==null) {
          for (int i = 0; i < academics.length; i++)
            academics[i].setSelected(false);
          for (int i = 0; i < goals.length; i++)
            goals[i].setSelected(false);
          for (int i = 0; i < activities.length; i++)
            activities[i].setSelected(false);
          for (int i = 0; i < badges.length; i++)
            badges[i].setSelected(false);
          for (int i = 0; i < genders.length; i++)
            genders[i].setSelected(false);
        }
      });
    });
  }

  List<String> getStringList(List<BoxSelection> academicTypes) {
    List<String> l = [];
    for(int i = 0; i < academicTypes.length; i++){
      l.add(academicTypes[i].title);
    }
    return l;
  }

  String fieldsNotEmpty() {
    if (name == null)
      return "Name is Empty";
    else if (email == null)
      return "Email is Empty";
    else if (yearInSchool == null)
      return "Year in School is Empty";
    else if (height == null)
      return "Height is Empty";
    else if (academics.length < 1)
      return "Need 1 Academic Field";
    else if (activities.length < 3)
      return "Need 3 Activities";
    else if (goals.length < 3)
      return "Need 3 Goals";
    else if (weight == null)
      return "Weight is Empty";
    else if (gender == null)
      return "Gender is Empty";
    else if (aboutMe == null)
      return "About Me is Empty";
    else if (whatImLookingFor == null)
      return "What I'm looking for is Empty";
    else if (college == null)
      return "College is Empty";
    else if (image1 == null)
      return "Image 1 is Empty";
    else if (image2 == null)
      return "Image 2 is Empty";
    else if (image3 == null)
      return "Image 3 is Empty";
    else return "Full";
  }

}
