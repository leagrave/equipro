import 'dart:convert';
import 'package:equipro/src/pages/login.dart';
import 'package:equipro/src/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:equipro/src/services/apiService.dart';
import 'package:http/http.dart' as http;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel storageChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  final Map<String, String> fakeStorage = {};

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'write':
          final key = methodCall.arguments['key'] as String;
          final value = methodCall.arguments['value'] as String?;
          if (value != null) {
            fakeStorage[key] = value;
          } else {
            fakeStorage.remove(key);
          }
          return null;
        case 'read':
          final key = methodCall.arguments['key'] as String;
          return fakeStorage[key];
        case 'delete':
          final key = methodCall.arguments['key'] as String;
          fakeStorage.remove(key);
          return null;
        case 'deleteAll':
          fakeStorage.clear();
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, null);
    fakeStorage.clear();
  });

  setUpAll(() {
    ApiService.mockGetWithAuth = (endpoint) async {
      if (endpoint == '/user/pro/user123') {
        return http.Response(jsonEncode({
          "id": "user123",
          "firstName": "Jean",
          "lastName": "Dupont",
          "professional": true,
          "isVerified": true
        }), 200);
      }
      return http.Response('{}', 404);
    };
  });

  tearDownAll(() {
    ApiService.mockGetWithAuth = null;
  });

  late GoRouter router;

  setUp(() {
    router = GoRouter(
      initialLocation: '/settings',
      routes: [
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => MyLoginPage(),
        ),
      ],
    );
  });

  testWidgets(
      'Affiche bouton déconnexion et redirige vers login après clic + supprime storage',
      (tester) async {
    // Pré-remplir le stockage simulé
    fakeStorage['authToken'] = 'token123';
    fakeStorage['userData'] = jsonEncode({
      "id": "user123",
      "firstName": "Jean",
      "lastName": "Dupont",
      "professional": true,
      "isVerified": true
    });

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Déconnexion'), findsOneWidget);

    // Clique sur Déconnexion
    await tester.ensureVisible(find.text('Déconnexion'));
    await tester.tap(find.text('Déconnexion'));
    await tester.pumpAndSettle();

    // Vérifie la redirection
    expect(find.text('Bienvenue sur EquiPro'), findsOneWidget);

    // Vérifie que le storage est vidé
    expect(fakeStorage.containsKey('authToken'), false);
    expect(fakeStorage.containsKey('userData'), false);
  });
}