import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fitnsocial/matches_Screen.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:shimmer/shimmer.dart';
import 'package:async/async.dart';
import 'chat_screen.dart';
import 'models/message_model.dart';
import 'models/user_model.dart';

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .accentColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        title: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(
              text: 'Messages',
            ),
            Tab(
              text: 'Matches',
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.person_add, color: Colors.white,),
              onPressed: (){},
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: DelayedList()),
          MatchesScreen(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

}

class DelayedList extends StatefulWidget {
  @override
  _DelayedListState createState() => _DelayedListState();
}

class _DelayedListState extends State<DelayedList>{
  bool isLoading = true;
  RestartableTimer _restartTimer;
  bool dataChanging = false;
  bool show = false;
  List<String> uids = [];
  Message message;
  List<InboxUser> users = [];



  @override
  void initState() {
    awaitData();
  }

  @override
  Widget build(BuildContext context) {
    _restartTimer = RestartableTimer(Duration(milliseconds: 1),_onTimerFinished);
    return isLoading | dataChanging ? ShimmerList() : DataList(users);
  }

  _onTimerFinished(){
    if(!show) {
      _restartTimer.reset();
    }
    else {
      _restartTimer.cancel();
      setState(() {
        dataChanging = false;
        isLoading = false;
      });
    }
  }


 getData() {
   DatabaseReference usersRef = FirebaseDatabase.instance.reference();
   usersRef.child("Users").child(FirebaseAuth.instance.currentUser.uid).child("Messages").onValue.listen((snap)  async{
     dataChanging = true;
     show = false;

     uids.clear();
     users.clear();
     setState(() {

     });
     var keys = snap.snapshot.value.keys;
     var data = snap.snapshot.value;
     for(var key in keys) {
       uids.add(key);
     }
     setState(() {

     });
     for(int i = 0; i < uids.length; i++){
       usersRef.child("Users").child(FirebaseAuth.instance.currentUser.uid).child("Messages").child(uids[i]).limitToLast(1).once().then((DataSnapshot snap) async {
         users.clear();
         var data = snap.value;
         var keys = snap.value.keys;
         for(var key in keys) {
           Message x = new Message(
               sender: data[key]['sender'],
               time: data[key]['time'],
               date: data[key]['date'],
               unread: data[key]['unread'],
               text: data[key]['text'],
               hash: data[key]['key']
           );
           await adduser(x, uids[i]);
         }
       });

     }
       users.sort((a, b) {
         var timeOne = a.lastMessage.time.substring(0,a.lastMessage.time.indexOf(":")+6);
         var timetwo= b.lastMessage.time.substring(0,a.lastMessage.time.indexOf(":")+6);

         var dateOne = a.lastMessage.date;
         var datetwo= b.lastMessage.date;

         if(dateOne==datetwo){
           return timeOne.compareTo(timetwo);
         }
         else
           return dateOne.compareTo(datetwo);
       });
     show = true;
     setState(() {

     });

   });

 }

 adduser(Message x, String uid) {
   DatabaseReference usersRef = FirebaseDatabase.instance.reference();
   usersRef.child("Users").child(uid).once().then((value)  {
     var data = value.value;
     if(x.text.indexOf("https://firebasestorage.googleapis.com/v0/b/feedy-a90a8.appspot.com")!=-1) {
       Message u1 = new Message(
         sender: x.sender,
         time: x.time,
         date: x.date,
         unread: x.unread,
         text: 'Image 📷',
         hash: x.hash,
       );
       InboxUser u = new InboxUser(
         id: data['uid'],
         name: data['name'],
         lastMessage: u1 ,
         imageUrl: data['image1'],
       );
       users.add(u);
     }
     else{
       InboxUser u = new InboxUser(
         id: uid,
         name: data['name'],
         lastMessage: x,
         imageUrl: data['image'],
       );
       users.add(u);
     }
   });
 }

  void awaitData(){
    getData();
  }

}

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Container(
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .accentColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Scrollbar(
          child: SafeArea(
            child: ListView.builder(
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                offset += 500;
                time = 800 + offset;
                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.grey[300],
                      child: ShimmerLayout(),
                      period: Duration(milliseconds: time),
                    ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
          padding:
          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 35.0,
                    backgroundImage: null,
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Loading...",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: Text("Loading...",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("...",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: 40.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DataList extends StatefulWidget {
  List<InboxUser> users;

  DataList(this.users);

  _DataListState createState() => _DataListState(users);

}
class _DataListState extends State<DataList> with AutomaticKeepAliveClientMixin{

  List<InboxUser> users;

  _DataListState(this.users);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 15, child: Container(color: Theme.of(context).primaryColor.withOpacity(.1),),),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(.1),
              ),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  final InboxUser user = users[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          userId: user.id, name: user.name, lastHash: user.lastMessage.hash,
                        ),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: user.lastMessage.unread ? Color(0xFFFFEFEE) : Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 35.0,
                                backgroundImage: user.imageUrl!=null? NetworkImage(user.imageUrl) : NetworkImage(null),
                              ),
                              SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    user.name,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.40,
                                    child: Text(
                                      user.lastMessage.text,
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                user.lastMessage.time.substring(0,user.lastMessage.time.indexOf(":")+3) + " " + user.lastMessage.time.substring(user.lastMessage.time.length-2),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              user.lastMessage.unread
                                  ? Container(
                                width: 50.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'NEW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                                  : Text(''),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}



