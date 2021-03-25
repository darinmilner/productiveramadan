import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/landing.dart';
import 'package:productive_ramadan_app/models/quiz_brain.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';

import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/buttons/glowing_button.dart';
import 'package:productive_ramadan_app/utils/side_drawer.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();
int score = 0;

class Quiz extends StatelessWidget {
  static const quizPageRoute = "/quizpage";

  MyAppBar _appBar = MyAppBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar.buildAppBar(context),
      drawer: SideDrawer(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: QuizPage(),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  List<Icon> scoreKeeper2 = [];
  int questionNumber = 0;

  void _gameOver() {
    print("Quiz over");
    setState(() {
      scoreKeeper = [];
      scoreKeeper2 = [];
    });
    print("Alert BTN Score $score");
    score = 0;
    quizBrain.restartGame();
  }

  // Alert with single button.
  _showAlert(context) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Quiz Finished",
      desc: "Score: ${score}",
      style: AlertStyle(
        backgroundColor: kGreenishTeal,
        overlayColor: kGreenishTeal,
      ),
      buttons: [
        DialogButton(
          color: kDarkOrangeRed,
          splashColor: kDarkOrangeRed,
          highlightColor: Colors.red,
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            "TRY AGAIN",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            _gameOver();
          },
          width: 120,
        ),
        DialogButton(
          color: kDarkOrangeRed,
          splashColor: kDarkOrangeRed,
          highlightColor: Colors.red,
          child: Text(
            "HOME",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(LandingPage.routeName);
          },
          width: 120,
        ),
      ],
    ).show();
  }

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getQuestionAnswer();
    bool isFinished = quizBrain.isFinished();

    if (isFinished) {
      _showAlert(context);
    }
    setState(() {
      if (userPickedAnswer == correctAnswer) {
        print("Got it right");
        print("Game Score ${score}");

        score++;
        if (questionNumber <= 11) {
          questionNumber++;
          print(questionNumber);
          scoreKeeper2.add(
            Icon(Icons.check, color: kDarkGreen, size: 30.0),
          );
        } else {
          questionNumber++;
          scoreKeeper.add(
            Icon(
              Icons.check,
              color: kDarkGreen,
              size: 30.0,
            ),
          );
        }
      } else {
        print("User got it wrong");

        if (questionNumber <= 11) {
          questionNumber++;
          scoreKeeper2.add(
            Icon(Icons.clear, color: Colors.red, size: 30.0),
          );
        } else {
          questionNumber++;
          scoreKeeper.add(
            Icon(Icons.clear, color: Colors.red, size: 30.0),
          );
        }
      }
      quizBrain.nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: kBackgroundGreenGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  quizBrain.getQuestionTest(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: kDarkPurple,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: GlowingButton(
              color1: Colors.indigoAccent,
              color2: kPurple,
              text: "TRUE",
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: GlowingButton(
              color1: kDarkOrangeRed,
              color2: kLightOrange,
              text: "FALSE",
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
          Column(
            children: [
              Row(
                children: scoreKeeper,
              ),
              Row(
                children: scoreKeeper2,
              )
            ],
          ),
        ],
      ),
    );
  }
}
