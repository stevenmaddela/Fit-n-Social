import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'models/member_model.dart';
class AddFriends extends StatefulWidget {
  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  List<Member> allMembers = [];
  List<Member> searchedMembers = [];
  List<String> friends = [];
  DatabaseReference rootRef = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          decoration: InputDecoration.collapsed(
            hintText: 'Search',
          ),
          onChanged: (String value){
            searchUsers(value);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: () {},
          ),
        ],
      ),


      body: ListView.separated(
        padding: EdgeInsets.all(10),
        separatorBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 0.5,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.3,
              child: Divider(),
            ),
          );
        },
        itemCount: searchedMembers.length,
        itemBuilder: (BuildContext context, int index) {
          Member member = searchedMembers[index];
          print(searchedMembers);
          print(member.id);
          print(friends);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  member.imageMain[0]
                ),
                radius: 25,
              ),

              contentPadding: EdgeInsets.all(0),
              title: Text(member.name),
              trailing: friends.contains(member.id)
                  ? FlatButton(
                child: Text(
                  "Unfollow",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.grey,
                onPressed: () {},
              ) : FlatButton(
                child: Text(
                  "Follow",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blueAccent,
                onPressed: () {},
              ),
              onTap: () {},
            ),
          );
        },

      ),
    );
  }

  @override
  void initState() {
    run();
  }

  void run() async {
    await rootRef.child("Users").child(auth.currentUser.uid).child("Profile").once().then((value) async {
      rootRef.child(value.value['college']).child("Users").once().then((value1) {
        var data = value1.value;
        var keys = value1.value.keys;
        for(var key in keys){
          setState(() {
            if(key!=auth.currentUser.uid)
              allMembers.add(new Member([data[key]['image'],data[key]['image2'],data[key]['image3']], data[key]['uid'], data[key]['name'], data[key]['yearInSchool'], data[key]['height'], data[key]['weight'], data[key]['slider1'], data[key]['slider2'], data[key]['slider3'], getList(data[key]['academics']), getList(data[key]['goals']), getList(data[key]['activities'])));
          });
        }
      });
      await rootRef.child(value.value['college']).child("Users").child(auth.currentUser.uid).child("Friends").once().then((value1) {
        var data = value1.value;
        var keys = value1.value.keys;
        for(var key in keys){
          setState(() {
              friends.add(data[key]['uid']);
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

  void searchUsers(String value) {
    searchedMembers.clear();
    var temp = allMembers.where((contact) {
      return contact.name.startsWith(value);
    }).toList();
    setState(() {
      searchedMembers = temp;
    });
  }

}
