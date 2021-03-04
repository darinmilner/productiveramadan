import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../lib/landing.dart';

void main() {
  //Unit test
  testWidgets(" Daily Ramadan Tasks button has text", (tester) async {
    //Arrange
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: LandingPage(),
        ),
      ),
    );

    //Act
    final text = find.text("Daily Ramadan Tasks");

    //Assert
    expect(text, findsOneWidget);
  });

  testWidgets("Choose an option text exists", (tester) async {
    //Arrange
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: LandingPage(),
        ),
      ),
    );

    //Act
    final text = find.text("Choose an option");

    //Assert
    expect(text, findsOneWidget);
  });
}
