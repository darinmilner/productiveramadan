import 'package:productive_ramadan_app/models/question.dart';

class QuizBrain {
  int _questionNumber = 0;
  List<Question> _quizQuestions = [
    Question(q: "There are 115 surahs in the Quran.", a: false),
    Question(q: "Ayatul Kursi is Surah Baqarah :255.", a: true),
    Question(q: "Surah Iklas describes the uniqueness of Allah", a: true),
    Question(q: "Surah AlFatiha is the last surah ", a: false),
    Question(
        q: "Omar ibn Khatib compiled the Quran into a single book", a: true),
    Question(q: "Surah Qadr is about Laylatul Qadr in Ramadan", a: true),
    Question(q: "Surah Alimran is the longest surah in the Quran", a: false),
    Question(q: "Surah AlKawthar is the shortest surah in the Quran", a: true),
    Question(q: "The Quran is the most memorized book in the world", a: true),
    Question(
        q: "Fasting during the few days right before Ramadan is recommended for Muslims",
        a: false),
    Question(q: "Juz Amma is the last juz of the Quran.", a: true),
    Question(q: "Muslims fast in Ramadan from sunrise to sunset.", a: false),
    Question(q: "Ayah of fasting is in Surah Albaqarah.", a: true),
    Question(
        q: "The five pillars of Islam are shahada, fasting, salat, zakaat and hajj.",
        a: true),
    Question(q: "Asr prayer in Ramadan will remove all of our sins.", a: false),
    Question(q: "Sunnah prayers are best prayed in the mesjid.", a: false),
    Question(q: "It is acceptable to fast for a dead relative.", a: true),
    Question(
        q: "We practice itikaaf in Ramadan during the last 10 nights", a: true),
    Question(
        q: "Allah might not accept the fast of someone who makes evil or false speech while fasting.",
        a: true),
    Question(
        q: "The smell of dates at iftar is more pleasing to Allah then musk.",
        a: false),
    Question(q: "It is ok to touch ones wife when fasting.", a: true),
    Question(
        q: "If we eat or drink by accident or forgetfulness when fasting our fast is broken.",
        a: false),
    Question(
        q: "It is haram to break ones fast while traveling in Ramadan.",
        a: false),
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
