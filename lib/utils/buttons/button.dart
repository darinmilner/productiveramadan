import 'package:flutter/material.dart';

class Button {
  Widget buildButton(
    Color primaryColor,
    Color textColor,
    String text,
    Function onPressedFunc,
  ) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryColor),
        foregroundColor: MaterialStateProperty.all(textColor),
      ),
      // style: ElevatedButton.styleFrom(
      //   primary: primaryColor, // background
      //   onPrimary: textColor, // foreground
      // ),
      autofocus: true,
      onPressed: onPressedFunc,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
          fontFamily: "Syne",
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}
