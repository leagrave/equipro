import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/widgets/form/signUpFormWidget.dart';

void main() {
  testWidgets('SignUpFormWidget affiche les champs principaux', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SignUpFormWidget(
            openWithSignUp: true,
            enSaisie: true,
          ),
        ),
      ),
    );

    // Vérifie la présence des champs obligatoires
    expect(find.widgetWithText(TextField, 'Nom *'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Prénom *'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'E-mail *'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Mot de passe *'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Confirmation mot de passe'), findsOneWidget);

    // Vérifie la présence du sélecteur de rôle
    expect(find.byType(DropdownButtonFormField<bool>), findsOneWidget);
  });
}