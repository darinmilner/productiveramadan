import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

import 'package:hijri/hijri_calendar.dart';
import 'package:productive_ramadan_app/admob_service.dart';
import 'package:productive_ramadan_app/screens/ayah_aday_page.dart';
import 'package:productive_ramadan_app/screens/daily_tasks.dart';
import 'package:productive_ramadan_app/screens/hadith_aday.dart';
import 'package:productive_ramadan_app/repositories/islamic_quiz.dart';

import 'package:productive_ramadan_app/screens/todo_goals.dart';
import 'package:productive_ramadan_app/screens/about_ramadan_page.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/router/page_router.dart';
import 'package:productive_ramadan_app/utils/side_drawer.dart';

class LandingPage extends StatefulWidget {
  static const String routeName = "/";

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Button button = Button();
  HijriCalendar _today = HijriCalendar.now();

  final ams = AdMobService();

  @override
  void initState() {
    super.initState();
    print(_today);

    Admob.initialize();
  }

  @override
  Widget build(BuildContext context) {
    void goToAboutRamadan() {
      Navigator.of(context).pushReplacement(
        PageRouter(
          builder: (ctx) => AboutRamadan(),
        ),
      );
    }

    void goToTodoGoals() {
      Navigator.of(context).pushReplacementNamed(TodoHome.routeName);
    }

    void goToDailyTasks() {
      Navigator.of(context).pushReplacement(
        PageRouter(
          builder: (ctx) => DailyTasks(),
        ),
      );
    }

    void goToQuiz() {
      Navigator.of(context).pushReplacement(
        PageRouter(
          builder: (ctx) => Quiz(),
        ),
      );
    }

    void goToDailyHadith() {
      Navigator.of(context).pushReplacement(
        PageRouter(
          builder: (ctx) => HadithADay(),
        ),
      );
    }

    void goToDailyAyahs() {
      Navigator.of(context).pushReplacementNamed(AyahADay.routeName);
    }

    MyAppBar _appBar = MyAppBar();
    var month;
    if (_today.hMonth == 1) {
      month = "Muharram";
    } else if (_today.hMonth == 2) {
      month = "Safar";
    } else if (_today.hMonth == 3) {
      month = "Rabbi alAwwal";
    } else if (_today.hMonth == 4) {
      month = "Rabbi alThani";
    } else if (_today.hMonth == 5) {
      month = "Jumada alAwwal";
    } else if (_today.hMonth == 6) {
      month = "Jumada alThani";
    } else if (_today.hMonth == 7) {
      month = "Rajab";
    } else if (_today.hMonth == 8) {
      month = "Shaban";
    } else if (_today.hMonth == 9) {
      month = "Ramadan";
    } else if (_today.hMonth == 10) {
      month = "Shawwal";
    } else if (_today.hMonth == 11) {
      month = "Dhu alQi'dah";
    } else if (_today.hMonth == 12) {
      month = "Dhu alHijjah";
    }
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
                  child: Card(
                    elevation: 4,
                    color: Colors.grey[800],
                    shadowColor: Colors.teal[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Text(
                          "Today's Date:  ${month} - ${_today.hDay}",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Syne",
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 15.0,
                ),
                Center(
                  child: Text(
                    "Ramadan has come again Alhamdulillah",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 28,
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
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Divider(
                        height: 10.0,
                      ),
                      button.buildButton(Colors.red, Colors.white70,
                          "Daily Ramadan Tasks", goToDailyTasks),
                      Divider(
                        height: 10.0,
                      ),
                      button.buildButton(kDarkPink, Colors.white70,
                          "Ramadan Todo Goals", goToTodoGoals),
                      Divider(
                        height: 10.0,
                      ),
                      button.buildButton(Theme.of(context).primaryColor,
                          Colors.amberAccent, "Ramadan Quiz Game", goToQuiz),
                      Divider(
                        height: 15.0,
                      ),
                      button.buildButton(Colors.blueAccent, Colors.amberAccent,
                          "About Ramadan", goToAboutRamadan),
                      Divider(
                        height: 10.0,
                      ),
                      button.buildButton(Theme.of(context).accentColor,
                          Colors.white54, "Hadith of the day", goToDailyHadith),
                      Divider(
                        height: 10.0,
                      ),
                      button.buildButton(kDarkPurple, Colors.white54,
                          "Ayah of the day", goToDailyAyahs),
                    ],
                  ),
                ),

                //AD
                AdmobBanner(
                    adUnitId: ams.getBannerAdId(),
                    adSize: AdmobBannerSize.FULL_BANNER),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("$payload"),
      ),
    );
  }
}
