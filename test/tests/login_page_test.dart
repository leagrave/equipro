import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/pages/login.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('affiche message erreur si email ou mot de passe vide', (WidgetTester tester) async {
    // Monte la page
    await tester.pumpWidget(
      MaterialApp(
        home: MyLoginPage(),
      ),
    );

    // Cas où les deux champs sont vides
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pump(); // déclenche la mise à jour de l'UI

    expect(find.text('Email et mot de passe requis'), findsOneWidget);

    //Cas où email rempli mais mot de passe vide
    await tester.enterText(find.byKey(Key('emailField')), 'test@example.com');
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pump();

    expect(find.text('Email et mot de passe requis'), findsOneWidget);

    // Cas où mot de passe rempli mais email vide
    await tester.enterText(find.byKey(Key('emailField')), ''); 
    await tester.enterText(find.byKey(Key('passwordField')), 'password123');
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pump();

    expect(find.text('Email et mot de passe requis'), findsOneWidget);
  });
}