import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/member_model.dart';
class MatchesScreen extends StatefulWidget {
  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<Member> members = [];
  DatabaseReference rootRef = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    run();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme
        .of(context)
        .accentColor,
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (BuildContext context, int index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      ClipRRect(borderRadius:BorderRadius.circular(10),child: Image(image: NetworkImage(members[index].imageMain[0]), height: 100, width: 100, fit: BoxFit.fill,),),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left:15.0, right: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(members[index].year,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black54,
                                        fontSize:
                                        MediaQuery.of(context).size.width / 25),
                                  ),
                                  Text(members[index].height,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black54,
                                        fontSize:
                                        MediaQuery.of(context).size.width / 25),
                                  ),
                                  Text(members[index].weight.toString(),
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black54,
                                        fontSize:
                                        MediaQuery.of(context).size.width / 25),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,),
                              RatingBarIndicator(
                                rating: 2.75,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 35.0,
                                unratedColor: Colors.black12,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(members[index].name,
                    style: GoogleFonts.montserrat(
                        color: Colors.black54,
                        fontSize:
                        MediaQuery.of(context).size.width / 25),
                  ),
                  Divider(height: 20,thickness: 2,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void run() {
    rootRef.child("Users").child(auth.currentUser.uid).child("Profile").once().then((value) {
      rootRef.child(value.value['college']).child("Users").child(auth.currentUser.uid).child("Matched").once().then((value1) {
        var data = value1.value;
        var keys = value1.value.keys;
        for(var key in keys){
          setState(() {
            members.add(new Member([data[key]['image'],data[key]['image2'],data[key]['image3']], data[key]['uid'], data[key]['name'], data[key]['Profile']['yearInSchool'], data[key]['Profile']['height'], data[key]['Profile']['weight'], data[key]['Profile']['slider1'], data[key]['Profile']['slider2'], data[key]['Profile']['slider3'], getList(data[key]['Profile']['academics']), getList(data[key]['Profile']['goals']), getList(data[key]['Profile']['activities'])));
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
}
