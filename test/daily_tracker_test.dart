import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:productive_ramadan_app/controllers/task_controller.dart';
import 'package:productive_ramadan_app/controllers/task_state.dart';
import 'package:productive_ramadan_app/models/daily_tasks_model.dart';

void main() {
  test("Initializes four daily tasks", () {
    final taskState = useProvider(taskControllerProvider.state);
    TaskState state;
    state = taskState;
    List<DailyTaskModel> tasks;

    expect(tasks.length, 4);
  });
}
