import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';

class AlertBox extends StatelessWidget {
  Button button = Button();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Warning"),
      content: Text("Are you sure you want to delete this task"),
      actions: [
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
