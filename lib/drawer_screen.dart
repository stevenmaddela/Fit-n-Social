import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_fitnsocial/widgets/configuration.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_fitnsocial/profile_screen.dart';
import 'package:flutter_app_fitnsocial/t&c_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:core';
import 'package:url_launcher/url_launcher.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String name;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  var image;


  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Color(0xFFD2D4C8),
        padding: EdgeInsets.fromLTRB(0, 70, 15, 0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 30,),
                  CircleAvatar(
                    backgroundImage: image!=null? NetworkImage(image) : AssetImage("lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg"),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name.toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                      ),
                      Text("Active Status",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF40916c),
                        ),)

                    ],
                  ),
                ],
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: drawerItems.map((element) => Padding(
                        padding: EdgeInsets.fromLTRB(30,20,0,10),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                if(element['title']=='Contact Us'){
                                  final Uri _emailLaunchUri = Uri(
                                    scheme: 'mailto',
                                    path: 'syfn.games@gmail.com',
                                  );
                                  _launchURL(_emailLaunchUri.toString());
                                }
                                if(element['title']=='Profile'){
                                  Navigator.push(context,MaterialPageRoute(builder: (_) => ProfileScreen()));
                                }
                                if(element['title']=='Rate Us'){

                                }
                                if(element['title']=='T&C'){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => tcScreen(),
                                    ),
                                  );
                                }
                                if(element['title']=='Logout'){
                                  auth.signOut();
                                }
                              },
                                child: Text(element['title'],
                                  style: GoogleFonts.montserrat(fontSize: 25,
                                    color: element['title']=='Logout'? Color(0xFFda1e37): Colors.black54,

                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                            ),
                            SizedBox(width: 10,),
                            InkWell(
                              onTap: (){
                                if(element['title']=='Contact Us'){
                                  final Uri _emailLaunchUri = Uri(
                                    scheme: 'mailto',
                                    path: 'syfn.games@gmail.com',
                                  );
                                  _launchURL(_emailLaunchUri.toString());
                                }

                                if(element['title']=='Profile'){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProfileScreen(),
                                    ),
                                  );
                                }
                                if(element['title']=='Rate Us'){

                                }
                                if(element['title']=='T&C'){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => tcScreen(),
                                    ),
                                  );
                                }
                                if(element['title']=='Logout'){
                                  auth.signOut();
                                }
                              },
                                child: Icon(element['icon'],
                                  color: element['title']=='Logout'? Color(0xFFa71e34): Colors.black87,
                                  size: 35,)
                            ),

                          ],
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
              Text('\n\n\n'),
            ],
          ),

        ),
      ),
    );
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getData() async {
    await getDat();
}

  getDat() async{
    FirebaseDatabase.instance.reference().child('Users').child(FirebaseAuth.instance.currentUser.uid).child('name').onValue.listen((data) {
      setState(() {
        name = data.snapshot.value.toString();
      });
    });
    FirebaseDatabase.instance.reference().child('Users').child(FirebaseAuth.instance.currentUser.uid).child('image').onValue.listen((data) {
      setState(() {
        image = data.snapshot.value;
      });
    });
  }
}
