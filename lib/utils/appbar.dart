import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../landing.dart';

class MyAppBar extends StatelessWidget {
  //List<Todo> todos = useProvider(filteredTodos);
  AppBar buildAppBar(context) {
    return AppBar(
      title: Center(
        child: Text(
          "Productive Ramadan",
          style: TextStyle(fontSize: 25.0, color: Colors.amberAccent),
        ),
      ),
      actions: [
        IconButton(
            icon: Icon(FontAwesomeIcons.home),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(LandingPage.routeName);
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
    );
  }
}
