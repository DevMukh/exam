import 'package:flutter/material.dart';
//themes for the whole app color
class AppColors {
  final Color backgroundColors = const Color(0xFFFFFFFF);
  final Color textColor = const Color(0xFF2A2426);
  final Color appBarText = const Color(0xFF2A2426);
  final Color customAppBarColor = const Color(0xFFF8F9FD);
  final Color colorStroke = const Color(0xFFE8E8E8);
}

class TextStyling {
  final TextStyle customAppBarStyle = const TextStyle(
      color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500);
  final TextStyle customAppBarHeading = const TextStyle(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
  final TextStyle valueRangePicker = const TextStyle(
      color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold);
  final TextStyle bonusTextColors = const TextStyle(
      color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold);
  final TextStyle gradesTextColors = const TextStyle(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
}

class CircularPercentIndicatorColors {
  final Color progressColor = const Color(0xFF141514);
  final Color backgroundColor = const Color(0xFFEDEFED);
}

class RecipetStyling {
  final TextStyle textTextColors = const TextStyle(
      color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold);
}
