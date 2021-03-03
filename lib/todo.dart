import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:state_notifier/state_notifier.dart';

var _uuid = Uuid();

class Todo {
  final String id;
  final String description;
  final bool completed;
  Todo({this.description, this.completed = false, String id})
      : id = id ?? _uuid.v4();

  @override
  String toString() {
    return "Todo(description: $description, completed: $completed)";
  }
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo> initialTodoState]) : super(initialTodoState ?? []);

  void add(String description) {
    state = [
      ...state,
      Todo(description: description),
    ];
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
    state = state.where((todo) => todo.id != target.id).toList();
  }
}

//Can move to own file--global variable
final todoListProvider = StateNotifierProvider<TodoList>((ref) {
  return TodoList([
    Todo(
        id: "todo-0",
        description:
            "قُلْ هُوَ اللّٰهُ اَحَدٌۚ - Recite Quran 20 minutes everyday"),
    Todo(id: "todo-1", description: "Suhor and Iftar with family and friends"),
    Todo(id: "todo-2", description: "Listen to Islamic dars or short halaqah"),
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
