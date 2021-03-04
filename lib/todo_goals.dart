import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:productive_ramadan_app/todo.dart';
import 'package:productive_ramadan_app/utils/alertbox.dart';
import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/side_drawer.dart';
import 'package:productive_ramadan_app/utils/toolbar.dart';

class TodoHome extends HookWidget {
  TodoHome({Key key}) : super(key: key);
  ToolBar toolbar = ToolBar();

  static const routeName = "/todogoals";

  @override
  Widget build(BuildContext context) {
    final newTodoController = useTextEditingController();
    final todos = useProvider(filteredTodos);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Productive Ramadan",
            style: TextStyle(fontSize: 25.0),
          ),
        ),
      ),
      drawer: SideDrawer(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            children: [
              Title(),
              TextField(
                controller: newTodoController,
                decoration: const InputDecoration(
                  labelText: "Input a Ramadan Goal",
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onSubmitted: (value) {
                  context.read(todoListProvider).add(value);
                  newTodoController.clear();
                  print("submitted ${value}");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ToolBar(),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  if (todos.isNotEmpty) const Divider(height: 10),
                  for (var i = 0; i < todos.length; i++) ...[
                    if (i > 0) const Divider(height: 10),
                    Dismissible(
                      key: ValueKey(todos[i].id),
                      child: Container(
                        color: Theme.of(context).accentColor,
                        child: TodoItem(todos[i]),
                      ),
                      // onDismissed: (_) {
                      //   context.read(todoListProvider).remove(todos[i]);
                      // },
                      confirmDismiss: (dir) async {
                        final result = await showDialog(
                          context: context,
                          builder: (_) => AlertBox(),
                        );
                        context.read(todoListProvider).remove(todos[i]);
                        print(result);
                        return result;
                      },
                      background: Container(
                        color: kDarkPink,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key key}) : super(key: key);
  static const double _size = 25;
  //final todos = useProvider(filteredTodos);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Ramadan Tasks",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: _size,
            fontWeight: FontWeight.w500,
            color: Colors.green,
          ),
        ),
        Icon(
          Icons.check,
          size: _size,
          color: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}

class TodoItem extends HookWidget {
  TodoItem(this.todo, {Key key}) : super(key: key);
  final Todo todo;
  // final todos = useProvider(filteredTodos);
  @override
  Widget build(BuildContext context) {
    final itemFocusNode = useFocusNode();
    useListenable(itemFocusNode);
    final isFocused = itemFocusNode.hasFocus;

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Material(
        color: Colors.white,
        elevation: 3,
        child: Focus(
          focusNode: itemFocusNode,
          onFocusChange: (focused) {
            if (focused) {
              textEditingController.text = todo.description;
              print(textEditingController.text);
            } else {
              context.read(todoListProvider).edit(
                    id: todo.id,
                    description: textEditingController.text,
                  );
            }
          },
          child: Container(
            color: Colors.grey,
            child: ListTile(
              onTap: () {
                itemFocusNode.requestFocus();
                textFieldFocusNode.requestFocus();
              },
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Checkbox(
                    value: todo.completed,
                    tristate: true,
                    activeColor: Theme.of(context).accentColor,
                    checkColor: Theme.of(context).primaryColor,
                    onChanged: (value) =>
                        context.read(todoListProvider).toggle(todo.id),
                  ),
                ),
              ),
              title: isFocused
                  ? TextField(
                      autofocus: true,
                      focusNode: textFieldFocusNode,
                      controller: textEditingController,
                    )
                  : Text(
                      todo.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
