import 'package:flutter_test/flutter_test.dart';
import 'package:productive_ramadan_app/repositories/todo_goals_repository.dart';
import 'package:productive_ramadan_app/utils/todo.dart';

class MockTodoGoalRepository implements RepositoryServiceTodoGoals {
  Future<List<Todo>> getAllTodoGoals() async {
    //connect to DB
    return Future.value([
      Todo(
          id: 1, description: "Read Quran", isDeleted: false, completed: false),
      Todo(id: 2, description: "Fix App", isDeleted: false, completed: false)
    ]);
  }

  @override
  Future<Todo> getTodoGoal(int id) {
    return Future.value(
      Todo(
          id: id,
          description: "Read Quran",
          isDeleted: false,
          completed: false),
    );
  }
}

void main() {
  testWidgets('Returns todo tasks', (tester) async {
    MockTodoGoalRepository mTodoRepo = MockTodoGoalRepository();
  });
}
