import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/screens/ramadan_dailytasks_tracker.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';
import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/side_drawer.dart';

const Color teal = Colors.teal;
const double bottomContainerHeight = 70.0;
final Color containerColor = Colors.pink[900];

class DailyTasks extends StatelessWidget {
  static const tasksRoute = "/dailytasks";

  bool complete = false;
  @override
  Widget build(BuildContext context) {
    void saveDailyProgress() {
      print("Save tasks");
      Navigator.of(context).pushNamed(DailyTasksTracker.routeName);
    }

    MyAppBar _appBar = MyAppBar();
    return Scaffold(
      backgroundColor: Colors.teal[300],
      appBar: _appBar.buildAppBar(context),
      drawer: SideDrawer(),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "DAILY RAMADAN TASKS PAGE",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: 'Syne',
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "Click below to track daily progress",
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Syne',
                  letterSpacing: 1.5,
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ReusableCard(
                        color: teal,
                        text:
                            "Five daily salat, extra sunnah salat and tarawih",
                      ),
                    ),
                    Expanded(
                      child: ReusableCard(
                        color: Colors.tealAccent[200],
                        text: "Read Quran 20 minutes or more",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ReusableCard(
                        color: Colors.tealAccent[200],
                        text: "Fast everyday of Ramaan",
                      ),
                    ),
                    Expanded(
                      child: ReusableCard(
                        color: Colors.tealAccent[200],
                        text: "Do extra good deeds",
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: saveDailyProgress,
                child: Container(
                  color: teal,
                  height: bottomContainerHeight,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "SAVE DAILY PROGRESS",
                      style: kLandingPageTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  final String text;
  final Color color;
  ReusableCard({@required this.color, @required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontFamily: "Syne",
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: containerColor,
      ),
    );
  }
}
