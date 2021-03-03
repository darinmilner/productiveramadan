import 'package:flutter/material.dart';

class Button {
  Widget buildButton(
    Color primaryColor,
    Color textColor,
    String text,
    Function onPressedFunc,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: primaryColor, // background
        onPrimary: textColor, // foreground
        textStyle: TextStyle(fontSize: 15.0),
        shadowColor: Colors.green[800],
      ),
      autofocus: true,
      onPressed: onPressedFunc,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
