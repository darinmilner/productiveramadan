import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productive_ramadan_app/ayah_aday_page.dart';
import 'package:productive_ramadan_app/daily_tasks.dart';
import 'package:productive_ramadan_app/hadith_aday.dart';
import 'package:productive_ramadan_app/islamic_quiz.dart';
import 'package:productive_ramadan_app/login_page.dart';
import 'package:productive_ramadan_app/todo_goals.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/side_drawer.dart';

//TODO: Localization and SQLlite3
class LandingPage extends StatelessWidget {
  Button button = Button();
  static const String routeName = "/";

  void goToAboutRamadan() {
    print("About Ramadan");
  }

  @override
  Widget build(BuildContext context) {
    void goToTodoGoals() {
      Navigator.of(context).pushNamed(TodoHome.routeName);
      print("Goals BTN");
    }

    void goToDailyTasks() {
      Navigator.of(context).pushNamed(DailyTasks.tasksRoute);
      print("Daily tasks BTN");
    }

    void goToQuiz() {
      Navigator.of(context).pushNamed(Quiz.quizPageRoute);
      print("Quiz BTN");
    }

    void goToDailyHadith() {
      Navigator.of(context).pushNamed(HadithADay.routeName);
    }

    void goToDailyAyahs() {
      Navigator.of(context).pushNamed(AyahADay.routeName);
    }

    void goToLogin() {
      Navigator.of(context).pushNamed(LoginPage.loginPageRoute);
      print("Login BTN");
    }

    MyAppBar _appBar = MyAppBar();
    return Scaffold(
      appBar: _appBar.buildAppBar(context),
      drawer: SideDrawer(),
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Ramadan has come again Alhamdulillah",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Syne",
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(
                  height: 20.0,
                ),
                Center(
                  child: Text(
                    "Choose an option",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  height: 20.0,
                ),
                button.buildButton(Colors.red, Colors.white70,
                    "Daily Ramadan Tasks", goToDailyTasks),
                Divider(
                  height: 15.0,
                ),
                button.buildButton(kDarkPink, Colors.white70,
                    "Ramadan Todo Goals", goToTodoGoals),
                Divider(
                  height: 15.0,
                ),
                button.buildButton(Theme.of(context).primaryColor,
                    Colors.amberAccent, "Ramadan Quiz Game", goToQuiz),
                Divider(
                  height: 15.0,
                ),
                button.buildButton(Theme.of(context).primaryColor,
                    Colors.amberAccent, "About Ramadan", goToAboutRamadan),
                Divider(
                  height: 15.0,
                ),
                button.buildButton(Theme.of(context).accentColor,
                    Colors.white54, "Hadith of the day", goToDailyHadith),
                Divider(
                  height: 15.0,
                ),
                button.buildButton(kDarkPurple, Colors.white54,
                    "Ayah of the day", goToDailyAyahs),
                // GlowingButton(
                //   color1: kDarkPurple,
                //   color2: kDarkPink,
                //   isTrue: true,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
