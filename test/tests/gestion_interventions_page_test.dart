import 'package:equipro/src/widgets/card/client/clientsComboCardWidget.dart';
import 'package:equipro/src/widgets/card/intervention/horsesComboCardWidget.dart';
import 'package:equipro/src/widgets/card/intervention/interventionCardWidget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:equipro/src/pages/intervention/createIntervention.dart'; 
import 'package:equipro/src/pages/intervention/listInterventionHorse.dart';


void main() {
  testWidgets('CreateInterventionPage affiche bien tous les widgets principaux', (tester) async {
    const simulatedProID = 'testProID123';

    // Monte la page dans un MaterialApp (avec GoRouter si nécessaire)
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/createIntervention',
              builder: (context, state) => CreateInterventionPage(proId: simulatedProID),
            ),
          ],
          initialLocation: '/createIntervention',
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ClientsComboCardWidget), findsOneWidget);

    expect(find.byType(HorsesComboCardWidget), findsOneWidget);

    expect(find.byType(InterventionCardWidget), findsOneWidget);

    // Vérifie la présence du FloatingActionButton avec l'icône save
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.save), findsOneWidget);

    // Vérifie la présence du titre dans l'AppBar
    expect(find.text('Créer une intervention'), findsOneWidget);
  });

    testWidgets('ListIntervention affiche bien tous les widgets principaux', (tester) async {
    const simulatedProID = 'testProID123';

    // Monte la page dans un MaterialApp (avec GoRouter si nécessaire)
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/listIntervention',
              builder: (context, state) => HorseInterventionListWidget(proID: simulatedProID),
            ),
          ],
          initialLocation: '/listIntervention',
        ),
      ),
    );

    //await tester.pumpAndSettle();

    // Vérifie la présence du FloatingActionButton avec l'icône save
    expect(find.byType(FloatingActionButton), findsOneWidget);


    // Vérifie la présence du titre dans l'AppBar
    expect(find.text('Interventions'), findsOneWidget);
  });
  
}
