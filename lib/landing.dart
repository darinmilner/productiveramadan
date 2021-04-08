import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hijri/hijri_calendar.dart';
import 'package:productive_ramadan_app/admob_service.dart';
import 'package:productive_ramadan_app/salat_tasks/salat_tasks_view.dart';
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
    if (!kIsWeb) {
      Admob.initialize();
    }
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
      Navigator.of(context).popAndPushNamed(TodoHome.routeName);
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

    void goToSalatTasks() {
      Navigator.of(context).pushReplacement(
        PageRouter(
          builder: (ctx) => SalatTasksView(),
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

    const double dividerSpace = 8.0;
    return Scaffold(
      backgroundColor: Colors.teal[200],
      appBar: _appBar.buildAppBar(context),
      drawer: SideDrawer(),
      bottomSheet: kIsWeb
          ? Container()
          : AdmobBanner(
              adUnitId: ams.getBannerAdId(),
              adSize: AdmobBannerSize.FULL_BANNER),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Card(
                      elevation: 4,
                      color: Colors.teal[400],
                      shadowColor: Colors.teal[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Text(
                            "Today's Date:  ${month} - ${_today.hDay}",
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 20,
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
                    height: dividerSpace,
                  ),
                  Center(
                    child: Text(
                      "Ramadan has come again Alhamdulillah",
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Syne",
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    height: dividerSpace,
                  ),
                  Center(
                    child: Text(
                      "Choose an option",
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Divider(
                        height: dividerSpace,
                      ),
                      button.buildButton(Colors.red, Colors.white70,
                          "Daily Ramadan Tasks", goToDailyTasks),
                      Divider(
                        height: dividerSpace,
                      ),
                      button.buildButton(kDarkPink, Colors.white70,
                          "Ramadan Todo Goals", goToTodoGoals),
                      Divider(
                        height: dividerSpace,
                      ),
                      button.buildButton(Theme.of(context).primaryColor,
                          Colors.amberAccent, "Ramadan Quiz Game", goToQuiz),
                      Divider(
                        height: dividerSpace,
                      ),
                      button.buildButton(Colors.blueAccent, Colors.amberAccent,
                          "About Ramadan", goToAboutRamadan),
                      Divider(
                        height: dividerSpace,
                      ),
                      button.buildButton(Theme.of(context).accentColor,
                          Colors.white54, "Hadith of the day", goToDailyHadith),
                      Divider(
                        height: dividerSpace,
                      ),
                      button.buildButton(kDarkPurple, Colors.white54,
                          "Ayah of the day", goToDailyAyahs),
                      Divider(
                        height: dividerSpace,
                      ),
                      button.buildButton(kDarkTeal, Colors.white54,
                          "Salat Manager", goToSalatTasks),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
