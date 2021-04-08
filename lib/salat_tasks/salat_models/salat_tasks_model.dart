import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DailySalatModel extends Equatable {
  final String task;
  final String salatName;
  bool isComplete;

  static final List<DailySalatModel> salatTasks = [
    DailySalatModel(
      task: "Read Quran in Arabic, clear and slow",
      salatName: "Fjar",
      isComplete: false,
    ),
    DailySalatModel(
        task: "Read translation of Fajr verses in your native language",
        salatName: "Duhur",
        isComplete: false),
    DailySalatModel(
        task: "Read tafsir(Ibn Kathir) to understand the verses better",
        salatName: "Asr",
        isComplete: false),
    DailySalatModel(
        task: "Talk to someone about the verses and apply in your daily life",
        salatName: "Maghrib",
        isComplete: false),
    DailySalatModel(
        task:
            "Listen to a lecture about that surah or verse (or use in tahajjud)",
        salatName: "Isha",
        isComplete: false),
  ];

  DailySalatModel({
    @required this.task,
    @required this.salatName,
    this.isComplete = false,
  });

  @override
  List<Object> get props => [
        task,
        salatName,
        isComplete,
        salatTasks,
      ];

  // factory DailySalatModel.fromMap(Map<String, dynamic> map) {
  //   if (map == null) return null;
  //   return DailySalatModel(
  //       task: map["task"] ?? "",
  //       salatName: map["salatName"] ?? "",
  //       isComplete: map["isComplete"] ?? "",
  //       salatTasks: List<String>.from(map["allPossibleAnswers"] ?? [])
  //         ..add(map["correctTaskAnswer"] ?? ""));
  // }
}
