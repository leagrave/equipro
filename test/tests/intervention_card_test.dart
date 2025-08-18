import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/widgets/card/intervention/interventionCardWidget.dart';
import 'package:equipro/src/models/intervention.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/invoice.dart';
import 'package:equipro/src/models/observation.dart';

void main() {
  testWidgets('InterventionCardWidget affiche et modifie les champs principaux', (WidgetTester tester) async {
    final user = Users(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@email.com',
      professional: false,
    );
    final horse = Horse(id: 'h1', name: 'Spirit');
    final invoice = Invoice(
      id: 'inv1',
      number: '2024-001',
      title: 'Facture test',
      totalAmount: 100.0,
      user_id: '1',
      pro_id: '1',
    );
    final observation = Observation(
      id: 'obs1',
      observationName: 'Observation test',
    );

    final intervention = Intervention(
      id: 'int1',
      description: 'Test intervention',
      interventionDate: DateTime(2024, 1, 1),
      users: [user],
      horse: horse,
      pro: user,
      invoice: invoice,
      externalObservations: [observation],
      incisiveObservations: [observation],
      mucousObservations: [observation],
      internalObservations: [observation],
      otherObservations: [observation],
    );

    Intervention? updatedIntervention;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InterventionCardWidget(
            intervention: intervention,
            openWithCreateInterventionPage: true,
            isEditing: true,
            proID: 'pro1',
            onInterventionUpdated: (i) => updatedIntervention = i,
          ),
        ),
      ),
    );

    // Vérifie la présence du titre
    expect(find.text('Intervention'), findsOneWidget);

    // Vérifie la présence du champ "Notes observation externe"
    expect(find.widgetWithText(TextField, 'Notes observation externe'), findsOneWidget);

    // Modifie le champ "Notes observation externe"
    await tester.enterText(find.widgetWithText(TextField, 'Notes observation externe'), 'Nouvelle note');
    await tester.pumpAndSettle();

    // Vérifie que le callback onInterventionUpdated a été appelé avec la nouvelle valeur
    expect(updatedIntervention?.externalNotes, 'Nouvelle note');
  });
}