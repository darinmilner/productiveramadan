import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/admob_service.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';

class AboutRamadan extends StatefulWidget {
  static const route = "/aboutramadan";

  @override
  _AboutRamadanState createState() => _AboutRamadanState();
}

class _AboutRamadanState extends State<AboutRamadan> {
  MyAppBar _appBar = MyAppBar();
  final ams = AdMobService();
  @override
  void initState() {
    Admob.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar.buildAppBar(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.teal[700],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Ramadan, the month of mercy, Quran, fasting and connecting with Allah. We see Ramadan come and go year in and year out, and each Ramadan we plan to do so much, but most end of falling short when the reality of fasting for 30 days hits us. Have you ever wanted a better way to keep track of your Ramadan activities, or better organization of your Ramadan schedules and habits? ",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AdmobBanner(
                    adUnitId: ams.getBannerAdId(),
                    adSize: AdmobBannerSize.FULL_BANNER),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Well here it is, a Ramadan app just for you. Productive Ramadan! Come join us and millions of Muslims around the world working together with the productive Ramadan app to connect with Quran and Hadith, organized task, check list reminders, questionnaires and so much more. Let us feel connected this Ramadan and build our Taqwa together, and lets have a productive Ramadan.",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
