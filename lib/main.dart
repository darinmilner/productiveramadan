import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:productive_ramadan_app/landing.dart';
import 'package:productive_ramadan_app/repositories/sharedpreferences.dart';
import 'package:productive_ramadan_app/splash_screen.dart';
import 'package:productive_ramadan_app/utils/page_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum appState { isLoading, loaded }
var appStarted;
void main() async {
  appStarted = appState.isLoading;
  WidgetsFlutterBinding.ensureInitialized();

  await sharedPrefs.init();

  runApp(
    ProviderScope(child: MyApp()),
  );
  Timer(Duration(seconds: 3), () {
    print("App Is Showing Splash Screen");
  });
  appStarted = appState.loaded;
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
      home: appStarted == appState.isLoading ? SplashScreen() : LandingPage(),
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
