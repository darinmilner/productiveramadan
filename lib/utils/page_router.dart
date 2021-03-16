import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/ayah_aday_page.dart';
import 'package:productive_ramadan_app/daily_tasks.dart';
import 'package:productive_ramadan_app/hadith_aday.dart';
import 'package:productive_ramadan_app/islamic_quiz.dart';
import 'package:productive_ramadan_app/landing.dart';
import 'package:productive_ramadan_app/login_page.dart';
import 'package:productive_ramadan_app/one_hadith_view.dart';
import 'package:productive_ramadan_app/ramadan_dailytasks_tracker.dart';
import 'package:productive_ramadan_app/todo_goals.dart';

import '../one_ayah_view.dart';

class PageRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (context) => LandingPage(),
        );
      case "/quizpage":
        return MaterialPageRoute(
          builder: (context) => Quiz(),
        );
      case "/todogoals":
        return MaterialPageRoute(
          builder: (context) => TodoHome(),
        );
      case "/dailytasks":
        return MaterialPageRoute(
          builder: (context) => DailyTasks(),
        );
      case "/hadith":
        return MaterialPageRoute(
          builder: (context) => HadithADay(),
        );
      case "/ayahs":
        return MaterialPageRoute(
          builder: (context) => AyahADay(),
        );
      case "/tasktracker":
        return MaterialPageRoute(
          builder: (context) => DailyTasksTracker(),
        );
      case "/login":
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      case "/onehadith":
        return MaterialPageRoute(
          builder: (context) => OneHadithView(),
        );
      case "/oneayah":
        return MaterialPageRoute(
          builder: (context) => OneAyahView(),
        );
    }
  }
}
