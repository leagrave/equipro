import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/pages/horse/createHorse.dart';
import 'package:equipro/src/pages/horse/listHorse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:equipro/src/widgets/list/horseListWidget.dart';
import 'package:equipro/src/services/apiService.dart';

void main() {
  group('ListHorsePage Widget Tests', () {
    testWidgets(
      'Vérifie titre, bouton flottant et redirection vers CreateHorsePage',
      (WidgetTester tester) async {
        final goRouter = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) =>
                  ListHorsePage(proID: 'pro1', userCustomerID: 'user1'),
            ),
            GoRoute(
              path: '/createHorse',
              builder: (context, state) =>
                  CreateHorsePage(proID: 'pro1', userCustomId: 'user1'),
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));
        await tester.pumpAndSettle();

        // Vérifie le titre et le FloatingActionButton
        expect(find.text('Mes Chevaux'), findsOneWidget);
        expect(find.text('Aucun cheval trouvé'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);

        // Tap sur le FloatingActionButton pour aller sur CreateHorsePage
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.byType(CreateHorsePage), findsOneWidget);
        expect(find.text('Créer un cheval'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
      },
    );
  });

  testWidgets('Navigation vers CreateHorsePage quand on clique sur le btn plus', (tester) async {
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
                  context.push('/createHorse', extra: {
                    'horseId': horse.id,
                    'proID': 'pro123',
                  });
                },
              ),
            );
          },
        ),
        GoRoute(
          path: '/createHorse',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return CreateHorsePage(
              proID: extra['proID'],
            );
          },
        ),
      ],
    );

   ApiService.mockGetWithAuth = (endpoint) async {
    if (endpoint == "/horses") {
      return http.Response(jsonEncode([
        {
          "id": "horse123",
          "name": "Flash",
          "age": 5,
          "stableId": "stable1",
          "lastVisitDate": null,
          "nextVisitDate": null,
          "notes": "Cheval rapide",
          "users": [],
          "breeds": [],
          "colors": [],
          "feedTypes": [],
          "activityTypes": [],
          "address": null
        }
      ]), 200);
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


    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.pumpAndSettle();

    // Vérifie que le cheval apparaît
    expect(find.text('Flash'), findsOneWidget);

    // Clique sur le cheval
    await tester.tap(find.text('Flash'));
    await tester.pumpAndSettle();

    // Vérifie que CreateHorsePage est affichée
    expect(find.byType(CreateHorsePage), findsOneWidget);
    expect(find.text('Créer un cheval'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    ApiService.mockPostWithAuth = (endpoint) async {
      expect(endpoint, '/horse');
      return http.Response(jsonEncode({'success': true}), 201); 
    };

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    ApiService.mockGetWithAuth = null;
    ApiService.mockPostWithAuth = null;
  });

}
