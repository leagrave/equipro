import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:equipro/router/splash.dart'; 
import 'package:flutter/services.dart';


void main() {
  const MethodChannel storageChannel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  // Simuler un stockage interne
  final Map<String, String> fakeStorage = {};

  setUp(() {
    storageChannel.setMockMethodCallHandler((MethodCall methodCall) async {
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
        default:
          return null;
      }
    });
  });

  tearDown(() {
    storageChannel.setMockMethodCallHandler(null);
    fakeStorage.clear();
  });

  late GoRouter router;

  setUp(() {
    router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const Scaffold(body: Text('Pro Home'))),
        GoRoute(path: '/homeClient', builder: (_, __) => const Scaffold(body: Text('Client Home'))),
        GoRoute(path: '/login', builder: (_, __) => const Scaffold(body: Text('Login'))),
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(),
        ),
      ],
      initialLocation: '/splash',
    );
  });

  testWidgets('Redirige vers / quand pro', (tester) async {
    // Pré-remplir le stockage simulé
    fakeStorage['authToken'] = 'token123';
    fakeStorage['userData'] = '{"professional":true}';

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Pro Home'), findsOneWidget);
  });

  testWidgets('Redirige vers /homeClient quand pas pro', (tester) async {
    fakeStorage['authToken'] = 'token123';
    fakeStorage['userData'] = '{"professional":false}';

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Client Home'), findsOneWidget);
  });

  testWidgets('Redirige vers /login quand pas de token', (tester) async {
    fakeStorage.clear();

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
  });
}
