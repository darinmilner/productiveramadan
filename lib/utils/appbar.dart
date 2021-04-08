import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../landing.dart';

class MyAppBar extends StatelessWidget {
  AppBar buildAppBar(context) {
    return AppBar(
      title: Center(
        child: Text(
          "Productive Ramadan",
          style: TextStyle(fontSize: 20.0, color: Colors.amberAccent),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
    );
  }
}
