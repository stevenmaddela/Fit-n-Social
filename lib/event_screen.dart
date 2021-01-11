import 'package:flutter/material.dart';
import 'package:flutter_app_fitnsocial/models/event_model.dart';
import 'package:google_fonts/google_fonts.dart';

class EventScreen extends StatefulWidget {
  final String title;
  final String date;
  final String fromToTime;
  final String location;
  final String description;
  final String image;
  final List<EventAtendee> atendees;

  EventScreen(this.title, this.date, this.fromToTime, this.location,
      this.description, this.image, this.atendees);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.image,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
            ),
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
                        icon: Icon(Icons.share_outlined, color: Colors.black,),
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
                Container(
                  width: MediaQuery.of(context).size.width/2.5,
                  color: Colors.pink,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check_circle_outline, color: Colors.white,),
                        onPressed: (){},
                      ),
                      Text(
                        "Going",
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 25),
                      ),
                      SizedBox(width: 10,),
                    ],
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
                  itemCount: widget.atendees.length,
                  itemBuilder: (BuildContext context, int index2){
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(widget.atendees[index2].image, height: 50, width: 50,),
                          Text(widget.atendees[index2].name,
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
          ],
        ),
      ),
    );
  }
}
