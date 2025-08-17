import 'package:equipro/src/widgets/list/clientListWidget.dart';
import 'package:equipro/src/widgets/list/horseListWidget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:equipro/src/pages/client/managementClient.dart';
import 'package:equipro/src/pages/client/listClient.dart';
import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/adresses.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Création du cheval adresses
    final fakeAddress = Address(
    idAddress: "addr123",
    address: "12 rue de Paris",
    city: "Paris",
    postalCode: "75000",
    country: "France",
    latitude: null,
    longitude: null,
    user_id: "user123",
    horse_id: null,
    type: "main",
  );

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

  final fakeUser = Users(
    id: "user123",
    customer_id: null,
    firstName: "Jean",
    lastName: "Dupont",
    email: "jean.dupont@example.com",
    professional: false,
    password: null,
    typeProfessional: null,
    isSociete: null,
    societeName: null,
    isVerified: null,
    siretNumber: null,
    phone: "0123456789",
    phone2: null,
    lastVisitDate: null,
    nextVisitDate: null,
    notes: null,
    addresses: [fakeAddress],
    horses: [fakeHorse],
    ecuries: null,
  );

    final fakeUsers = [
      {
        "id": 1,
        "lastName": "Dupont",
        "firstName": "Jean",
        "phone": "0123456789",
        "addresses": [],
        "horses": []
      }
    ];

    

  testWidgets('ListClientPage affiche TextField et FloatingActionButton', (tester) async {
 
    ApiService.mockGetWithAuth = (endpoint) async {
      return http.Response(jsonEncode(fakeUsers), 200);
    };

    await tester.pumpWidget(
      MaterialApp(
        home: ListClientPage(userId: '123'),
      ),
    );


    await tester.pumpAndSettle();


    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Rechercher par nom, prénom, tel, ville ou cheval'), findsOneWidget);
    ApiService.mockGetWithAuth = null;
    
  });

  testWidgets('ClientListWidget affiche correctement le nom, la ville et chevaux', (tester) async {
 
    final filteredUsers = [fakeUser];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: ClientListWidget(
            currentUserId: 'user123',
            filteredUsers: filteredUsers,
            onClientTap: (user) {
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Dupont Jean'), findsOneWidget);
    expect(find.text('Paris'), findsOneWidget);

    expect(
      find.byWidgetPredicate((widget) {
        if (widget is HorseListWidget) {
          return widget.horses.any((horse) => horse.id == fakeHorse.id);
        }
        return false;
      }),
      findsOneWidget,
    );

    await tester.tap(find.text('Voir plus'));
    await tester.pumpAndSettle();
    expect(find.text('Flash'), findsOneWidget);

    expect(find.byIcon(Icons.call), findsWidgets);
    expect(find.byIcon(Icons.message), findsWidgets);
  });

  testWidgets('Navigation vers ManagementClientPage avec clic sur client',
    (WidgetTester tester) async {

      final filteredUsers = [fakeUser];

        final GoRouter router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: ClientListWidget(
                  currentUserId: 'user123',
                  filteredUsers: filteredUsers,
                  onClientTap: (user) {
                    context.go(
                      '/managementClient',
                      extra: {
                        'userSelected': user,
                        'currentUserId': 'user123',
                      },
                    );
                  },
                ),
              ),
            ),
            GoRoute(
              path: '/managementClient',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final userSelected = extra?['userSelected'] as Users?;
                final currentUserId = extra?['currentUserId'] as String?;

                return ManagementClientPage(
                  userSelected: userSelected!,
                  currentUserId: currentUserId!,
                );
              },
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(
          routerConfig: router,
        ));

        await tester.pumpAndSettle();

        // Vérifie que le nom complet du client est bien affiché
        final clientNameFinder = find.text('${fakeUser.lastName} ${fakeUser.firstName}');
        expect(clientNameFinder, findsOneWidget);

        // Simule un clic sur le nom
        await tester.tap(clientNameFinder);
        await tester.pumpAndSettle();

        // Vérifie que la page de gestion s'affiche
        expect(find.text('Gestion client'), findsOneWidget);
      });
}
