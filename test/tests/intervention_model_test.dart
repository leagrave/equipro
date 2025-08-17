import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/intervention.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Intervention', () {
    test('fromJson et toJson fonctionnent correctement', () {
      final json = {
        'id': '1',
        'description': 'Contrôle dentaire',
        'care_observation': 'Nettoyage des dents',
        'intervention_date': '2025-08-16T10:00:00.000Z',
        'created_at': '2025-08-15T09:00:00.000Z',
        'updated_at': '2025-08-15T09:30:00.000Z',
        'users': [
          {
            'id': 'u1',
            'first_Name': 'John',
            'last_Name': 'Doe',
            'email': 'john@email.com',
            'professional': false
          }
        ],
        'horse': {'id': 'h1', 'name': 'Spirit'},
        'pro': {
          'id': 'u2',
          'first_Name': 'Vet',
          'last_Name': 'Doc',
          'email': 'doc@email.com',
          'professional': true
        },
        'invoice': {'id': 'inv1', 'amount': 100.0},
        'external_notes': 'Aucune anomalie',
        'external_observations': [
          {'id': 'o1', 'observation_name': 'Observation externe 1'}
        ]
      };

      // Conversion JSON -> Intervention
      final intervention = Intervention.fromJson(json);

      // Vérifications des valeurs
      expect(intervention.id, '1');
      expect(intervention.description, 'Contrôle dentaire');
      expect(intervention.careObservation, 'Nettoyage des dents');
      expect(intervention.interventionDate,
          DateTime.parse('2025-08-16T10:00:00.000Z'));
      expect(intervention.horse?.name, 'Spirit');
      expect(intervention.users.length, 1);
      expect(intervention.users.first.firstName, 'John');
      expect(intervention.users.first.lastName, 'Doe');
      expect(intervention.pro?.firstName, 'Vet');
      expect(intervention.pro?.lastName, 'Doc');
      expect(intervention.externalObservations?.first.observationName,
          'Observation externe 1');

      // Conversion Intervention -> JSON
      final jsonResult = intervention.toJson();

      expect(jsonResult['id'], '1');
      expect(jsonResult['description'], 'Contrôle dentaire');
      expect(jsonResult['users'][0]['first_Name'], 'John');
      expect(jsonResult['users'][0]['last_Name'], 'Doe');
      expect(jsonResult['users'][0]['professional'], false);
      expect(jsonResult['horse']['name'], 'Spirit');
      expect(jsonResult['external_observations'][0]['observation_name'],
          'Observation externe 1');
    });

    test('copyWith fonctionne correctement', () {
      final original = Intervention(
        id: '1',
        users: [],
      );

      final copy = original.copyWith(description: 'Nouvelle description');

      expect(copy.id, '1');
      expect(copy.description, 'Nouvelle description');
      expect(copy.users, original.users);
    });

    test('toString contient les infos principales', () {
      final intervention = Intervention(
        id: '1',
        users: [
          Users(
            id: 'u1',
            firstName: 'John',
            lastName: 'Doe',
            email: 'john@email.com',
            professional: false,
          )
        ],
      );

      final str = intervention.toString();
      expect(str.contains('id: 1'), true);
      expect(str.contains('John'), true);
      expect(str.contains('Doe'), true);
    });
  });
}
