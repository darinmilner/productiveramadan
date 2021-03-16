import 'package:productive_ramadan_app/models/dailytasks_score_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;
  static const _keyScore = "score";
  static const _keyDay = "dayNumber";
  static const _keyHadithDay = "dayHadithNumber";
  static const _keyAyahDay = "dayAyahNumber";
  static const _keyDailyScores = "Daily Scores";
  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  static Future setScore(String score) async =>
      await _sharedPrefs.setString(_keyScore, score);

  static Future setDay(int day) async =>
      await _sharedPrefs.setInt(_keyDay, day);

  static Future setHadithDay(int day) async =>
      await _sharedPrefs.setInt(_keyHadithDay, day);

  static Future setAyahDay(int day) async =>
      await _sharedPrefs.setInt(_keyAyahDay, day);

  static String getScore() => _sharedPrefs.getString(_keyScore) ?? "";

  static int getDay() => _sharedPrefs.getInt(_keyDay) ?? 1;

  static int getHadithDay() => _sharedPrefs.getInt(_keyHadithDay) ?? 1;

  static int getAyahDay() => _sharedPrefs.getInt(_keyAyahDay) ?? 1;

  // static Future setNewDailyScore(List<String> newScore) async {
  //   await _sharedPrefs.setStringList(_keyDailyScores, newScore);
  // }
  //
  // static List<String> get getScoresList =>
  //     _sharedPrefs.getStringList(_keyDailyScores) ?? "";

  static String get todoGoal => _sharedPrefs.getString(kKeyTodoGoal) ?? "";
}

final sharedPrefs = SharedPrefs();

const String kKeyTodoGoal = "keyTodoGoal";