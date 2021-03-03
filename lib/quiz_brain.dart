import 'package:productive_ramadan_app/question.dart';

class QuizBrain {
  int _questionNumber = 0;
  List<Question> _quizQuestions = [
    Question(q: "There are 115 surahs in the Quran", a: false),
    Question(q: "Ayatul Kursi is Surah Baqarah :255", a: true),
    Question(q: "Surah Iklas describes the uniqueness of Allah", a: true),
    Question(q: "Surah AlFatiha is the last surah ", a: false),
    Question(
        q: "Omar ibn Khatib compiled the Quran into a single book", a: true),
    Question(q: "Surah Qadr is about Laylatul Qadr in Ramadan", a: true),
    Question(q: "Surah Alimran is the longest surah in the Quran", a: false),
    Question(q: "Surah AlKawthar is the shortest surah in the Quran", a: true),
    Question(q: "The Quran is the most memorized book in the world", a: true),
  ];

  void nextQuestion() {
    if (_questionNumber < _quizQuestions.length - 1) {
      _questionNumber++;
      print(_questionNumber);
    }
  }

  String getQuestionTest() {
    return _quizQuestions[_questionNumber].questionText;
  }

  bool getQuestionAnswer() {
    return _quizQuestions[_questionNumber].questionAnswer;
  }

  bool isFinished() {
    if (_questionNumber < _quizQuestions.length - 1) {
      return false;
    } else {
      return true;
    }
  }

  void restartGame() {
    _questionNumber = 0;
  }
}
