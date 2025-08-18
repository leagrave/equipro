import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/widgets/card/ecurie/ecurieCardWidget.dart';
import 'package:equipro/src/models/ecurie.dart';

void main() {
  testWidgets('EcurieCardWidget affiche et modifie les champs principaux', (WidgetTester tester) async {
    // Création d'une écurie de test
    final ecurie = Ecurie(
      id: 'e1',
      name: 'Écurie Bleue',
      user_id: 'u1',
      addressId: 'a1',
      phone: '0102030405',
      phone2: '0607080910',
    );

    Ecurie? updatedEcurie;
    bool saveCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EcurieCardWidget(
            proID: 'pro1',
            ecurie: ecurie,
            onUpdated: (e) => updatedEcurie = e,
            onSave: () => saveCalled = true,
            openWithCreateHorsePage: false,
          ),
        ),
      ),
    );

    // Vérifie la présence des champs principaux
    expect(find.widgetWithText(TextField, "Nom de l’écurie"), findsOneWidget);
    expect(find.widgetWithText(TextField, "ID Propriétaire"), findsOneWidget);
    expect(find.widgetWithText(TextField, "ID Adresse"), findsOneWidget);
    expect(find.widgetWithText(TextField, "Téléphone"), findsOneWidget);
    expect(find.widgetWithText(TextField, "Téléphone secondaire"), findsOneWidget);

    // Passe en mode édition
    await tester.tap(find.text('Modifier'));
    await tester.pumpAndSettle();

    // Modifie le champ "Nom de l’écurie"
    await tester.enterText(find.widgetWithText(TextField, "Nom de l’écurie"), 'Écurie Rouge');
    await tester.pumpAndSettle();

    // Sauvegarde les modifications
    await tester.tap(find.text('Sauvegarder'));
    await tester.pumpAndSettle();

    // Vérifie que le callback onUpdated a été appelé avec la nouvelle valeur
    expect(updatedEcurie?.name, 'Écurie Rouge');
    expect(saveCalled, isTrue);
  });
}