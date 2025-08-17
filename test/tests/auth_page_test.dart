import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:equipro/src/pages/login.dart';
import 'package:flutter/material.dart';

void main() {
  final mockClient = MockClient((request) async {
    final body = jsonDecode(request.body);
    if (body['email'] == 'test@example.com' && body['password'] == 'password123') {
      return http.Response(jsonEncode({'token': 'fake_token', 'user': {}}), 200);
    } else {
      return http.Response(jsonEncode({'error': 'Invalid credentials'}), 401);
    }
  });

  testWidgets('login success with mock api', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyLoginPage(httpClient: mockClient),
      ),
    );

    await tester.enterText(find.byKey(Key('emailField')), 'test@example.com');
    await tester.enterText(find.byKey(Key('passwordField')), 'password123');
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pump();  
    await tester.pumpAndSettle();

    expect(find.text('Email et mot de passe requis'), findsNothing);
    expect(find.text('Invalid credentials'), findsNothing);
  });

  testWidgets('login fails with wrong password', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyLoginPage(httpClient: mockClient),
      ),
    );

    await tester.enterText(find.byKey(Key('emailField')), 'test@example.com');
    await tester.enterText(find.byKey(Key('passwordField')), 'wrongpassword');
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pump();  
    await tester.pumpAndSettle();

    expect(find.byKey(Key('errorMessage')), findsOneWidget);

  });

  testWidgets('login fails with wrong email', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyLoginPage(httpClient: mockClient),
      ),
    );

    await tester.enterText(find.byKey(Key('emailField')), 'wrong@example.com');
    await tester.enterText(find.byKey(Key('passwordField')), 'password123');
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pump();  
    await tester.pumpAndSettle();

    expect(find.byKey(Key('errorMessage')), findsOneWidget);

  });
}
