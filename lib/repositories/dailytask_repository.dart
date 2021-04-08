import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:productive_ramadan_app/models/daily_tasks_model.dart';
import 'package:productive_ramadan_app/models/failure_model.dart';
import 'package:productive_ramadan_app/repositories/base_dailytask_repository.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final taskRepositoryProvider = Provider<DailyTaskRepository>((ref) {
  return DailyTaskRepository(ref.read);
});

class DailyTaskRepository extends BaseDailyTaskRepository {
  final Reader _read;

  DailyTaskRepository(this._read);

  @override
  Future<List<DailyTaskModel>> getDailyTasks(
      {int numTasks, int taskId, int dayNumber}) async {
    try {
      final queryParameters = {
        "dayNumber": dayNumber,
        "amount": numTasks,
        "taskId": taskId,
      };

      // final response = await _read(dioProvider).get(
      //   "localhosturlhere",
      //   queryParameters: queryParameters,
      // );

      final response = dailyTasks["results"];

      if (response != null) {
        // if (response.statusCode == 200) {
        // final data = Map<String, dynamic>.from(response);   //(response.data);
        var results = List<Map<String, dynamic>>.from(
            dailyTasks["results"] ?? []); //(data["results"] ?? []);
        print(results);
        //results=  dailyTasks["results"];
        if (results.isNotEmpty) {
          return results.map((e) => DailyTaskModel.fromMap(e)).toList();
        }
      }
      return [];
    } on DioError catch (err) {
      print(err);
      throw Failure(message: err.response?.statusMessage);
    } on SocketException catch (err) {
      print(err);
      throw const Failure(message: "Check your internet connection.");
    }
  }

  var dailyTasks = {
    "results": [
      {
        "task": "Daily Salat and Tarawih?",
        "correctTaskAnswer":
            "Five Fardh Salat, extra rakaats of sunnah salat and tarawih.",
        "dayNumber": 1,
        "isComplete": false,
        "allPossibleAnswers": [
          "Five Fardh Salat only,",
          "Five Fardh Salat and extra rakaats of sunnah salat but no tarawih.",
          "Did not complete five Fardh Salat.",
        ],
      },
      {
        "task": "How many minutes of reading Quran?",
        "correctTaskAnswer": "Read Quran more than 20 minutes.",
        "dayNumber": 1,
        "isComplete": false,
        "allPossibleAnswers": [
          "Did not read Quran today",
          "Read Quran less than 10 minutes",
          "Read Quran 10 to 20minutes",
        ],
      },
      {
        "task": "Did you fast today?",
        "correctTaskAnswer": "I completed my fast",
        "dayNumber": 1,
        "isComplete": false,
        "allPossibleAnswers": [
          "Did not fast today",
          "Started to fast but broke it early",
          "Did not fast but have an excuse, I will make it up after Ramadan",
        ],
      },
      {
        "task": "What extra tasks did you do today?",
        "correctTaskAnswer": "Gave sadaqah or helped someone",
        "dayNumber": 1,
        "isComplete": false,
        "allPossibleAnswers": [
          "Fought with family members",
          "Slept all day",
          "Listened to music",
        ],
      }
    ],
  };
}
