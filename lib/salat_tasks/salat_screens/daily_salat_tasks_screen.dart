import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:productive_ramadan_app/repositories/sharedpreferences.dart';

import 'package:productive_ramadan_app/salat_tasks/salat_controllers/daily_salat_controller.dart';
import 'package:productive_ramadan_app/salat_tasks/salat_models/salat_tasks_model.dart';

import '../../landing.dart';

class DailySalatScreen extends StatefulWidget {
  @override
  _DailySalatScreenState createState() => _DailySalatScreenState();
}

class _DailySalatScreenState extends State<DailySalatScreen> {
  final DailySalatController salatController = Get.put(DailySalatController());

  // getDay() {
  //   int day = SharedPrefs.getDay();
  //   return day;
  // }
  //
  // setDay(day) {
  //   SharedPrefs.setDay(now.day);
  // }

  @override
  void initState() {
    //int day = getDay();
    // print('Shared Prefs Day ${day}');

    salatController.tasks.add(
      DailySalatModel(
        task: "Read Quran in Arabic, clear and slow",
        salatName: "Fjar",
        isComplete: SharedPrefs.getSalatTaskCompleteFjar(),
      ),
    );

    salatController.tasks.add(
      DailySalatModel(
        task: "Read translation of Fajr verses in your native language",
        salatName: "Duhur",
        isComplete: SharedPrefs.getSalatTaskCompleteDuhr(),
      ),
    );

    salatController.tasks.add(
      DailySalatModel(
        task: "Read tafsir(Ibn Kathir) to understand the verses better",
        salatName: "Asr",
        isComplete: SharedPrefs.getSalatTaskCompleteAsr(),
      ),
    );

    salatController.tasks.add(
      DailySalatModel(
        task: "Talk to someone about the verses and apply in your daily life",
        salatName: "Maghrib",
        isComplete: SharedPrefs.getSalatTaskCompleteMaghrib(),
      ),
    );

    salatController.tasks.add(
      DailySalatModel(
        task:
            "Listen to a lecture about that surah or verse (or use in tahajjud)",
        salatName: "Isha",
        isComplete: SharedPrefs.getSalatTaskCompleteIsha(),
      ),
    );

    //Resets the tasks everyday at 1:30am
    // if (today != today + 1) {
    //   for (int i = 0; i < salatController.tasks.length; i++) {
    //     salatController.tasks[i].isComplete = false;
    //     switch (i) {
    //       case 0:
    //         SharedPrefs.setSalatTaskFjar(false);
    //         break;
    //       case 1:
    //         SharedPrefs.setSalatTaskDuhr(false);
    //         break;
    //       case 2:
    //         SharedPrefs.setSalatTaskAsr(false);
    //         break;
    //       case 3:
    //         SharedPrefs.setSalatTaskMaghrib(false);
    //         break;
    //       case 4:
    //         SharedPrefs.setSalatTaskIsha(false);
    //         break;
    //       default:
    //         print("Out of range");
    //         break;
    //     }
    //   }
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200],
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
                Navigator.of(context)
                    .pushReplacementNamed(LandingPage.routeName);
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: Text(
                "What did you do after salat today?",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Did you do better than yesterday?",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.73,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.greenAccent,
                  child: ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                      title: Column(
                        children: [
                          Text(
                            salatController.tasks[index].salatName,
                            style: TextStyle(
                              color: Colors.pink[900],
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            salatController.tasks[index].task,
                            style: (salatController.tasks[index].isComplete)
                                ? TextStyle(
                                    color: Colors.green[900],
                                  )
                                : TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      onTap: () {},
                      trailing: Obx(
                        () => Checkbox(
                          value: salatController.tasks[index].isComplete,
                          onChanged: (v) {
                            var changed = salatController.tasks[index];
                            changed.isComplete = v;
                            salatController.tasks[index] = changed;

                            switch (index) {
                              case 0:
                                SharedPrefs.setSalatTaskFjar(
                                    changed.isComplete);
                                // SharedPrefs.setDay(today);
                                break;
                              case 1:
                                SharedPrefs.setSalatTaskDuhr(
                                    changed.isComplete);
                                // SharedPrefs.setDay(today);
                                break;
                              case 2:
                                SharedPrefs.setSalatTaskAsr(changed.isComplete);
                                // SharedPrefs.setDay(today);
                                break;
                              case 3:
                                SharedPrefs.setSalatTaskMaghrib(
                                    changed.isComplete);
                                // SharedPrefs.setDay(today);
                                break;
                              case 4:
                                SharedPrefs.setSalatTaskIsha(
                                    changed.isComplete);
                                //  SharedPrefs.setDay(today);
                                break;
                              default:
                                print("Out of range");
                                break;
                            }
                          },
                        ),
                      ),
                    ),
                    separatorBuilder: (_, __) => Divider(),
                    itemCount: salatController.tasks.length,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
