import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/pages/intervention/createIntervention.dart';
import 'package:equipro/src/pages/intervention/listInterventionHorse.dart';
import 'package:equipro/src/widgets/card/intervention/interventionCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:equipro/src/utils/constants.dart';

import 'package:equipro/src/pages/intervention/createIntervention.dart';
import 'package:equipro/src/pages/intervention/listInterventionHorse.dart';
import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/models/intervention.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../mocks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';



void main() {

  // Créons un fakeHorse
// final fakeHorse = Horse(
//   id: "horse1",
//   name: "Foudre",
//   age: 7,

// );

// // Puis on l'associe à l'intervention
// final fakeInterventions = [
//   Intervention(
//     id: "intervention1",
//     description: "Nettoyage des dents",
//     careObservation: "RAS",
//     interventionDate: DateTime.now(),
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     users: [],
//     horse: fakeHorse,  // <- ici
//     pro: null,
//     invoice: null,
//     externalNotes: "Note externe",
//     incisiveNotes: null,
//     mucousNotes: null,
//     internalNotes: null,
//     otherNotes: null,
//     externalObservations: [],
//     incisiveObservations: [],
//     mucousObservations: [],
//     internalObservations: [],
//     otherObservations: [],
//   ),
// ];



//   testWidgets('ListInterventionPage affiche champ recherche, titre et bouton flottant',
//     (WidgetTester tester) async {

//       ApiService.mockGetWithAuth = (endpoint) async {
//         if (endpoint.startsWith("/interventions/user")) {
//           return http.Response(jsonEncode([
//             {
//               "id": "1",
//               "intervention_date": "2025-08-15",
//               "description": "Contrôle dent",
//               "horse": {"id": "2", "name": "Foudre"},
//               "pro": {"id": "1", "first_name": "Louis", "last_name": "Pierre", "email": "pierre@ex.com", "professional": true},
//               "users": [
//                 {"id": "3", "first_name": "Jean", "last_name": "Dupont", "email": "j@ex.com", "professional": false}
//               ]
//             }
//           ]), 200);
//         }
//         return http.Response(jsonEncode([]), 200);
//       };



//     // Lance la page
//     await tester.pumpWidget(
//       MaterialApp(
//         home: HorseInterventionListWidget(
//           userId: '123',
//           proID: 'pro123',
//         ),
//       ),
//     );

// await tester.pumpAndSettle(const Duration(seconds: 35));

//     expect(find.text('Interventions'), findsOneWidget);
//     expect(find.byType(TextField), findsOneWidget);
//     expect(find.byType(FloatingActionButton), findsOneWidget);
//     expect(find.widgetWithText(TextField, 'Rechercher (cheval, date)'), findsOneWidget);

//     ApiService.mockGetWithAuth = null;
//   });

// testWidgets('Affiche "Aucune intervention trouvée" quand la liste est vide', (tester) async {

//   ApiService.mockGetWithAuth = (endpoint) async {
//     if (endpoint.startsWith("/interventions/user")) {
//       return http.Response(jsonEncode([]), 200);
//     }
//     return http.Response(jsonEncode([]), 200);
//   };


//       await tester.pumpWidget(
//         MaterialApp(
//           home: HorseInterventionListWidget(
//             userId: '123', 
//             proID: 'pro123',
//           ),
//         ),
//       );



//       await tester.pump(); 
//       await tester.pumpAndSettle(const Duration(seconds: 10));

//       expect(find.text('Interventions'), findsOneWidget);
//       //expect(find.text('Aucune intervention trouvée'), findsOneWidget);
//       expect(find.byType(FloatingActionButton), findsOneWidget);

//   });

//   testWidgets('Créer une intervention', (tester) async {
//     final router = GoRouter(
//       routes: [
//         GoRoute(
//           path: '/',
//           builder: (context, state) {
//             return Scaffold(
//               body: CreateInterventionPage(
//                   userId: '123', 
//                   proId: 'pro123',
//               ),
//             );
//           },
//         ),

//       ],
//     );

//     await tester.pumpWidget(MaterialApp.router(routerConfig: router));

//     ApiService.mockGetWithAuth = (endpoint) async {
//       if (endpoint.startsWith("/agendaAll/")) {
//         return http.Response(jsonEncode([]), 200);
//       }
//       if (endpoint.startsWith("/horses/users/")) {
//         return http.Response(jsonEncode([]), 200);
//       }
//       return http.Response(jsonEncode([]), 200);
//     };

//     await tester.pumpAndSettle();

//     await tester.pumpAndSettle();

//     expect(find.text('Créer une intervention'), findsOneWidget);

//   });

}

