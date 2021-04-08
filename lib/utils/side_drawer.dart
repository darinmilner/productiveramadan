import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productive_ramadan_app/repositories/islamic_quiz.dart';
import 'package:productive_ramadan_app/salat_tasks/salat_tasks_view.dart';

import '../landing.dart';
import '../screens/ayah_aday_page.dart';
import '../screens/daily_tasks.dart';
import '../screens/hadith_aday.dart';
import 'constants.dart';

class SideDrawer extends StatelessWidget {
  double fontSize = 16.0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                "PRODUCTIVE RAMADAN",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.black54,
                  letterSpacing: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            decoration: BoxDecoration(
              gradient: kBackgroundGreenGradient,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LandingPage(),
                  ),
                  (route) => false);
            },
            leading: Icon(
              FontAwesomeIcons.home,
              color: kGreenishTeal,
            ),
            title: Text(
              "HOME",
              style: TextStyle(
                fontSize: fontSize,
                color: kGreenishTeal,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HadithADay.routeName);
            },
            leading: Icon(
              FontAwesomeIcons.book,
              color: kGreenishTeal,
            ),
            title: Text(
              "HADITH A DAY",
              style: TextStyle(
                fontSize: fontSize,
                color: kGreenishTeal,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Quiz.quizPageRoute);
            },
            leading: Icon(
              FontAwesomeIcons.gamepad,
              color: kGreenishTeal,
            ),
            title: Text(
              "QUIZ GAME",
              style: TextStyle(
                fontSize: fontSize,
                color: kGreenishTeal,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AyahADay.routeName);
            },
            leading: Icon(
              FontAwesomeIcons.readme,
              color: kGreenishTeal,
            ),
            title: Text(
              "AYAH A DAY",
              style: TextStyle(
                fontSize: fontSize,
                color: kGreenishTeal,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(DailyTasks.tasksRoute);
            },
            leading: Icon(
              FontAwesomeIcons.tasks,
              color: kGreenishTeal,
            ),
            title: Text(
              "DAILY TASKS",
              style: TextStyle(
                fontSize: fontSize,
                color: kGreenishTeal,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SalatTasksView.routeName);
            },
            leading: Icon(
              FontAwesomeIcons.quran,
              color: kGreenishTeal,
            ),
            title: Text(
              "SALAT TASKS",
              style: TextStyle(
                fontSize: fontSize,
                color: kGreenishTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
