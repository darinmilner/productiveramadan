import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/screens/ayah_aday_page.dart';
import 'package:productive_ramadan_app/screens/daily_tasks.dart';
import 'package:productive_ramadan_app/screens/hadith_aday.dart';
import 'package:productive_ramadan_app/repositories/islamic_quiz.dart';
import 'package:productive_ramadan_app/landing.dart';
import 'package:productive_ramadan_app/screens/login_page.dart';
import 'package:productive_ramadan_app/screens/one_hadith_view.dart';
import 'package:productive_ramadan_app/screens/ramadan_dailytasks_tracker.dart';
import 'package:productive_ramadan_app/screens/todo_goals.dart';

import '../../screens/one_ayah_view.dart';
import '../../screens/about_ramadan_page.dart';

class PageRouter<T> extends MaterialPageRoute<T> {
  PageRouter({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  Widget buildTransitons(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == "/") {
      return child;
    }
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var curve = Curves.ease;
    var tween = Tween(
      begin: begin,
      end: end,
    ).chain(
      CurveTween(curve: curve),
    );
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

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
      case "/aboutramadan":
        return MaterialPageRoute(
          builder: (context) => AboutRamadan(),
        );
    }
  }
}
