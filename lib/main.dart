import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:productive_ramadan_app/landing.dart';
import 'package:productive_ramadan_app/todo.dart';
import 'package:productive_ramadan_app/utils/page_router.dart';
import 'package:productive_ramadan_app/utils/toolbar.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  String title = 'Productive Ramadan';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal[500],
        accentColor: Colors.pink[700],
        // scaffoldBackgroundColor: Colors.teal[900],
        brightness: Brightness.dark,
      ),
      //home: TodoHome(),
      home: LandingPage(),
      onGenerateRoute: PageRouter.generateRoute,
    );
  }
}

final valueProvider = Provider<int>((ref) {
  return 30;
});

class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    int count = useProvider(valueProvider);
    return Scaffold(
      body: Center(
        child: Text("$count"),
      ),
    );
  }
}
