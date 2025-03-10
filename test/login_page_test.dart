import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/router/router.dart';
import 'package:equipro/src/widgets/bar/horizontalScrollWidget.dart';
import 'package:equipro/src/widgets/event/evenementsListWidget.dart';

void main() {
  testWidgets('Test de la page de connexion avec GoRouter', (WidgetTester tester) async {
    // Construire l'application avec GoRouter pour la navigation
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: go, 
      ),
    );

    // Vérifier la présence des éléments de la page de connexion
     expect(find.text('Bienvenue sur EquiPro'), findsOneWidget);
     expect(find.text('Connectez-vous à votre compte'), findsOneWidget);
     expect(find.byType(TextField), findsNWidgets(2)); // Email et Mot de passe
     expect(find.byType(ElevatedButton), findsOneWidget); // Bouton "Se connecter"

    // // Vérifier l'interaction avec le champ e-mail
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    expect(find.byType(TextField).first, findsWidgets);

    // // Vérifier l'interaction avec le champ mot de passe
    await tester.enterText(find.byType(TextField).last, 'password123');
    expect(find.byType(TextField).last, findsWidgets);

    // // Vérifier que le bouton "Se connecter" fonctionne et effectue la navigation
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // Attendre la fin de la navigation

    // Vérifier la navigation après le clic sur "Se connecter" vers la page principale
    // En passant les arguments dans l'extra pour simuler la redirection avec initialPageIndex = 2
    expect(find.byType(HorizontalScrollWidget), findsOneWidget); // Vérifie si HorizontalScrollWidget est bien présent
    expect(find.byType(MyWidgetAppointments), findsOneWidget); // Vérifie si MyWidgetAppointments est bien présent
  });
}
