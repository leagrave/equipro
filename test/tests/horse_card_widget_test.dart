import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/widgets/card/horse/horseCardWidget.dart';
import 'package:equipro/src/models/horse.dart';

void main() {
  testWidgets('HorseCardWidget affiche et modifie les champs principaux', (WidgetTester tester) async {
    // Création d'un cheval de test
    final horse = Horse(
      id: 'h1',
      name: 'Spirit',
      age: 5,
      breeds: [],
      colors: [],
      feedTypes: [],
      activityTypes: [],
      lastVisitDate: null,
      nextVisitDate: null,
    );

    Horse? updatedHorse;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HorseCardWidget(
            horse: horse,
            openWithCreateHorsePage: true,
            isEditing: true,
            onHorseUpdated: (h) => updatedHorse = h,
          ),
        ),
      ),
    );

    // Vérifie la présence du champ "Nom"
    expect(find.widgetWithText(TextField, 'Nom'), findsOneWidget);

    // Modifie le champ "Nom"
    await tester.enterText(find.widgetWithText(TextField, 'Nom'), 'Tornado');
    await tester.pumpAndSettle();

    // Vérifie que le callback onHorseUpdated a été appelé avec la nouvelle valeur
    expect(updatedHorse?.name, 'Tornado');
  });
}