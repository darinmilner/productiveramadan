import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productive_ramadan_app/islamic_quiz.dart';
import 'package:productive_ramadan_app/todo_goals.dart';

import '../ayah_aday_page.dart';
import '../daily_tasks.dart';
import '../hadith_aday.dart';
import 'constants.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Icon(FontAwesomeIcons.bars),
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
              Navigator.of(context).pushReplacementNamed("/");
            },
            leading: Icon(
              FontAwesomeIcons.home,
              color: kGreenishTeal,
            ),
            title: Text(
              "HOME",
              style: TextStyle(
                fontSize: 25.0,
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
                fontSize: 25.0,
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
                fontSize: 25.0,
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
                fontSize: 25.0,
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
                fontSize: 25.0,
                color: kGreenishTeal,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(TodoHome.routeName);
            },
            leading: Icon(
              FontAwesomeIcons.blog,
              color: kGreenishTeal,
            ),
            title: Text(
              "RAMADAN GOALS",
              style: TextStyle(
                fontSize: 25.0,
                color: kGreenishTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
