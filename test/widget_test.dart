import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/main.dart'; 

void main() {
  testWidgets('Vérifie que le bouton de connexion existe', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Se connecter'), findsOneWidget);
  });
}
