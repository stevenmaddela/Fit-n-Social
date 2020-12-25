import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fitnsocial/models/event_model.dart';
import 'package:google_fonts/google_fonts.dart';
class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
List<Event> events = [
    new Event("3x3 Hoops Tournament",
    "Fri, Mar 27",
      "2:00",
      "8:00 PM",
      "CRC (Main Gym)",
      "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
      "It's tournament time! Time to find out who's got the best skills",
      [new EventAtendee("lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg","Isaac"), new EventAtendee("lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg","Israel")],
    ),
  new Event("3x3 Hoops Tournament",
    "Fri, Mar 27",
    "2:00",
    "8:00 PM",
    "CRC (Main Gym)",
    "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
    "It's tournament time! Time to find out who's got the best skills",
    [new EventAtendee("lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg","Isaac"), new EventAtendee("lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg","Israel")],
  ),
  new Event("3x3 Hoops Tournament",
    "Fri, Mar 27",
    "2:00",
    "8:00 PM",
    "CRC (Main Gym)",
    "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
    "It's tournament time! Time to find out who's got the best skills",
    [new EventAtendee("lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg","Isaac"), new EventAtendee("lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg","Israel")],
  ),
  new Event("3x3 Hoops Tournament",
    "Fri, Mar 27",
    "2:00",
    "8:00 PM",
    "CRC (Main Gym)",
    "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
    "It's tournament time! Time to find out who's got the best skills",
    [new EventAtendee("lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg","Isaac"), new EventAtendee("lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg","Israel")],
  ),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FloatingSearchBar.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,0),
            child: Column(
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
                      Image.asset(events[index].image, height: 100,width: 125, fit: BoxFit.fill,),
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
                              Image.asset(events[index].atendees[index2].image, height: 50, width: 50,),
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
                ),
                Divider(thickness: 1,)
              ],
            ),
          );
        },
        trailing: IconButton(
          icon: Icon(Icons.sort),
          color: Colors.black,
          onPressed: (){},
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        leading: IconButton(
          icon: Icon(Icons.post_add_rounded),
          color: Colors.black,
          onPressed: (){},
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        onChanged: (String value) {},
        onTap: () {},
        decoration: InputDecoration.collapsed(
          hintText: "Search...",
        ),
      ),
    );
  }
}
