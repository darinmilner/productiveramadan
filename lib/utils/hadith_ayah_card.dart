import 'package:dartarabic/dartarabic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:html_character_entities/html_character_entities.dart';

class HadithAyahCard extends StatefulWidget {
  final String text;
  final String ayahHadithText;
  final int dayNumber;

  HadithAyahCard(
      {@required this.text, this.ayahHadithText, @required this.dayNumber});

  @override
  _HadithAyahCardState createState() => _HadithAyahCardState();
}

class _HadithAyahCardState extends State<HadithAyahCard> {
  FlutterLocalNotificationsPlugin flutterNotifications;
  FlutterLocalNotificationsPlugin lastTenNightsNotification;

  @override
  void initState() {
    super.initState();
    var androidInit = AndroidInitializationSettings("appicon");
    var iOSinit = IOSInitializationSettings();

    var initSettings = InitializationSettings(androidInit, iOSinit);
    flutterNotifications = FlutterLocalNotificationsPlugin();
    flutterNotifications.initialize(initSettings,
        onSelectNotification: notificationSelected);
    lastTenNightsNotification = FlutterLocalNotificationsPlugin();
    lastTenNightsNotification.initialize(initSettings,
        onSelectNotification: notificationSelected);
  }

  Future _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      "${widget.ayahHadithText}",
      "Productive Ramadan",
      "${widget.dayNumber}",
      importance: Importance.Default,
      playSound: true,
    );

    var iOSDetails = IOSNotificationDetails();
    var generalNotificationDetails = NotificationDetails(
      androidDetails,
      iOSDetails,
    );

    var scheduleTime = DateTime.now().add(Duration(seconds: 30));

    if (widget.dayNumber == 16) {
      await lastTenNightsNotification.show(
        10,
        "Ramadan Day #${widget.dayNumber}",
        "Last Ten nights of Ramadan are approaching.  Time to step up our ibadah and finish strong inshallah for more rewards from Allah",
        generalNotificationDetails,
        payload: "Step up Ibadah to prepare for the last 10 nights",
      );
    }

    await flutterNotifications.schedule(
      100,
      "${widget.text} #${widget.dayNumber}",
      "Check back tomorrow for the next ${widget.ayahHadithText}",
      scheduleTime,
      generalNotificationDetails,
      payload: "Check back tomorrow for the next ${widget.ayahHadithText}",
      androidAllowWhileIdle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.text);
    _showNotification();
    return Expanded(
      child: ListView(
        children: [
          Card(
            shadowColor: Colors.green[600],
            elevation: 8.0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red[200],
                    Colors.teal[200],
                    Colors.teal[300],
                    Colors.teal[100],
                    Colors.teal[300],
                    Colors.teal[200],
                    Colors.red[200],
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "${widget.ayahHadithText} number ${widget.dayNumber}",
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        fontFamily: "Syne",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    height: 30,
                    color: Colors.teal[600],
                    thickness: 3.0,
                  ),
                  Text(
                    HtmlCharacterEntities.decode(widget.text),
                    // widget.text,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Divider(
                    height: 30,
                  ),
                  Text(
                    "Come back tomorrow for tomorrow's ${widget.ayahHadithText} of the day.",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.green[800],
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        ],
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
