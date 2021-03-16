import 'package:hooks_riverpod/all.dart';
import 'package:productive_ramadan_app/controllers/database_helper.dart';
import 'package:productive_ramadan_app/todo.dart';
import 'package:sqflite/sqflite.dart';

final todoGoalsFromDBRepositoryProvider =
    Provider((ref) => RepositoryServiceTodoGoals());

final todoGoalsProvider = FutureProvider<List<Todo>>((ref) async {
  final repository = await ref.watch(todoGoalsFromDBRepositoryProvider);
  return await repository.getAllTodoGoals();
});

class RepositoryServiceTodoGoals {
  Future<List<Todo>> getAllTodoGoals() async {
    Database db = await DatabaseHelper.instance.database;
    final sql = '''SELECT * FROM ${DatabaseHelper.tableName} 
    WHERE ${DatabaseHelper.isDeleted} = 0
    ''';
    final data = await db.rawQuery(sql);
    List<Todo> todoGoals = [];
    for (final node in data) {
      final todoGoal = Todo.fromJson(node);
      todoGoals.add(todoGoal);
    }
    return todoGoals;
  }

  Future<Todo> getTodoGoal(int id) async {
    Database db = await DatabaseHelper.instance.database;
    String stringId = id.toString();
    final sql = '''SELECT * FROM ${DatabaseHelper.tableName}
    WHERE ${DatabaseHelper.id} = ?
     ''';
    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    final todoGoal = Todo.fromJson(data[0]);

    return todoGoal;
  }

  static Future<void> addTodoGoal(Todo goal) async {
    int newId = int.parse(goal.id);
    print(goal.id);
    Database db = await DatabaseHelper.instance.database;
    final sql = '''INSERT INTO ${DatabaseHelper.tableName}
    (
      ${DatabaseHelper.id},
      ${DatabaseHelper.columName},
      ${DatabaseHelper.isComplete},
      ${DatabaseHelper.isDeleted}
    )
    VALUES (?,?,?,?)''';

    List<dynamic> params = [
      //goal.id,
      newId,
      goal.description,
      goal.completed ? 1 : 0,
      goal.isDeleted ? 1 : 0
    ];
    final result = await db.rawInsert(sql, params);
    DatabaseHelper.instance
        .databaseLog("addTodoGoal", sql, null, result, params);
  }

  static Future<void> deleteTodoGoal(Todo goal) async {
    Database db = await DatabaseHelper.instance.database;
    final sql = '''UPDATE ${DatabaseHelper.tableName}
    SET ${DatabaseHelper.isDeleted} =1
    WHERE ${DatabaseHelper.id} = ?
     ''';

    int goalId = int.parse(goal.id);
    List<dynamic> params = [goalId];
    final result = await db.rawInsert(sql, params);
    DatabaseHelper.instance
        .databaseLog("addTodoGoal", sql, null, result, params);
  }

  static Future<void> updateTodoGoal(Todo goal) async {
    Database db = await DatabaseHelper.instance.database;
    print("update Goal Func ${goal.description}");
    final sql = '''UPDATE ${DatabaseHelper.tableName}
    SET ${DatabaseHelper.columName} = ?
    WHERE ${DatabaseHelper.id} = ?
    ''';

    int goalId = int.parse(goal.id);
    List<dynamic> params = [
      goal.description,
      goalId,
    ];
    final result = await db.rawInsert(sql, params);
    DatabaseHelper.instance
        .databaseLog("addTodoGoal", sql, null, result, params);
  }

  static Future<int> getGoalsCount() async {
    Database db = await DatabaseHelper.instance.database;
    final data = await db
        .rawQuery('''SELECT COUNT(*) FROM ${DatabaseHelper.tableName}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }
}
