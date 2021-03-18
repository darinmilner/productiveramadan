import 'package:flutter/material.dart';

final Color kPurple = Colors.deepPurple;
final Color kDarkGreen = Colors.green[900];
final Color kBlackishGray = Colors.grey.shade900;
final Color kLightGray = Colors.grey.shade200;
final Color kDarkGray = Colors.grey.shade700;
final Color kDarkPurple = Colors.deepPurple[800];
final Color kDarkPink = Colors.pink[800];
final Color kDarkOrangeRed = Colors.deepOrange[800];
final Color kGreenishTeal = Colors.teal[300];
final Color kDarkTeal = Colors.teal[800];
final Color kLightOrange = Colors.deepOrange[200];

final List<BoxShadow> kBoxShadow = [
  BoxShadow(
    color: Colors.green[800],
    offset: Offset(0, 2),
    blurRadius: 4.0,
  ),
];

final TextStyle kDailyTrackerTestStyle = TextStyle(
  color: Colors.amber,
  fontSize: 22.0,
  fontWeight: FontWeight.w800,
  fontFamily: "Syne",
  fontStyle: FontStyle.italic,
  letterSpacing: 1.5,
);

final TextStyle kLandingPageTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: kLightGray,
  fontFamily: "Syne",
  fontStyle: FontStyle.italic,
  letterSpacing: 2,
);

final LinearGradient kBackgroundGreenGradient = LinearGradient(
  colors: [Colors.tealAccent, kDarkTeal],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
