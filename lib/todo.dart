import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:productive_ramadan_app/controllers/database_helper.dart';
import 'package:productive_ramadan_app/repositories/todo_goals_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:state_notifier/state_notifier.dart';

var _uuid = Uuid();

class Todo {
  String id;
  String description;
  bool completed;
  bool isDeleted;
  int newId = 0;

  Todo({this.description, this.completed = false, this.isDeleted = false, id})
      : id = id ?? _uuid.v4();

  Todo.fromJson(Map<String, dynamic> json) {
    this.id = json[DatabaseHelper.id].toString();
    this.description = json[DatabaseHelper.columName];
    this.completed = json[DatabaseHelper.isComplete] == 1;
    this.isDeleted = json[DatabaseHelper.isDeleted] == 1;
  }

  String incrementID() {
    var rand = new Random();
    newId = rand.nextInt(100000);
    String id = newId.toString();
    print("new todo goal id: $id");
    return id;
  }

  @override
  String toString() {
    return "Todo(description: $description, completed: $completed)";
  }
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo> initialTodoState]) : super(initialTodoState ?? []);

  Todo todo = Todo();
  void add(String description, String id) {
    //id = todo.incrementID();
    state = [
      ...state,
      Todo(description: description, id: id),
    ];
    RepositoryServiceTodoGoals.addTodoGoal(
      Todo(description: description, id: id),
    );
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            description: todo.description,
          )
        else
          todo,
    ];
  }

  void edit({@required String id, @required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: todo.completed,
            description: description,
          )
        else
          todo,
    ];
  }

  void remove(Todo target) {
    state = state.where((todo) {
      return todo.id != target.id;
    }).toList();
  }
}

final getTodosFromDB = FutureProvider.autoDispose((ref) async {
  RepositoryServiceTodoGoals _repositoryServiceTodoGoals =
      RepositoryServiceTodoGoals();

  var tasks = await _repositoryServiceTodoGoals.getAllTodoGoals();
  print("TodoList tasks from db $tasks");
  // for (int i = 0; i < tasks.length; i++) {
  //   return TodoList([
  //     Todo(
  //       description: tasks[i].description,
  //     ),
  //   ]);
  // }
  return tasks;
});

//Can move to own file--global variable
final todoListProvider = StateNotifierProvider<TodoList>((ref) {
  return TodoList([
    // Todo(
    //   id: "100000",
    //   description: "Recite Quran 20 minutes everyday",
    // ),
    // Todo(id: "100001", description: "Suhor and Iftar with family and friends"),
    // Todo(id: "100002", description: "Listen to Islamic dars or short halaqah"),
  ]);
});

//Ways to filter the todos goal lists
enum TodoListfilter {
  all,
  active,
  completed,
}

//Current active filter
final todoListFilter = StateProvider((_) => TodoListfilter.all);
final todoListSearch = StateProvider((_) => "");

final uncompletedTodosCount = Provider<int>((read) {
  return read
      .watch(todoListProvider.state)
      .where((todo) => !todo.completed)
      .length;
});

final filteredTodos = Provider<List<Todo>>((read) {
  final filter = read.watch(todoListFilter);
  final search = read.watch(todoListSearch);
  final todos = read.watch(todoListProvider.state);

  List<Todo> filteredTodos;

  switch (filter.state) {
    case TodoListfilter.completed:
      filteredTodos = todos.where((todo) => todo.completed).toList();
      break;
    case TodoListfilter.active:
      filteredTodos = todos.where((todo) => !todo.completed).toList();
      break;
    case TodoListfilter.all:
    default:
      filteredTodos = todos;
      break;
  }

  if (search.state.isEmpty) {
    return filteredTodos;
  } else {
    return filteredTodos
        .where((todo) => todo.description.contains(search.state))
        .toList();
  }
});
