import 'package:productive_ramadan_app/models/dailytasks_score_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;
  static const _keyScore = "score";
  static const _keyDay = "dayNumber";
  static const _keySalatTaskComplete0 = "isCompleteFjar";
  static const _keySalatTaskComplete1 = "isCompleteDuhur";
  static const _keySalatTaskComplete2 = "isCompleteAsr";
  static const _keySalatTaskComplete3 = "isCompleteMaghrib";
  static const _keySalatTaskComplete4 = "isCompleteIsha";
  static const _keySalatDay = "daySalatNumber";
  static const _keyRemainingGoals = "numRemainingGoals";

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  static Future setScore(String score) async =>
      await _sharedPrefs.setString(_keyScore, score);

  static Future setDay(int day) async =>
      await _sharedPrefs.setInt(_keyDay, day);

  static Future setSalatTaskFjar(bool isDone) async =>
      await _sharedPrefs.setBool(_keySalatTaskComplete0, isDone);
  static Future setSalatTaskDuhr(bool isDone) async =>
      await _sharedPrefs.setBool(_keySalatTaskComplete1, isDone);
  static Future setSalatTaskAsr(bool isDone) async =>
      await _sharedPrefs.setBool(_keySalatTaskComplete2, isDone);
  static Future setSalatTaskMaghrib(bool isDone) async =>
      await _sharedPrefs.setBool(_keySalatTaskComplete3, isDone);
  static Future setSalatTaskIsha(bool isDone) async =>
      await _sharedPrefs.setBool(_keySalatTaskComplete4, isDone);

  static Future setSalatDay(int day) async =>
      await _sharedPrefs.setInt(_keySalatDay, day);

  static Future setDailyGoalRemainingAmt(int numRemaining) async =>
      await _sharedPrefs.setInt(_keyRemainingGoals, numRemaining);

  static String getScore() => _sharedPrefs.getString(_keyScore) ?? "";

  static int getDay() => _sharedPrefs.getInt(_keyDay) ?? 1;

  static bool getSalatTaskCompleteFjar() =>
      _sharedPrefs.getBool(_keySalatTaskComplete0) ?? false;
  static bool getSalatTaskCompleteDuhr() =>
      _sharedPrefs.getBool(_keySalatTaskComplete1) ?? false;
  static bool getSalatTaskCompleteAsr() =>
      _sharedPrefs.getBool(_keySalatTaskComplete2) ?? false;
  static bool getSalatTaskCompleteMaghrib() =>
      _sharedPrefs.getBool(_keySalatTaskComplete3) ?? false;
  static bool getSalatTaskCompleteIsha() =>
      _sharedPrefs.getBool(_keySalatTaskComplete4) ?? false;

  static int getRemainingGoalsAmt() =>
      _sharedPrefs.getInt(_keyRemainingGoals) ?? 0;

  static String get todoGoal => _sharedPrefs.getString(kKeyTodoGoal) ?? "";

  static const String versionNum = "1.0.0";
}

final sharedPrefs = SharedPrefs();

const String kKeyTodoGoal = "keyTodoGoal";
