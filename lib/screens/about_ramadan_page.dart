import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';

class AboutRamadan extends StatelessWidget {
  static const route = "/aboutramadan";
  MyAppBar _appBar = MyAppBar();
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
                Text("Add here"),
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
