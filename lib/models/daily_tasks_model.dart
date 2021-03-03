import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DailyTaskModel extends Equatable {
  final String task;
  final String correctTaskAnswer;
  final int dayNumber;
  final bool isComplete;

  final List<String> allPossibleAnswers;

  const DailyTaskModel({
    @required this.task,
    @required this.correctTaskAnswer,
    @required this.dayNumber,
    @required this.isComplete,
    @required this.allPossibleAnswers,
  });

  @override
  List<Object> get props => [
        task,
        correctTaskAnswer,
        dayNumber,
        isComplete,
        allPossibleAnswers,
      ];

  factory DailyTaskModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return DailyTaskModel(
      task: map["task"] ?? "",
      correctTaskAnswer: map["correctTaskAnswer"] ?? "",
      dayNumber: map["dayNumber"] ?? "",
      isComplete: map["isComplete"] ?? "",
      allPossibleAnswers: List<String>.from(map["allPossibleAnswers"] ?? [])
        ..add(map["correctTaskAnswer"] ?? "")
        ..shuffle(),
    );
  }
}
