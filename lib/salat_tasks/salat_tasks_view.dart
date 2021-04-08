import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:productive_ramadan_app/salat_tasks/salat_screens/daily_salat_tasks_screen.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/side_drawer.dart';

import '../admob_service.dart';
import '../landing.dart';

class SalatTasksView extends StatefulWidget {
  static const String routeName = "/salattasks";

  @override
  _SalatTasksViewState createState() => _SalatTasksViewState();
}

class _SalatTasksViewState extends State<SalatTasksView> {
  final ams = AdMobService();

  @override
  void initState() {
    super.initState();

    Admob.initialize();
  }

  Button _button = Button();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        backgroundColor: Colors.tealAccent,
        appBar: AppBar(
          backgroundColor: Colors.teal[500],
          title: Center(
            child: Text(
              "Productive Ramadan",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.amberAccent,
              ),
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(FontAwesomeIcons.home),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LandingPage(),
                      ),
                      (route) => false);
                })
          ],
        ),
        bottomSheet: AdmobBanner(
            adUnitId: ams.getBannerAdId(), adSize: AdmobBannerSize.FULL_BANNER),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color: Colors.tealAccent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Divider(
                    height: 20,
                  ),
                  Text(
                    "Daily Salat Tasks Manager",
                    style: TextStyle(
                      color: kDarkPink,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                  Divider(
                    height: 40,
                  ),
                  Text(
                    "Some ideas about how to spend some time with the Quran after each salat during Ramadan, the month of connection to the Quran. Write down and track your progress everyday during Ramadan in order to make a firm commitment inshallah",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Divider(
                    height: 40,
                  ),
                  _button.buildButton(
                      Colors.teal, Colors.white, "Track Daily Salat Activities",
                      () {
                    print("Salat task BTN");
                    Get.to(
                      DailySalatScreen(),
                    );
                  }),
                  Divider(
                    height: 50,
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
