import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:productive_ramadan_app/screens/daily_tasks.dart';
import 'package:productive_ramadan_app/models/daily_tasks_model.dart';

enum TaskStatus { initial, correct, incorrect, complete }

class TaskState extends Equatable {
  final String selectedAnswer;
  final List<DailyTaskModel> correct;
  final List<DailyTaskModel> incorrect;
  final TaskStatus status;

  bool get answered =>
      status == TaskStatus.incorrect || status == TaskStatus.correct;

  const TaskState({
    @required this.selectedAnswer,
    @required this.correct,
    @required this.incorrect,
    @required this.status,
  });

  factory TaskState.initial() {
    return TaskState(
      selectedAnswer: '',
      correct: [],
      incorrect: [],
      status: TaskStatus.initial,
    );
  }

  @override
  List<Object> get props => [
        selectedAnswer,
        correct,
        incorrect,
        status,
      ];

  TaskState copyWith({
    String selectedAnswer,
    List<DailyTaskModel> correct,
    List<DailyTaskModel> incorrect,
    TaskStatus status,
  }) {
    return TaskState(
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,
      status: status ?? this.status,
    );
  }
}
