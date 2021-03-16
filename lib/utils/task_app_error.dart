import 'package:flutter/material.dart';
import 'buttons/button.dart';
import 'package:productive_ramadan_app/ramadan_dailytasks_tracker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppError extends StatelessWidget {
  final String message;

  AppError({
    Key key,
    @required this.message,
  }) : super(key: key);
  final Button button = Button();

  @override
  Widget build(BuildContext context) {
    void onRetryButtonPressed() {
      context.refresh(taskTrackerProvider);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          button.buildButton(
            Colors.red,
            Colors.amberAccent,
            "Retry",
            onRetryButtonPressed,
          ),
        ],
      ),
    );
  }
}
