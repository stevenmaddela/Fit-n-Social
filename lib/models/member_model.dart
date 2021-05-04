import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class Member{
  List<String> imageMain;
  String id;
  String name;
  String year;
  String height;
  String weight;
  double experience;
  double intensity;
  double frequency;
  List<String> majors;
  List<String> goals;
  List<String> activities;
  List<String> idealGenders;
  String yearInSchool;
  String gender;

  Member(this.imageMain, this.id, this.name, this.year, this.height, this.weight, this.experience, this.intensity, this.frequency,
      this.majors, this.goals, this.activities);
  Member.stats(this.idealGenders, this.gender, this.yearInSchool, this.height, this.weight, this.experience, this.intensity, this.frequency, this.majors,this.goals,this.activities);
  Member.additional(this.imageMain, this.id, this.name, this.year, this.height, this.weight, this.experience, this.intensity, this.frequency,
      this.majors, this.goals, this.activities, this.gender, this.idealGenders);
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