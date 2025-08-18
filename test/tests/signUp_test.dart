import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/pages/signUp.dart';
import 'package:equipro/src/widgets/form/signUpFormWidget.dart';

void main() {
  testWidgets('MySignupPage affiche les éléments principaux', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MySignupPage(),
      ),
    );

    // Vérifie la présence du logo
    expect(find.byType(CircleAvatar), findsOneWidget);

    // Vérifie la présence du titre
    expect(find.text('Bienvenue sur EquiPro'), findsOneWidget);

    // Vérifie la présence du sous-titre
    expect(find.text('Créez votre compte pour commencer'), findsOneWidget);

    // Vérifie la présence du formulaire d'inscription
    expect(find.byType(SignUpFormWidget), findsOneWidget);

    // Vérifie la présence du bouton "Créer un compte"
    expect(find.text('Créer un compte'), findsOneWidget);

    // Vérifie la présence du lien "Se connecter"
    expect(find.text('Se connecter'), findsOneWidget);
  });
}