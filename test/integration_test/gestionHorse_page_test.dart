import 'package:equipro/src/pages/horse/listHorse.dart';
import 'package:equipro/src/pages/horse/managementHorse.dart';
import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:equipro/src/widgets/list/horseListWidget.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:go_router/go_router.dart';

void main() {

    final fakeHorses = [
      {
        "id": "horse1",
        "name": "Tornado",
        "age": 7,
        "stableId": "stable1",
        "lastVisitDate": null,
        "nextVisitDate": null,
        "notes": "Cheval rapide",
        "users": [],
        "breeds": null,
        "colors": null,
        "feedTypes": null,
        "activityTypes": null,
        "address": null
      }
    ];

      final fakeHorse = Horse(
        id: "horse123",
        name: "Flash",
        age: 5,
        stableId: "stable1",
        lastVisitDate: null,
        nextVisitDate: null,
        notes: "Cheval rapide",
        users: null,
        breeds: null,
        colors: null,
        feedTypes: null,
        activityTypes: null,
        address: null,
      );

      
  testWidgets('ListHorsePage affiche champ recherche, bouton flottant et titre Mes Chevaux',
      (WidgetTester tester) async {

    // Mock API
    ApiService.mockGetWithAuth = (endpoint) async {
      return http.Response(jsonEncode(fakeHorses), 200);
    };

    // Lance la page
    await tester.pumpWidget(
      const MaterialApp(
        home: ListHorsePage(
          proID: 'pro123',
          userCustomerID: 'user123',
        ),
      ),
    );

    // Laisse le temps de charger
    await tester.pumpAndSettle();

    // Vérifie la présence du titre
    expect(find.text('Mes Chevaux'), findsOneWidget);

    // Vérifie la présence du champ de recherche
    expect(find.byType(TextField), findsOneWidget);

    // Vérifie la présence du bouton flottant
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Nettoyage mock
    ApiService.mockGetWithAuth = null;
  });

   testWidgets('Affiche le nom du cheval quand la liste contient un cheval', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HorseListWidget(
            horses: [fakeHorse],
            onHorseTap: (_) {},
            isFromListHorsePage: true, 
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // On vérifie que le nom du cheval apparaît
    expect(find.text('Flash'), findsOneWidget);
    // On vérifie que "Aucun cheval trouvé" n'apparaît pas
    expect(find.text('Aucun cheval trouvé'), findsNothing);
  });

  testWidgets('Affiche "Aucun cheval trouvé" quand la liste est vide', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HorseListWidget(
            horses: [],
            onHorseTap: (_) {},
            isFromListHorsePage: true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // On vérifie que le texte est bien affiché
    expect(find.text('Aucun cheval trouvé'), findsOneWidget);
    // On vérifie qu’aucun nom de cheval n’est affiché
    expect(find.text('Flash'), findsNothing);
  });
  testWidgets('Navigation vers ManagementHorsePage quand on clique sur un cheval', (tester) async {

    final fakeHorse = Horse(
      id: "horse123",
      name: "Flash",
      age: 5,
      stableId: "stable1",
      lastVisitDate: null,
      nextVisitDate: null,
      notes: "Cheval rapide",
      users: null,
      breeds: null,
      colors: null,
      feedTypes: null,
      activityTypes: null,
      address: null,
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return Scaffold(
              body: HorseListWidget(
                horses: [fakeHorse],
                isFromListHorsePage: true,
                onHorseTap: (horse) {
                  context.push('/managementHorse', extra: {
                    'horseId': horse.id,
                    'proID': 'pro123',
                  });
                },
              ),
            );
          },
        ),
        GoRoute(
          path: '/managementHorse',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ManagementHorsePage(
              horseId: extra['horseId'],
              proID: extra['proID'],
            );
          },
        ),
      ],
    );

    // Monte l'application avec le router
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    ApiService.mockGetWithAuth = (endpoint) async {
      if (endpoint.startsWith("/horse/by-id/")) {
        return http.Response(jsonEncode({
          "id": "horse123",
          "name": "Flash",
          "age": 5,
          "stableId": null,
          "lastVisitDate": null,
          "nextVisitDate": null,
          "notes": "Cheval rapide",
          "users": [],
          "breeds": [],
          "colors": [],
          "feedTypes": [],
          "activityTypes": [],
          "address": [],
        }), 200);
      }
      if (endpoint.startsWith("/stables/owner/")) {
        return http.Response(jsonEncode([]), 200);
      }
      if (endpoint.startsWith("/agendaAll/")) {
        return http.Response(jsonEncode([]), 200);
      }
      if (endpoint == "/infosHorse") {
        return http.Response(jsonEncode({
          "breeds": [
            {"id": 1, "name": "Pur-sang"},
            {"id": 2, "name": "Frison"}
          ],
          "colors": [
            {"id": 1, "name": "Noir"},
            {"id": 2, "name": "Alezan"}
          ],
          "feedTypes": [
            {"id": 1, "name": "Foin"},
            {"id": 2, "name": "Granulés"}
          ],
          "activityTypes": [
            {"id": 1, "name": "Dressage"},
            {"id": 2, "name": "Saut d'obstacles"}
          ]
        }), 200);
      }
      return http.Response(jsonEncode([]), 200);
    };

    await tester.pumpAndSettle();

    // Vérifie que le cheval apparaît
    expect(find.text('Flash'), findsOneWidget);

    // Simule un clic sur le cheval
    await tester.tap(find.text('Flash'));
    await tester.pumpAndSettle();

    // Vérifie que ManagementHorsePage est affichée
    expect(find.byType(ManagementHorsePage), findsOneWidget);
    expect(find.text('Gestion cheval'), findsOneWidget);

    ApiService.mockGetWithAuth = null;
  });

}
