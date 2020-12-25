import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class Member{
  String imageMain;
  String name;
  String year;
  String height;
  int weight;
  List<String> majors;
  List<String> goals;
  List<String> activities;

  Member(this.imageMain, this.name, this.year, this.height, this.weight,
      this.majors, this.goals, this.activities);

  Member.other(this.imageMain, this.name, this.year, this.height, this.weight);

  String getMajors(){
    String all = '';
    for(int i = 0; i < majors.length; i++){
      if(i!=majors.length-1)
        all+=majors[i]+", ";
      else
        all += majors[i];
    }
    return all;
  }
  @override
  String toString() {
    // TODO: implement toString
    return name;
  }

}