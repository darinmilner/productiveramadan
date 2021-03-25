import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:productive_ramadan_app/models/hadith_model.dart';

void main() {
  List<Hadith> _hadiths = [
    Hadith(day: 1, text: "Hadith1"),
    Hadith(day: 2, text: "Hadith2"),
    Hadith(day: 3, text: "Hadith3"),
    Hadith(day: 4, text: "Hadith4"),
    Hadith(day: 5, text: "Hadith5"),
    Hadith(day: 6, text: "Hadith6"),
    Hadith(day: 7, text: "Hadith7"),
    Hadith(day: 8, text: "Hadith8"),
    Hadith(day: 9, text: "Hadith9"),
  ];
  testWidgets('Returns a hadith or ayah for the correct hijri day',
      (tester) async {
    HijriCalendar _today = HijriCalendar.now();
    int day = _today.hDay - 1;

    _hadiths[day].day == _today.hDay;
    print(_today.hDay); //Today is 8th day of the month

    expect(_hadiths[day].day, 8);
  });

  testWidgets(
      'Returns a hadith or ayah for the correct hijri day (testing yesterday)',
      (tester) async {
    HijriCalendar _today = HijriCalendar.now();
    int day = _today.hDay - 1;

    _hadiths[day].day == _today.hDay - 1; //Get Yesterday's Day
    print(_today.hDay); //Today is 8th day of the month

    expect(_hadiths[day].day - 1, 7);
  });

  testWidgets(
      'Returns a hadith or ayah for the correct hijri day (testing tomorrow)',
      (tester) async {
    HijriCalendar _today = HijriCalendar.now();
    int day = _today.hDay + 1;

    _hadiths[day].day == _today.hDay + 1; //Get Yesterday's Day
    print(_today.hDay); //Today is 8th day of the month

    expect(_hadiths[day].day + 1, 9);
  });
}
