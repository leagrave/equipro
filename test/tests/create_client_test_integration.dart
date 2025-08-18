import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/pages/client/createClient.dart';
import 'package:equipro/src/widgets/card/client/clientCardWidget.dart';
import 'package:equipro/src/widgets/card/noteCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientAdresseCardWidget.dart';
import 'package:equipro/src/services/apiService.dart';
import 'package:http/http.dart' as http;

void main() {
  setUp(() {
    // Mock les appels API pour éviter les vraies requêtes réseau
    ApiService.mockGetWithAuth = (endpoint) async =>
        http.Response('{"exists": false}', 200);
    ApiService.mockPostWithAuth = (endpoint) async =>
        http.Response('{"id": "user123"}', 201);
  });

  tearDown(() {
    ApiService.mockGetWithAuth = null;
    ApiService.mockPostWithAuth = null;
  });

  testWidgets('Affichage et soumission du formulaire CreateClientPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CreateClientPage(proID: 'pro1'),
      ),
    );

    // Vérifie la présence des widgets principaux
    expect(find.byType(ClientCardWidget), findsOneWidget);
    expect(find.byType(AddressCardWidget), findsOneWidget);
    expect(find.byType(NotesCardWidget), findsOneWidget);

    // Remplis les champs obligatoires du formulaire client
    await tester.enterText(find.widgetWithText(TextFormField, 'Nom *'), 'TestNom');
    await tester.enterText(find.widgetWithText(TextFormField, 'Prénom *'), 'TestPrenom');
    await tester.enterText(find.widgetWithText(TextFormField, 'E-mail *'), 'test@email.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Téléphone'), '0600000000');
    await tester.enterText(find.widgetWithText(TextFormField, 'Mot de passe *'), 'azerty123');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirmation mot de passe'), 'azerty123');

    // Simule la soumission du formulaire
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // Vérifie qu'une boîte de dialogue s'affiche (client enregistré)
    expect(find.text('Client enregistré'), findsOneWidget);
  });
}