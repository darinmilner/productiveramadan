import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'package:productive_ramadan_app/utils/buttons/glowing_button.dart';
import 'package:productive_ramadan_app/utils/constants.dart';

class AlertBox extends StatelessWidget {
  Button button = Button();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Warning"),
      content: Text("Are you sure you want to delete this task"),
      actions: [
        // GlowingButton(
        //   text: "Yes",
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
        // GlowingButton(
        //   color1: Colors.red,
        //   color2: kDarkOrangeRed,
        //   text: "No",
        //   onPressed: () {
        //     Navigator.of(context).pop(false);
        //   },
        // ),
        button.buildButton(
          Colors.green,
          Colors.white,
          "YES",
          () {
            Navigator.of(context).pop(true);
          },
        ),
        button.buildButton(
          Colors.red,
          Colors.white,
          "NO",
          () {
            Navigator.of(context).pop(false);
          },
        )
      ],
    );
  }
}
