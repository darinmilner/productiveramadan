import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:productive_ramadan_app/repositories/sharedpreferences.dart';
import 'package:productive_ramadan_app/utils/todo.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';

class ToolBar extends HookWidget {
  ToolBar({
    Key key,
  }) : super(key: key);

  Button button = Button();
  static bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final filter = useProvider(todoListFilter);
    final search = useProvider(todoListSearch);

    Color textColorFor(TodoListfilter value) {
      return filter.state == value ? Colors.blue : null;
    }

    void filterUncompletedGoals() => filter.state = TodoListfilter.active;

    void filterCompletedGoals() => filter.state = TodoListfilter.completed;

    void allGoals() => filter.state = TodoListfilter.all;

    int numTasks = useProvider(uncompletedTodosCount);

    int loadingRemainingTasks;

    int loadRemainingTasksCount() {
      loadingRemainingTasks = SharedPrefs.getRemainingGoalsAmt();
      print("Remainding tasks from shared prefs $loadingRemainingTasks");
      return loadingRemainingTasks;
    }

    loadingRemainingTasks = loadRemainingTasksCount();
    return Material(
      child: Container(
        color: Colors.teal[200],
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: isLoading
                        ? Text(
                            "${loadingRemainingTasks.toString()} items left",
                            style: TextStyle(color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(
                            "${numTasks.toString()} items left",
                            style: TextStyle(color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                  //Search bar
                  // Expanded(
                  //   child: TextField(
                  //       controller: searchController,
                  //       decoration: const InputDecoration(
                  //         labelText: "SEARCH",
                  //         labelStyle: TextStyle(color: Colors.black87),
                  //         border: InputBorder.none,
                  //         icon: Icon(
                  //           Icons.search,
                  //           color: Colors.black87,
                  //         ),
                  //       ),
                  //       onChanged: (value) {
                  //         isLoading = false;
                  //         search.state = value;
                  //       }),
                  // ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  message: "Only Uncompleted Goals",
                  child: button.buildButton(Colors.redAccent, Colors.black,
                      "Active", filterUncompletedGoals),
                ),
                Tooltip(
                  message: "Only Completed Goals",
                  child: button.buildButton(Colors.greenAccent, Colors.black,
                      "Completed", filterCompletedGoals),
                ),
                Tooltip(
                  message: "All Goals",
                  child: button.buildButton(
                      Colors.purpleAccent, Colors.black, "All Goals", allGoals),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
