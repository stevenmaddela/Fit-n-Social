import 'dart:ui';

import 'package:flutter/material.dart';

class Promotion {
  final String title;
  final String titleDescription;
  final String cornerImage;
  final String mainImage;
  final String userImage;
  final String username;
  final String userCollege;
  final String description;
  final double stars;
  final int reviews;
  final double price;

  Promotion(
      this.title,
      this.titleDescription,
      this.cornerImage,
      this.mainImage,
      this.userImage,
      this.username,
      this.userCollege,
      this.description,
      this.stars,
      this.reviews,
      this.price, );
}