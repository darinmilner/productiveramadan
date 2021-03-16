import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:productive_ramadan_app/utils/buttons/glowing_button.dart';
import 'package:productive_ramadan_app/utils/constants.dart';

class LoginPage extends HookWidget {
  static const String loginPageRoute = "/login";

  @override
  Widget build(BuildContext context) {
    var _loginTextController = useTextEditingController();
    var _passwordTextController = useTextEditingController();
    var _textBoxSize = MediaQuery.of(context).size.width >= 500
        ? 300.0
        : MediaQuery.of(context).size.width * 0.80;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PRODUCTIVE RAMADAN",
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
                bottom: 10.0,
              ),
              child: Text(
                "LOGIN",
                style: kLandingPageTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Container(
                  width: _textBoxSize,
                  child: TextField(
                    controller: _loginTextController,
                    decoration: InputDecoration(
                      labelText: "USERNAME",
                      hintText: "Enter your username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelStyle: TextStyle(color: kGreenishTeal),
                    ),
                    onSubmitted: (val) {
                      print(_loginTextController.text);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: _textBoxSize,
                child: TextField(
                  controller: _passwordTextController,
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: kLightOrange,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText: "PASSWORD",
                    hintText: "Enter your password",
                    labelStyle: TextStyle(
                      color: kGreenishTeal,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GlowingButton(
              onPressed: () {
                print("LOGIN");
              },
              text: "LOGIN",
            )
          ],
        ),
      ),
    );
  }
}
