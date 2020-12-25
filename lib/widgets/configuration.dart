import 'package:flutter/material.dart';

Color primaryGreen = Color(0xff416d6d);
List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 10))
];


List<Map> drawerItems=[
  {
    'icon': Icons.person_outline,
    'title' : 'Profile'
  },
  {
    'icon': Icons.settings,
    'title' : 'Settings'
  },
  {
    'icon': Icons.person_add,
    'title' : 'Add Friend'
  },
  {
    'icon': Icons.share,
    'title' : 'Share App'
  },
  {
    'icon': Icons.info_outline,
    'title' : 'Help'
  },
  {
    'icon': Icons.arrow_back_ios,
    'title' : 'Logout'
  },
];