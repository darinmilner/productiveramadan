import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:productive_ramadan_app/landing.dart';
import 'package:productive_ramadan_app/repositories/sharedpreferences.dart';
import 'package:productive_ramadan_app/controllers/splash_screen.dart';
import 'package:productive_ramadan_app/utils/router/page_router.dart';

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
  final String title = "Productive Ramadan";

  @override
  Widget build(BuildContext context) {
    // _showNotification();
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal[500],
        accentColor: Colors.pink[700],
        brightness: Brightness.dark,
      ),
      //home: TodoHome(),
      home: appStarted == appState.isLoading ? SplashScreen() : LandingPage(),
      onGenerateRoute: PageRouter.generateRoute,
    );
  }
}
