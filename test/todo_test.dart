import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:productive_ramadan_app/utils/todo.dart';

void main() {
  testWidgets("Initializes with empty list", (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );

    //expect(find.text("0"), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text("3"), findsOneWidget);
  });
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    List<Todo> todos = useProvider(filteredTodos);
    return MaterialApp(
      home: ElevatedButton(
        onPressed: () => context.read(filteredTodos),
        child: Text("${todos.length}"),
      ),
    );
  }
}
