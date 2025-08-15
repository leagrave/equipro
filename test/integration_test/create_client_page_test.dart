import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:equipro/src/pages/client/createClient.dart'; 
import 'package:equipro/src/widgets/card/client/clientCardWidget.dart';  
import 'package:equipro/src/widgets/card/noteCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientAdresseCardWidget.dart';
import 'package:equipro/src/models/user.dart';
import '../mocks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/testing.dart';


void main() {
  testWidgets('CreateClientPage affiche bien tous les widgets principaux', (tester) async {
    const simulatedProID = 'testProID123';

    // Monte la page dans un MaterialApp (avec GoRouter si nécessaire)
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/createClient',
              builder: (context, state) => CreateClientPage(proID: simulatedProID),
            ),
          ],
          initialLocation: '/createClient',
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Vérifie la présence de ClientCardWidget
    expect(find.byType(ClientCardWidget), findsOneWidget);

    // Vérifie la présence de AddressCardWidget
    expect(find.byType(AddressCardWidget), findsOneWidget);

    // Vérifie la présence de NotesCardWidget
    expect(find.byType(NotesCardWidget), findsOneWidget);

    // Vérifie la présence du FloatingActionButton avec l'icône save
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.save), findsOneWidget);

    // Vérifie la présence du titre dans l'AppBar
    expect(find.text('Créer un client'), findsOneWidget);
  });

  testWidgets('Validation du formulaire empêche sauvegarde si champs invalides', (tester) async {
    // Création d'un utilisateur test
    final testUser = Users(
      id: '123',
      lastName: '',
      firstName: '',
      phone: '',
      phone2: '',
      email: 'invalid-email',
      professional: false,
      isSociete: false,
      societeName: '',
    );

    // Monte le widget ClientCardWidget avec l'utilisateur test
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClientCardWidget(
            user: testUser,
            openWithCreateClientPage: false,
            openWithCreateHorsePage: false,
          ),
        ),
      ),
    );

    // Clique sur le bouton "Modifier" pour activer l'édition
    final modifierButton = find.text('Modifier');
    expect(modifierButton, findsOneWidget);
    await tester.tap(modifierButton);
    await tester.pumpAndSettle();

    // Le bouton doit maintenant être "Enregistrer"
    final enregistrerButton = find.text('Enregistrer');
    expect(enregistrerButton, findsOneWidget);

    // Tente d'appuyer sur "Enregistrer" avec les champs invalides
    await tester.tap(enregistrerButton);
    await tester.pump(); 

    await tester.pumpAndSettle(const Duration(seconds: 5));
    //expect(find.textContaining("Tous le nom ou prénom doit être remplis"), findsOneWidget);
    expect(find.text("Tous le nom ou prénom doit être remplis"), findsOneWidget);

    // Remplis un nom valide
    await tester.enterText(find.widgetWithText(TextFormField, 'Nom'), 'Dupont');
    await tester.pump();

    // Corrige l'email invalide
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@example.com');
    await tester.pump();

    // Remets un numéro de téléphone valide
    await tester.enterText(find.widgetWithText(TextFormField, 'Téléphone'), '0123456789');
    await tester.pump();


    // Clique de nouveau sur "Enregistrer"
    await tester.tap(enregistrerButton);
    await tester.pump(); 
    await tester.pumpAndSettle();

    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text("Tous le nom ou prénom doit être remplis"), findsOneWidget);



  });

    group('UserService.createUser', () {
    test('retourne true quand le serveur répond 201', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), contains('/users'));
        expect(request.method, 'POST');
        final body = jsonDecode(request.body);
        expect(body['email'], 'test@example.com');

        return http.Response('', 201);
      });

      final service = UserService(client: mockClient);
      final result = await service.createUser({
        'email': 'test@example.com',
        'firstName': 'Jean',
        'lastName': 'Dupont',
      });

      expect(result, isTrue);
    });

    test('retourne false quand le serveur répond une erreur', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Erreur', 400); 
      });

      final service = UserService(client: mockClient);
      final result = await service.createUser({
        'email': 'invalid-email',
      });

      expect(result, isFalse);
    });
  });
  
}
