import 'package:flutter/material.dart';
import 'package:productive_ramadan_app/utils/constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kDarkGreen, kDarkTeal],
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              "ProductiveRamadanLogo1.png",
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 150, vertical: 300),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.2,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
