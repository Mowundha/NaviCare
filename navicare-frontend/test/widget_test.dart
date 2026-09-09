// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessease/screens/edit_profile_screen.dart';
import 'package:accessease/screens/profile_screen.dart';

void main() {
  testWidgets('profile displays the edit control', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    await tester.pumpAndSettle();

    expect(find.text('User'), findsOneWidget);
    expect(find.byTooltip('Edit profile'), findsOneWidget);
  });

  testWidgets('edit profile form displays personal detail fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: EditProfileScreen(
        details: ProfileDetails(
          name: 'Aarav',
          email: 'aarav@example.com',
          phone: '+91 9876543210',
        ),
      ),
    ));

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
  });
}
