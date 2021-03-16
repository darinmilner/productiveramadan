import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GlowingButton extends HookWidget {
  final Color color1;
  final Color color2;
  final Function onPressed;
  final String text;

  GlowingButton({
    Key key,
    this.color1 = Colors.tealAccent,
    this.color2 = Colors.teal,
    this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: 500);
    final buttonAnimation = useAnimationController(
      lowerBound: 0.0,
      upperBound: 10.5,
      duration: duration,
    )..animateTo(10.0, duration: duration, curve: Curves.bounceIn);
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        // transform: Matrix4.identity()..scale(0.9),
        curve: Curves.bounceIn,
        duration: duration,
        height: 50,
        width: MediaQuery.of(context).size.width * 0.6,
        // margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          gradient: LinearGradient(
            colors: [
              color1,
              color2,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color1.withOpacity(0.7),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(-8, 5.0),
            ),
            BoxShadow(
              color: color2.withOpacity(0.7),
              spreadRadius: 2,
              blurRadius: 15,
              offset: Offset(-10.0, 5.0),
            ),
            BoxShadow(
              color: color2.withOpacity(0.7),
              spreadRadius: 2,
              blurRadius: 15,
              offset: Offset(10.0, -5.0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.check,
            //   color: Colors.white,
            // ),
            Container(
              width: MediaQuery.of(context).size.width / 10,
            ),
            Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
