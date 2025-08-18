import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/pages/agenda.dart';
import 'package:equipro/src/pages/client/listClient.dart'; 

void main() {
  testWidgets('MyAgendaPage affiche ListClientPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyAgendaPage(userId: '123'),
      ),
    );

    // Vérifie que le widget ListClientPage est bien présent
    expect(find.byType(ListClientPage), findsOneWidget);

    // Vérifie que le gradient est bien appliqué
    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.gradient, isNotNull);
  });
}