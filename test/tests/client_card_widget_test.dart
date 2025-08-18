import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/widgets/card/client/clientCardWidget.dart';
import 'package:equipro/src/models/user.dart';

void main() {
  testWidgets('ClientCardWidget affiche et modifie les champs', (WidgetTester tester) async {
    // Création d'un utilisateur de test
    final user = Users(
      id: '1',
      lastName: 'Dupont',
      firstName: 'Jean',
      phone: '0600000000',
      phone2: '',
      email: 'jean.dupont@email.com',
      professional: false,
      isSociete: false,
      notes: '',
    );

    Users? updatedUser;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClientCardWidget(
            user: user,
            openWithCreateClientPage: true,
            openWithCreateHorsePage: false,
            onUserUpdated: (u) => updatedUser = u,
          ),
        ),
      ),
    );

    // Vérifie la présence des champs principaux
    expect(find.widgetWithText(TextFormField, 'Nom'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Prénom'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Téléphone'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);

    // Modifie le champ "Nom"
    await tester.enterText(find.widgetWithText(TextFormField, 'Nom'), 'Martin');
    await tester.pumpAndSettle();

    // Vérifie que le callback onUserUpdated a été appelé avec la nouvelle valeur
    expect(updatedUser?.lastName, 'Martin');
  });
}