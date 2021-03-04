import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'dart:ui';

import 'landing.dart';

void main() {
  //Unit test
  testWidgets(
      "Given goToDailyTasks is called when Daily Ramadan Tasks button is clicked",
      (tester) async {
    //Arrange
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: LandingPage(),
        ),
      ),
    );
    final button = find.byType(Button);
    //Act
    await tester.tap(button);
    await tester.pump();

    //Assert
    expect(button, findsOneWidget);
  });
}
