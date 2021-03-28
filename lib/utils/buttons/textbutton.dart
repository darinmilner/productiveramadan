import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/repositories/islamic_quiz.dart';

QuizPage quizPage = QuizPage();
Widget buildTextButton(Color primaryColor, Color backgroundColor, String text,
    bool isTrue, Function onPressed) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      primary: primaryColor,
      backgroundColor: backgroundColor,
      // backgroundColor: Colors.teal,
      shadowColor: Colors.blueAccent,
    ),
    child: Text(
      text,
      style: TextStyle(color: primaryColor, fontSize: 20.0),
    ),
  );
}
