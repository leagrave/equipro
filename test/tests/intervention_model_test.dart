import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/models/intervention.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/invoice.dart';
import 'package:equipro/src/models/observation.dart';

void main() {
  group('Intervention', () {
        final user = Users(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@email.com',
      professional: false,
    );
    final horse = Horse(id: 'h1', name: 'Spirit');
        final invoice = Invoice(
      id: 'inv1',
      number: '2024-001',
      title: 'Facture test',
      totalAmount: 100.0,
      user_id: '1',
      pro_id: '1',
    );

    final observation = Observation(
      id: 'obs1',
      observationName: 'Observation test',
    );


    final intervention = Intervention(
      id: 'int1',
      description: 'Test intervention',
      careObservation: 'Care obs',
      interventionDate: DateTime(2024, 1, 1),
      createdAt: DateTime(2024, 1, 2),
      updatedAt: DateTime(2024, 1, 3),
      users: [user],
      horse: horse,
      pro: user,
      invoice: invoice,
      externalNotes: 'External',
      incisiveNotes: 'Incisive',
      mucousNotes: 'Mucous',
      internalNotes: 'Internal',
      otherNotes: 'Other',
      externalObservations: [observation],
      incisiveObservations: [observation],
      mucousObservations: [observation],
      internalObservations: [observation],
      otherObservations: [observation],
    );

    test('toJson and fromJson', () {
      final json = intervention.toJson();
      final fromJson = Intervention.fromJson({
        ...json,
        'users': [user.toJson()],
        'horse': horse.toJson(),
        'pro': user.toJson(),
        'invoice': invoice.toJson(),
        'external_observations': [observation.toJson()],
        'incisive_observations': [observation.toJson()],
        'mucous_observations': [observation.toJson()],
        'internal_observations': [observation.toJson()],
        'other_observations': [observation.toJson()],
      });
      expect(fromJson.id, intervention.id);
      expect(fromJson.description, intervention.description);
      expect(fromJson.horse?.id, horse.id);
      expect(fromJson.externalObservations?.first.id, observation.id);
    });

    test('copyWith returns a copy with updated values', () {
      final copy = intervention.copyWith(description: 'New desc');
      expect(copy.description, 'New desc');
      expect(copy.id, intervention.id);
    });

    test('toString returns a string', () {
      expect(intervention.toString(), contains('Intervention('));
      expect(intervention.toString(), contains('Spirit'));
      expect(intervention.toString(), contains('John Doe'));
    });
  });
}